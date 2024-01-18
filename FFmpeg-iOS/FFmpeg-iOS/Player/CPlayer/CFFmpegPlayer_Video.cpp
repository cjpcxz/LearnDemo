//
//  CFFmpegPlayer_Video.cpp
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2024/1/8.
//

#include <stdio.h>
#include <iostream>
#include "SDL.h"
#include "CFFmpegPlayer.hpp"
extern "C" {
#include <libavutil/imgutils.h>
}
using namespace std;

#define ERROR_BUF \
char errbuf[1024]; \
    av_strerror(ret, errbuf, sizeof (errbuf));

#define RET(func) \
if (ret < 0) { \
        ERROR_BUF; \
        cout << #func << "error: " << errbuf << endl; \
        return ret; \
}

int CFFmpegPlayer::initVideoInfo() {
    int ret = initDecoder(&_vDecodeCtx, &_vStream, AVMEDIA_TYPE_VIDEO);
    RET(initDecoder)
    // 初始化视频像素格式转换,不用像素格式转换，直接用YUP420
    ret = initSws();
    RET(initSws)
    return 0;
}


//初始化像素格式转换
int CFFmpegPlayer::initSws() {
    // 取16位的整数，有助于转换效率
    _vSwsOutSpec.width = _vDecodeCtx->width;
    _vSwsOutSpec.height = _vDecodeCtx->height;
    _vSwsOutSpec.pixelFmt = _vDecodeCtx->pix_fmt;
    _vSwsOutSpec.size = av_image_get_buffer_size(_vSwsOutSpec.pixelFmt, _vSwsOutSpec.width, _vSwsOutSpec.height, 1);
    // 初始化像素格式转换上下文
    // libswscale/yuv2rgb.c的669行只有ARCH_PPC、ARCH_X86、ARCH_LOONGARCH64支持YUV转RGB,iOS上暂时不支持
//    _vSwsctx = sws_getContext(_vDecodeCtx->width,
//                              _vDecodeCtx->height,
//                              _vDecodeCtx->pix_fmt,
//                              _vSwsOutSpec.width,
//                              _vSwsOutSpec.height,
//                              _vSwsOutSpec.pixelFmt,
//                              SWS_BILINEAR, nullptr, nullptr, nullptr);
//    if (!_vSwsctx) {
//        cout << "sws_getContext _vSwsctx error" << endl;
//        return -1;
//    }
    
    // 初始化像素输入格式,解码数据
    _vSwsInFrame = av_frame_alloc();
    if (!_vSwsInFrame) {
        cout << "av_frame_alloc _vSwsInFrame error" << endl;
        return -1;
    }
    // 接收存储数据
    _vSwsOutFrame = av_frame_alloc();
    if (!_vSwsOutFrame) {
        cout << "av_frame_alloc _vSwsOutFrame error" << endl;
        return -1;
    }
    int ret = av_image_alloc(_vSwsOutFrame->data,
                             _vSwsOutFrame->linesize,
                             _vSwsOutSpec.width,
                             _vSwsOutSpec.height,
                             _vSwsOutSpec.pixelFmt, 1);
    RET(av_image_alloc)
    return 0;
}


//MARK: 视频数据的添加处理
void CFFmpegPlayer::addVideoPkt(AVPacket &pkt) {
    _vMutex.lock();
    _vPackets.push_back(pkt);
    _vMutex.signal();
    _vMutex.unlock();
}

void CFFmpegPlayer::clearVideoPkt() {
    _vMutex.lock();
    for (AVPacket &pkt:_vPackets) {
        av_packet_unref(&pkt);
    }
    _vPackets.clear();
    _vMutex.unlock();
}

void CFFmpegPlayer::freeVideo() {
    clearVideoPkt();
    avcodec_free_context(&_vDecodeCtx);
    av_frame_free(&_vSwsInFrame);
    if (_vSwsOutFrame) {
        av_freep(&_vSwsOutFrame->data[0]);
        av_frame_free(&_vSwsOutFrame);
    }
//    sws_freeContext(_vSwsctx);
//    _vSwsctx = nullptr;
    _vTime = 0;
    _vCanFree = false;
    _vStream = nullptr;
}


// MARK: 视频数据解码
void CFFmpegPlayer::decodeVideo() {
    while (true) {
        if (_state == Paused && _vseekTime == -1) { // seek可以放到外面
            continue;
        }
        if (_state == Stopped) {
            _vCanFree = true;
            break;
        }
        
        _vMutex.lock();
        if (_vPackets.empty()) {
            _vMutex.unlock();
            continue;
        }
        
        AVPacket pkt = _vPackets.front(); // 不能引用
        // 从头部中删除，如果引用的话，pop_front后就会删除指针，后续无法用pkt了
        _vPackets.pop_front();
        // 解锁
        _vMutex.unlock();
        if (pkt.pts != AV_NOPTS_VALUE) {
            _vTime = pkt.pts * av_q2d(_vStream->time_base);
            cout << "输出当前视频包时间: " << _aTime << endl;
        }
        // 要seek时间
        if (_seekTime > 0) {
            av_packet_unref(&pkt);
            continue;// seek时，当前资源不要，不会影响后续解码
        }
        // 发送压缩数据到解码器
        int ret = avcodec_send_packet(_vDecodeCtx, &pkt);
        if (ret < 0) {
            ERROR_BUF
            cout << "v:avcodec_send_packet: " << errbuf << endl;
            av_packet_unref(&pkt);
            continue;;
        }
        av_packet_unref(&pkt);
        while (true) {
            // 获取解码后的数据
            ret = avcodec_receive_frame(_vDecodeCtx,_vSwsInFrame);
            if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) {
                break;;
            } else if (ret < 0) {
                ERROR_BUF;
                cout << "avcodec_receive_frame error:" << errbuf << endl;
                break;
            }
            // 一定要解码成功后，再进行判断
            // 发现视频的时间是早于seektime的，直接丢弃，因为视频是有i帧，p帧，因此seek到86时，可能要从81开始解码
            if (_vseekTime >= 0) {
                //和音频不同，必须放在解码后，因为前面的帧可能有I帧，而要seek的帧需要依赖前面的帧，否则会出现花屏
                if (_vTime < _vseekTime) {
                    continue;
                } else {
                    _vseekTime = -1;
                }
            }

            if (_hasAudio) { //// 有音频数据
                /// 如果视频包过早被解码出来需要等待
                while (_vTime > _aTime && _state == Playing ) { // 注意停止后，_aTime不会在增加
                    //SDL_Delay(5);
                }
            } else {
                SDL_Delay(25);// 没有音频，以25帧播放
            }
            // 把像素格式拷贝出来，因为画图的线程和解码的线程不一样，如果直接传指针的话，当sws_scale中对data改变时也会改变外部的data

            //OPENGL渲染
            Uint8 *buf = (Uint8 *)malloc(_vSwsOutSpec.size);
            // 这种拷贝，可以保证_vSwsOutFrame->data[0]开始数据是连续的，_vSwsInFrame要根据，每linesize的数据
            av_image_copy(_vSwsOutFrame->data,_vSwsOutFrame->linesize,(const uint8_t **)_vSwsInFrame->data,_vSwsInFrame->linesize,_vSwsOutSpec.pixelFmt,_vSwsOutSpec.width,_vSwsOutSpec.height);
            
            memcpy(buf,_vSwsOutFrame->data[0],_vSwsOutSpec.size);
            if (_frameDevodedFunc) {
                _frameDevodedFunc(this,buf,_vSwsOutSpec.size,_vSwsOutSpec.width,_vSwsOutSpec.height);
            }
        }
    }
}

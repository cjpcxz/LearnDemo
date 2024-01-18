//
//  CFFmpegPlayer_Audio.cpp
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2024/1/5.
//

#include <iostream>
#include "SDL.h"
#include "CFFmpegPlayer.hpp"
#define ERROR_BUF \
char errbuf[1024]; \
    av_strerror(ret, errbuf, sizeof (errbuf));

#define RET(func) \
if (ret < 0) { \
        ERROR_BUF; \
        cout << #func << "error" << errbuf << endl; \
        return ret; \
}
using namespace std;
int CFFmpegPlayer::initAudioInfo() {
    // 初始化解码器
    int ret = initDecoder(&_aDecodeCtx, &_aStream, AVMEDIA_TYPE_AUDIO);
    RET(initDecoder)
    
    // 初始化音频重采样上下文
    ret = initSwr();
    RET(initSwr)
    
    // 初始化SDL
    ret = initSDL();
    RET(initSDL)
    
    return ret;
}

// 初始化重采样上下文
int CFFmpegPlayer::initSwr() {
    _aSwrInSpec.sampleFmt = _aDecodeCtx->sample_fmt;
    _aSwrInSpec.channels = _aDecodeCtx->channels;
    _aSwrInSpec.sampleRate = _aDecodeCtx->sample_rate;
    _aSwrOutSpec.sampleFmt = AV_SAMPLE_FMT_S16;
    _aSwrOutSpec.sampleRate = 44100;
    _aSwrOutSpec.channels = 1;
    _aSwrOutSpec.bytesPerSampleFrame = _aSwrOutSpec.channels * av_get_bytes_per_sample(_aSwrOutSpec.sampleFmt);
    
    // 创建重采样上下文
    
    _aSwrCtx = swr_alloc_set_opts(NULL, av_get_default_channel_layout(_aSwrOutSpec.channels), _aSwrOutSpec.sampleFmt, _aSwrOutSpec.sampleRate, av_get_default_channel_layout(_aSwrInSpec.channels), _aSwrInSpec.sampleFmt, _aSwrInSpec.sampleRate, 0, NULL);
    if (!_aSwrCtx) {
        cout << "swr_alloc_set_opts 初始化为NULL" << endl;
        return -1;
    }
    // 初始化重采样上下文
    int ret = swr_init(_aSwrCtx);
    RET(swr_init)
    // 初始化输入
    _aSwrInFrame = av_frame_alloc();
    if (!_aSwrInFrame) {
        cout << "av_frame_alloc error _aSwrInFrame" << endl;
        return -1;
    }
    
    // 初始化输出frame
    _aSwrOutFrame = av_frame_alloc();
    if (!_aSwrOutFrame) {
        cout << "av_frame_alloc error _aSwrOutFrame" << endl;
        return -1;
    }

    // 初始化重采样的输出frame的data[0]空间，不用初始化输入的，输入的通过avcodec_receive_frame可以赋值
    ret = av_samples_alloc(_aSwrOutFrame->data, _aSwrOutFrame->linesize, _aSwrOutSpec.channels, 4096, _aSwrOutSpec.sampleFmt, 1);
    RET(av_samples_alloc)
    
    return 0;
}

int CFFmpegPlayer::initSDL() {
    // 音频参数
    SDL_AudioSpec spec;
    // 采样率
    spec.freq = _aSwrOutSpec.sampleRate;
    // 采样格式
    spec.format = AUDIO_S16LSB;
    // 声道数
    spec.channels = _aSwrOutSpec.channels;
    // 音频缓冲去的样本数量，必须是2的幂
    spec.samples = 512;
    // 回调
    spec.callback = sdlAudioCallback;
    // 传递给回调的参数
    spec.userdata = this;
    // 打开音频设备
    if(SDL_OpenAudio(&spec, nullptr)) {
        return -1;
    }
    return 0;
}

//MARK: 音频数据的添加处理
void CFFmpegPlayer::addAudioPkt(AVPacket &pkt) {
    _aMutex.lock();
    _aPackets.push_back(pkt);
    _aMutex.unlock();
}

void CFFmpegPlayer::clearAudioPkt() {
    _aMutex.lock();
    for (AVPacket &pkt : _aPackets) {
        av_packet_unref(&pkt);
    }
    _aPackets.clear();
    _aMutex.unlock();
}


void CFFmpegPlayer::freeAudio() {
    SDL_PauseAudio(1);
    _aSwrOutIdex = 0;
    _aSwrOutSize = 0;
    _aStream = nullptr;
    _aCanFree = false;
    clearAudioPkt();
    avcodec_free_context(&_aDecodeCtx);
    av_frame_free(&_aSwrInFrame);
    swr_free(&_aSwrCtx);
    if(_aSwrOutFrame) { // 防止data是野指针
        // 这个自己创建了data
        av_freep(&_aSwrOutFrame->data[0]);
        av_frame_free(&_aSwrOutFrame);
    }
   
    SDL_CloseAudio();
}

//MARK: 音频数据解码
int CFFmpegPlayer::decodeAudio() {
    _aMutex.lock();
    //    while(_aPackets.empty()) {
    //        // wait会存在操作系统的假唤醒，因此加while
    //        _aMutex.wait();
    //    }
    if(_aPackets.empty() || _state == Stopped) {
        _aMutex.unlock();
        return 0;
    }
    
    AVPacket pkt = _aPackets.front(); //不能用引用
    // 从头部中删除，如果引用的话，pop_front后就会删除指针，后续无法用pkt了
    _aPackets.pop_front();
    // 解锁
    _aMutex.unlock();
    if (pkt.pts != AV_NOPTS_VALUE) {
        _aTime = pkt.pts * av_q2d(_aStream->time_base);
        cout << "输出当前音频包时间: " << _aTime << endl;
        //通知外界，播放的时间
        if(_timeChangeFunc) {
            _timeChangeFunc(this);
        }
    }
    //
    if(_seekTime > 0) {
        av_packet_unref(&pkt);
        return 0;// seek时，当前资源不要，不会影响后续解码
    }
    // 如果是视频，不能提前释放
    // 发现音频的时间是早于seektime的，直接丢弃，因为视频是有i帧，p帧，因此seek到86时，可能要从81开始解码
    if (_aseekTime >= 0) {
        if(_aTime < _aseekTime) {
            // 释放pkt
            av_packet_unref(&pkt);
            return 0;
        } else {
            _aseekTime = -1;
        }
    }
    // 发送压缩数据到解码器
    int ret = avcodec_send_packet(_aDecodeCtx, &pkt);
    if (ret < 0) {
        ERROR_BUF
        cout << "a:avcodec_send_packet: " << errbuf << endl;
        av_packet_unref(&pkt);
        return ret;
    }
    
    // 获取解码后的数据
    ret = avcodec_receive_frame(_aDecodeCtx,_aSwrInFrame);
    if (ret == AVERROR(EAGAIN) || ret == AVERROR_EOF) {
        return 0;
    } else if (ret < 0) {
        ERROR_BUF;
        cout << "avcodec_receive_frame error:" << errbuf << endl;
        return ret;
    }
    int outSamples = (int)av_rescale_rnd(_aSwrOutSpec.sampleRate, _aSwrInFrame->nb_samples, _aSwrInFrame->sample_rate, AV_ROUND_UP);
    ret = swr_convert(_aSwrCtx,
                          (uint8_t **)_aSwrOutFrame->data,
                          outSamples,
                          (const uint8_t **)_aSwrInFrame->data,
                          _aSwrInFrame->nb_samples); //数据转换后的样本数量
    RET(swr_convert)
    // 释放资源
    av_packet_unref(&pkt);
    return ret * _aSwrOutSpec.bytesPerSampleFrame;;
}

//MARK: SDL数据填充

void CFFmpegPlayer::sdlAudioCallback(uint8_t *stream, int len) {
    // len SDL缓存区的大小，剩下未填的数据长度
    SDL_memset(stream, 0, len);
    // len: SDL音频缓冲区剩余的大小，还未填充的数据
    while (len > 0) {
        if(_state == Paused) break;
        if (_state == Stopped) {
            _aCanFree = true;//是否可以释放
            break;
        }
        //说明当前PCM的数据已经全部拷贝到SDL的音频缓冲区了
        // 需要解码下一个pkt，获取新的PCM数据
        if (_aSwrOutIdex >= _aSwrOutSize) {
            // 全新PCM的大小
            _aSwrOutSize = decodeAudio();
            // 索引清零
            _aSwrOutIdex = 0;
            if(_aSwrOutSize <= 0) {
            // 解码异常，静音处理
            //假定PCM的大小，不用SDL_memset(stream,0,len);因为只用短暂禁音
            _aSwrOutSize = 1024;
            // 给PCM填充0（静音）
            memset(_aSwrOutFrame->data[0],0,_aSwrOutSize);
            }
        }
        // 本次可以填充的数据
        int fillLen = _aSwrOutSize - _aSwrOutIdex;
        fillLen = min(len,fillLen);//实际填充的数据
        int volumn = _mute ? 0 : (_volumn * 1.0 / Max) * SDL_MIX_MAXVOLUME;
        // 填充到SDL的音频缓存区
        SDL_MixAudio(stream, _aSwrOutFrame->data[0] + _aSwrOutIdex, fillLen, volumn);
        //数据输出偏移
        _aSwrOutIdex += fillLen;
        // 缓存区数据偏移
        len -= fillLen;
        stream += fillLen;
    }
    
}

// sdl音频的回调函数
void CFFmpegPlayer::sdlAudioCallback(void *userdata, Uint8 * stream,
                      int len) {
    CFFmpegPlayer *player = (CFFmpegPlayer *)userdata;
    player->sdlAudioCallback(stream,len);
}


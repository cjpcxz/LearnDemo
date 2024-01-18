//
//  CFFmpegPlayer.cpp
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2024/1/1.
//
#include "SDL.h"
#include <thread>
#include <iostream>
#include "CFFmpegPlayer.hpp"

extern "C" {
#include <libavutil/avutil.h>
}
#define AUDIO_MAX_PKT_SIZE 1000
#define VIDEO_MAX_PKT_SIZE 500

#define ERROR_BUF \
char errbuf[1024]; \
    av_strerror(ret, errbuf, sizeof (errbuf));


#define ENDRET(func) \
if (ret < 0) { \
    ERROR_BUF; \
    cout << #func << "error" << errbuf << endl; \
    if (_playFailFunc) {    \
        _playFailFunc(this); \
    } \
    setState(Stopped);   \
    free(); \
    return ret; \
}

#define RET(func) \
if (ret < 0) { \
    ERROR_BUF; \
    cout << #func << "error" << errbuf << endl; \
    return ret; \
}

using namespace std;
CFFmpegPlayer::CFFmpegPlayer() {
    
    // 初始化Audio子系统
    if(SDL_Init(SDL_INIT_AUDIO)) {
    // TODO: 播放失败
        return;
    }
}

CFFmpegPlayer::~CFFmpegPlayer() {
    
    _state = Stopped;
    // 释放资源
    free();
    SDL_Quit();
    cout << "CFFmpegPlayer释放了" << endl;
}

//MARK: - public
CFFmpegPlayer::State CFFmpegPlayer::getState() {
    return _state;
}

int64_t CFFmpegPlayer::getDuration() {
    return _fmtCtx ? round(_fmtCtx->duration * av_q2d(AV_TIME_BASE_Q)) : 0;
}

//MARK: 控制
void CFFmpegPlayer::play(){
    if (_state == Playing) return;
    if(_state == Stopped) {
        thread([this](){
            cout << this->_filename << endl;
            this->readFile(this->_filename);
        }).detach();
    } else {
        setState(Playing);
    }
}


void CFFmpegPlayer::pluse(){
    if (_state != Playing) return;

    setState(Paused);
}

void CFFmpegPlayer::stop(){
    if (_state == Stopped) return;

    // 改变状态
    _state = Stopped; 
    //状态改变,这里要先改变状体
    //释放资源，因此不调用set方法
    // 释放资源
    free();
    //状态改变
    if (_stateChangeFunc) {
        _stateChangeFunc(this);
    }
}

//MARK:  - getter&setter
//MARK: 外界回调函数
void CFFmpegPlayer::setPlayFailFunc(PlayFailFunc func) {
    _playFailFunc = func;
}

void CFFmpegPlayer::setTimeChangeFunc(TimeChangeFunc func) {
    _timeChangeFunc = func;
}

void CFFmpegPlayer::setStateChangeFunc(StateChangeFunc func) {
    _stateChangeFunc = func;
}

void CFFmpegPlayer::setFrameDevodedFunc(FrameDevodedFunc func) {
    _frameDevodedFunc = func;
}

void CFFmpegPlayer::setInitFinishFunc(InitFinishFunc func) {
    _initFinishFunc = func;
}

void CFFmpegPlayer::setVolumn(int value) {
    _volumn = value;
}

int CFFmpegPlayer::getVolumn() {
    return _volumn;
}

void CFFmpegPlayer::setMute(bool mute) {
    _mute = mute;
}

bool CFFmpegPlayer::isMute() {
    return _mute;
}

int CFFmpegPlayer::getTime() {
    return round(_aTime);
}

void CFFmpegPlayer::setTime(int seekTime) {
    _seekTime = seekTime;
}

void CFFmpegPlayer::setFilename(const char * fileName) {
    // 字符串以\0结尾，拷贝的时候要考虑\0
    memcpy(_filename,fileName,strlen(fileName) + 1);
    cout << "当前播放的文件名" << fileName << endl;
}

void CFFmpegPlayer::setState(State state) {
    if (_state == state) return;
    _state = state;
    // 状态改变
    if (_stateChangeFunc) {
        _stateChangeFunc(this);
    }
}




void CFFmpegPlayer::free() {
    while (_hasAudio && !_aCanFree);
    while (_hasVideo && !_vCanFree);
    while (!_fmtctxCanFree); //_fmtctx可能在用
    avformat_close_input(&_fmtCtx);
    _fmtctxCanFree = false;
    _seekTime = -1;
    freeAudio();
    freeVideo();
}

//MARK: - private
int CFFmpegPlayer::readFile(const char *filename) {
    // 返回结果
    int ret = 0;
    /**创建解封装上下文，打开文件
    int avformat_open_input(AVFormatContext **ps, const char *url,
                             const AVInputFormat *fmt, AVDictionary **options);
     - url 是打开的输入流，此前录制音频/视频的时候，是device序号，例如0，这里传入要解封的音视频文件
     - fmt 是输入格式，此前不为null，传入的是视频格式，例如avfoundation
     - options,传入一些额外的参数，例如视频录制时传入的  av_dict_set(&options,"pixel_format","yuyv422",0);
     */
    ret = avformat_open_input(&_fmtCtx, filename, nullptr, nullptr);
    ENDRET(avformat_open_input)
    
    // 从媒体文件中检索流信息，看是否必须
    ret = avformat_find_stream_info(_fmtCtx,nullptr);
    ENDRET(avformat_open_input)
    
    // 打印流信息到控制台
    av_dump_format(_fmtCtx, 0, filename, 0);
    
    // 初始化音频信息
    _hasAudio = initAudioInfo() >= 0;
    // 初始化视频信息
    _hasVideo = initVideoInfo() >= 0;
    if (!_hasAudio && !_hasVideo) {
        cout << "音频和视频均初始化失败了" << endl;
        if (_playFailFunc) {
            _playFailFunc(this);
        }
        setState(Stopped);
        return -1;
    }
    
    // 初始化完成
    if (_initFinishFunc) {
        _initFinishFunc(this);
    }
    setState(Playing);
    //SDL音频子线程，开始播放声音
    SDL_PauseAudio(0);
    //视频子线程，开始工作，开启新的线程解码，音频中SDL有自己线程，因此不用开线程
    thread([this]{
        this->decodeVideo(); //解码视频
    }).detach();
    
    // 初始化pkt
    AVPacket pkt ; // 每次赋值，都是拷贝赋值，因此放在下面while的外面也是可以的
    // 从输入文件中读取数据，和此前解码不同，不用解析器，直接从解封装上下文中获取
    // 返回解封装文件中，返回下一帧的流数据，类似之前视频/音频采集的方式
    while (_state != Stopped) {
        // 处理seek操作
        if (_seekTime > -1) {//seek不记录之前的，就算之前读取过，也从seek位置重新读取
            int streamIdx;
            if(_hasAudio) { // 优先用音频流索引seek
                streamIdx = _aStream->index;
            } else {
                streamIdx = _vStream->index;
            }
            // 现实时间 -> 时间戳
            AVRational timeBase = _fmtCtx->streams[streamIdx]->time_base;
            int64_t ts = _seekTime / av_q2d(timeBase);
            ret = av_seek_frame(_fmtCtx,streamIdx,ts,AVSEEK_FLAG_BACKWARD);
            if (ret < 0) { //seeak失败
                cout << "seeak 失败" << endl;
                _seekTime = -1;
            } else {
                cout << "seeak 成功" << endl;
                // 清空之前的时间
                clearAudioPkt();
                clearVideoPkt();
                // 保证，在上一个资源改变之后，再进行操作
                _vTime = 0;
                _vseekTime = _seekTime;
                _aTime = 0;
                _aseekTime = _seekTime;
                _seekTime = -1;
            }
        }
        unsigned long vSize = _vPackets.size();
        unsigned long aSize = _aPackets.size();
        if(vSize >= VIDEO_MAX_PKT_SIZE || aSize >= AUDIO_MAX_PKT_SIZE) {
            // SDL_Delay(2);// 防止av_read_frame读取pkt太多载入内存中
            continue;
        }
        ret = av_read_frame(_fmtCtx, &pkt);
        if (ret == 0) {
            if (pkt.stream_index == _aStream->index) {
                // 读取到的是音频数据
                addAudioPkt(pkt);
            } else if (pkt.stream_index == _vStream->index) {
                // // 读取到的是视频数据
                addVideoPkt(pkt);
            } else { // 释放非音频视频流的pkt
                av_packet_unref(&pkt);
            }
        }  else if (ret == AVERROR_EOF) { //读取到了文件尾部
            if (vSize == 0 && aSize == 0) {
                _fmtctxCanFree = true;
                break;
            }
        } else {
            ERROR_BUF;
            cout << "av_read_frame:" << errbuf << endl;
            continue;
        }
    }
        
    
    
    // 标记下可以释放了
    if (_fmtctxCanFree) {
        stop(); //正常播放完了
    } else {
        _fmtctxCanFree = true;//手动停止的情况
    }
    
    return ret;
}


//MARK: 初始化解码
int CFFmpegPlayer::initDecoder(AVCodecContext **decodeCtx, AVStream **stream, FF_AVMediaType type) {
    // 根据type寻找最合适的流信息，返回是流索引
    /*
         * wanted_stream_nb: 用户请求的流，-1表示自动选择
         * related_stream： 尝试发现关联的流，-1表示没有关联的
         * decoder_ret: 为选择的流返回解码器，为null不返回
         * int av_find_best_stream(AVFormatContext *ic,
                            enum AVMediaType type,
                            int wanted_stream_nb,
                            int related_stream,
                            const AVCodec **decoder_ret,
                            int flags);
        */
    int ret = av_find_best_stream(_fmtCtx, type, -1, -1, nullptr, 0);
    RET(av_find_best_stream)
    *stream = _fmtCtx->streams[ret]; // 检验流
    if (!*stream) {
        cout << type << "相关流数据为空" << endl;
        return -1;
    }
    
    
    // 为当前流找到合适的解码器
    // 根据codecID获取解码器
    const AVCodec *decoder = avcodec_find_decoder((*stream)->codecpar->codec_id);
    if (!decoder) {
        cout << "decoder not found" << (*stream) -> codecpar->codec_id << endl;
        return -1;
    }
    // 初始化解码上下文
    *decodeCtx = avcodec_alloc_context3(decoder);
    if (!*decodeCtx) {
        cout << "avcodec_alloc_context3 error" << endl;
        return -1;
    }
    //从流中拷贝参数到解码上下文中
    ret = avcodec_parameters_to_context(*decodeCtx, (*stream)->codecpar);
    RET(avcodec_parameters_to_context)
    //打开解码器
    ret = avcodec_open2(*decodeCtx, decoder, nullptr);
    RET(avcodec_open2)
    return ret;
}

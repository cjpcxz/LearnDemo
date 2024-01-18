//
//  CFFmpegPlayer.hpp
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2024/1/1.
//

#ifndef CFFmpegPlayer_hpp
#define CFFmpegPlayer_hpp

/**
 1. 初始化解码上下文
    2. 
 */
#include "CondMutex.hpp"
#include <list>
#include <stdio.h>
#include <functional> //实现类型擦除，不然带捕获的无法赋值函数指针
extern "C" {
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libswresample/swresample.h>
#include <libswscale/swscale.h>
}


class CFFmpegPlayer {
    typedef std::function<void(CFFmpegPlayer *)> StateChangeFunc;
    typedef std::function<void(CFFmpegPlayer *)> TimeChangeFunc;
    typedef std::function<void(CFFmpegPlayer *)> InitFinishFunc;
    typedef std::function<void(CFFmpegPlayer *)> PlayFailFunc;
    typedef std::function<void(CFFmpegPlayer *,uint8_t *,uint64_t,int,int)> FrameDevodedFunc;
//MARK: mark - 公有方法
public:
    typedef enum{
        Playing,
        Paused,
        Stopped
    }State;

    typedef enum {
        Min = 0,
        Max = 100,
    } Volumn;
    explicit CFFmpegPlayer();
    ~CFFmpegPlayer();
    void play();
    void pluse();
    void stop();
    State getState();
    /// 文件名
    void setFilename(const char * fileName);
    /// 获取总时长,单位秒
    int64_t getDuration();
    // 当前的播放时刻，返回秒
    int getTime();
    // 设置当前的播放时刻（单位是秒）
    void setTime(int seekTime);
    
//MARK: 外界回调函数
    void setStateChangeFunc(StateChangeFunc func);
    void setTimeChangeFunc(TimeChangeFunc func);
    void setInitFinishFunc(InitFinishFunc func);
    void setPlayFailFunc(PlayFailFunc func);
    void setFrameDevodedFunc(FrameDevodedFunc func);
//MARK: 音频相关的
    /// 设置音量
    void setVolumn(int value);
    int getVolumn();
    /// 设置静音
    void setMute(bool mute);
    bool isMute();

//MARK: mark - 私有方法


private:
    State _state = Stopped;
    // 文件名
    char _filename[512]; // 用对象存储，防止被其他人销毁
    void setState(State state);
    // 读取文件数据
    int readFile(const char *filename);
    // 释放资源
    void free();
//MARK: 方法回调
    StateChangeFunc _stateChangeFunc = nullptr;
    TimeChangeFunc _timeChangeFunc = nullptr;
    InitFinishFunc _initFinishFunc = nullptr;
    PlayFailFunc _playFailFunc = nullptr;
    FrameDevodedFunc _frameDevodedFunc = nullptr;
//MARK: mark 解封装共有
    // 解封装上下文
    AVFormatContext *_fmtCtx = nullptr;
    bool _fmtctxCanFree = false;
    // 外面设置的当前播放时刻（用于完成seek功能）
    int _seekTime = -1;
    // 初始化解码器和解码上下文
    int initDecoder(AVCodecContext **decodeCtx,
                    AVStream **stream,
                    FF_AVMediaType type);
    
//MARK: 音频相关的
    typedef struct {
        int sampleRate;
        AVSampleFormat sampleFmt;
        int channels;
        int bytesPerSampleFrame; //每个样本的字节数
    } AudioSwrSpec;
    // 解码上下文
    AVCodecContext *_aDecodeCtx = nullptr;
    // 输出流
    AVStream *_aStream = nullptr;
    
    // 存放音频包的列表
    std::list<AVPacket> _aPackets;
    // 音频包锁
    CondMutex _aMutex;
    // 音频重采样上下文
    SwrContext *_aSwrCtx = nullptr;
    // 音频重采样输入参数
    AudioSwrSpec _aSwrInSpec,_aSwrOutSpec;
    // 音频重采样输入/输出frame
    AVFrame *_aSwrInFrame = nullptr,*_aSwrOutFrame = nullptr;
    // 音频重采样输出PCM的索引，从那个位置开始取出PCM到SDL的缓冲区
    int _aSwrOutIdex = 0;
    // 重采样输出PCM的大小
    int _aSwrOutSize = 0;
    
    // 音频时钟，当前音频包对应的时间值
    double _aTime = 0;
    // 音量
    int _volumn = Max;
    // 静音
    bool _mute = false;
    bool _hasAudio = false;
    int _aseekTime = -1;
    // 音频资源是否可以释放
    bool _aCanFree = false;
    
    // 初始化音频信息
    int initAudioInfo();
    // 初始化SDL
    int initSDL();
    // 初始化音频重采样上下文
    int initSwr();
    // 添加数据包到音频表中;
    void addAudioPkt(AVPacket &pkt);
    // 清空音频包中的数据
    void clearAudioPkt();
    // SDL填充缓冲区的回调函数
    void sdlAudioCallback(uint8_t * stream,int len);
    static void sdlAudioCallback(void *userdata, uint8_t * stream,
                                     int len);
    // 音频解码
    int decodeAudio();
    // 释放音频资源
    void freeAudio();
    
//MARK: 视频相关的
    typedef struct {
        int width;
        int height;
        AVPixelFormat pixelFmt;
        int size;
    } VideoSwsSpec;
    // 解码上下文
    AVCodecContext * _vDecodeCtx = nullptr;
    // 输出流
    AVStream *_vStream = nullptr;
    // 存放视频包的列表
    std::list<AVPacket> _vPackets;
    // 视频包锁
    CondMutex _vMutex;
    // 视频时钟，当前视频包对应的时间值
    double _vTime = 0;
    // 视频资源是否可以释放
    bool _vCanFree = false;
    bool _hasVideo = false;
    int _vseekTime = -1;
    
    // 视频像素格式转换输入/输出frame
    AVFrame *_vSwsInFrame = nullptr,*_vSwsOutFrame = nullptr;
    VideoSwsSpec _vSwsOutSpec;
    // 像素格式转换上下文
    SwsContext *_vSwsctx = nullptr;
    // 初始化视频信息
    int initVideoInfo();
    // 初始化视频像素格式转换上下文
    int initSws();
    // 添加数据包到音频表中;
    void addVideoPkt(AVPacket &pkt);
    // 清空视频包中的数据
    void clearVideoPkt();
    // 释放视频资源
    void freeVideo();
    
    // 视频解码
    void decodeVideo();
};

#endif /* CFFmpegPlayer_hpp */

//
//  WAVPlayManager.m
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2023/12/31.
//
#import "FFMpegCommonHeader.h"
#include "SDL.h"
#import "WAVPlayManager.h"


static const dispatch_queue_t playQueue = dispatch_queue_create("com.ffmpeg.avfoundation.playQueue", DISPATCH_QUEUE_SERIAL);
@interface WAVPlayManager() {
    Uint8 *_data;
    Uint32 _len;
    Uint32 _pullLen;
}
@property(nonatomic,assign,readwrite)BOOL isPlaying;
@property(nonatomic,strong)NSURL * filePath;

- (void)pullAudioData:(Uint8 *)stream len:(Uint32) len;
@end

/// sdl处理回调函数
/// - Parameters:
///   - stream: 音频缓冲区（需要将音频数据填充到这个缓冲区）
///   - len: 音频缓冲区的大小（SDL_AudioSpec.samples * 每个样本的大小,即声道乘以位深）
void pull_audio_data(void *userdata, Uint8 * stream,
                       int len) {
    WAVPlayManager *manager = (__bridge WAVPlayManager *)userdata;
    [manager pullAudioData:stream len:len];
}

@implementation WAVPlayManager
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static WAVPlayManager *_instance;
    dispatch_once(&onceToken, ^{
        // 设备注册一次
        _instance = [[WAVPlayManager allocWithZone:NULL] init];
    });
    return _instance;
}

- (void)startPlayWithFilePath:(NSURL *)filePath {
    if (self.isPlaying) {
        return;
    }
    self.filePath = filePath;
    self.isPlaying = YES;
    SDL_version v;
    SDL_VERSION(&v);
    dispatch_async(playQueue, ^{
        [self playWAV];
    });
}

- (void)stopRecord {
    self.isPlaying = NO;
}

- (void)playWAV {
    if (SDL_Init(SDL_INIT_AUDIO)) {
        FFLog(@"SDL_Init Error: %s",SDL_GetError());
        return;
    }
    SDL_AudioSpec spec;
    self->_data = nullptr;
    self->_len = 0;
    // 打开WAV文件
    if (!SDL_LoadWAV([self.filePath.path cStringUsingEncoding:NSASCIIStringEncoding],&spec,&self->_data,&self->_len)) {
        FFLog(@"SDL_LoadWAV Error: %s",SDL_GetError());
            // 清除所有初始化的子系统
        SDL_Quit();
        return;
    }
    FFLog(@"wav文件的大小: %d",self->_len);
    // 音频参数
    
    spec.callback = pull_audio_data;
    spec.userdata = (__bridge void *)self;
    // 打开音频设备
    if(SDL_OpenAudio(&spec, nullptr)) {
        FFLog(@"SDL_OpenAudio Error: %s",SDL_GetError());
        // 清除所有初始化的子系统
        SDL_Quit();
        return;
    }
    // 开始播放
    SDL_PauseAudio(0);
    FFLog(@"播放文件格式--%d -- 声道%hu--采样率%hu",SDL_AUDIO_BITSIZE(spec.format),spec.channels,spec.samples);
    while (self.isPlaying) {
        // 只要从文件中读取的音频数据，还没有填充完毕，就跳过
        if (self->_len > 0) continue;
        if (self->_len <= 0) { //最后，清除剩余
            //剩余的样本数量
            int samples = self->_pullLen / (SDL_AUDIO_BITSIZE(spec.format) * spec.channels >> 3);
            int ms = samples * 1000.0 / spec.samples;
            // 延迟，让其播放完整
            SDL_Delay(ms);
            break;
        }
    }
    self.isPlaying = NO;

    //关闭音频设备
    SDL_CloseAudio();
    // 清除所有初始化的子系统
    SDL_Quit();
}

- (void)pullAudioData:(Uint8 *)stream len:(Uint32) len {
    // 清空stream
    SDL_memset(stream, 0, len);
    //文件数据还没有准备好
    if (self->_len <= 0) return;
    // 拉取填充的数据
    self->_pullLen = MIN(self->_len, len);
    // 填充数据大缓存区,SDL_MIX_MAXVOLUME设置最大音量
    SDL_MixAudio(stream, self->_data, self->_pullLen, SDL_MIX_MAXVOLUME);
    self->_data += self->_pullLen;
    self->_len -= self->_pullLen;
}
@end

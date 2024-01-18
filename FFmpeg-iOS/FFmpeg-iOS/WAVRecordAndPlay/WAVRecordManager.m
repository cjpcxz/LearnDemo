//
//  WAVRecordManager.m
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2023/12/30.
//
#import "FFMpegCommonHeader.h"
#import "WAVRecordManager.h"
extern "C" {
#include <libavutil/avutil.h>
// 设备相关API
#include <libavdevice/avdevice.h>
// 格式相关API
#include <libavformat/avformat.h>
// 编码相关API
#include <libavcodec/avcodec.h>
}

#define AUDIO_FORMAT_PCM 1
#define AUDIO_FORMAT_FLOAT 3
static const char * FMT_NAME = "avfoundation";
static const char * DEVICE_NAME = ":0";

static const dispatch_queue_t recordQueue = dispatch_queue_create("com.ffmpeg.avfoundation.audio", DISPATCH_QUEUE_SERIAL);

//WAV头部必要的音频格式，c++结构体
struct WAVHeader {
    // RIFF chunk的id,不能用"RIFF"赋值，因为c++中"RIFF"实际为{'R', 'I', 'F', 'F','\0'}
    uint8_t riffChunkId[4] = {'R', 'I', 'F', 'F'};
    // RIFF chunk的data大小，即文件总长度减去8字节
    uint32_t riffChunkDataSize;
    // "WAVE"
    uint8_t format[4] = {'W', 'A', 'V', 'E'};
    
    /* fmt chunk */
    // fmt chunk的id
    uint8_t fmtChunkId[4] = {'f', 'm', 't', ' '};
    // fmt chunk的data大小：存储PCM数据时，是16
    uint32_t fmtChunkDataSize = 16;
    // 音频编码，1表示PCM，3表示Floating Point
    uint16_t audioFormat = AUDIO_FORMAT_PCM;
    // 声道数
    uint16_t channels;
    // 采样率
    uint32_t sampleRate;
    // 字节率 = sampleRate * blockAlign
    uint32_t byteRate;
    // 一个样本的字节数 = bitsPerSample * numChannels >> 3
    uint16_t blockAlign;
    // 位深度
    uint16_t bitsPerSample;
    /* data chunk */
    // data chunk的id
    uint8_t dataChunkId[4] = {'d', 'a', 't', 'a'};
    // data chunk的data大小：音频数据的总长度，即文件总长度减去文件头的长度(一般是44)
    uint32_t dataChunkDataSize;
    
    WAVHeader(AVCodecParameters *params);
};
@interface WAVRecordManager ()
@property(nonatomic,assign,readwrite)BOOL isRecoding;
@property(nonatomic,strong)NSURL * filePath;
@end

@implementation WAVRecordManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static WAVRecordManager *_instance;
    dispatch_once(&onceToken, ^{
        // 设备注册一次
        avdevice_register_all();
        _instance = [[WAVRecordManager allocWithZone:NULL] init];
    });
    return _instance;
}

- (void)startRecordWithFilePath:(NSURL *)filePath {
    if (self.isRecoding) {
        return;
    }
    self.filePath = filePath;
    self.isRecoding = YES;
    dispatch_async(recordQueue, ^{
        [self startRecord];
    });
}

- (void)startRecord {
    const AVInputFormat *fmt = av_find_input_format(FMT_NAME);
    if (!fmt) {
        // 如果找不到输入格式
        FFLog(@"找不到输入格式%s",FMT_NAME);
        return;
    }
    
    // 格式上下文（后面通过格式上下文操作设备）
    AVFormatContext *ctx = nullptr;
    // 打开设备
    int ret = avformat_open_input(&ctx, DEVICE_NAME, fmt, nullptr);
    // 如果打开设备失败
    if (ret < 0) {
        AV_ERROR_BUF(ret)
        FFLog(@"打开设备失败%s",errbuf);
        return;
    }
    [self showSpec:ctx];
    FILE *pcm = fopen([self.filePath.path cStringUsingEncoding:NSASCIIStringEncoding], "wb");    // source 被转换的音频文件位置
    if (!pcm) {
        //关闭格式上下文
        avformat_close_input(&ctx);
        FFLog(@"文件打开失败%@",self.filePath);
        return;
    }
    // 初始化部份WAV数据
    AVCodecParameters *params = ctx->streams[0]->codecpar;
    WAVHeader wavHeader(params);
    fwrite(&wavHeader, sizeof(WAVHeader), 1, pcm);
    
    AVPacket *pkt = av_packet_alloc();
    while (self.isRecoding) {
        // 从设备中采集数据，返回值为0，代表采集数据成功
        ret = av_read_frame(ctx, pkt);
        
        if (ret == 0) { // 读取成功
            // 将数据写入文件，1字节写入
            fwrite(pkt->data, pkt->size, 1, pcm);
            // 记录写入的数据
            wavHeader.dataChunkDataSize += pkt->size;
            if ([self.delegate respondsToSelector:@selector(recordTime:)]) {
                NSInteger ms = wavHeader.dataChunkDataSize * 1000.0 / wavHeader.byteRate;
                [self.delegate recordTime:ms];
            }
            // 释放资源
            av_packet_unref(pkt);
        } else if (ret == AVERROR(EAGAIN)) { // 资源临时不可用
            continue;
        } else { // 其他错误
            AV_ERROR_BUF(ret)
            FFLog(@"av_read_frame error%s",errbuf);
            break;
        }
    }
    
    FFLog(@"finish");
    // 修改wav头文件中大小
    // 文件头0(SEEK_SET)，当前位置1(SEEK_CUR)，文件尾2(SEEK_END)
    fseek(pcm, sizeof(wavHeader.riffChunkId), SEEK_SET);
    wavHeader.riffChunkDataSize = wavHeader.dataChunkDataSize + sizeof(wavHeader) - sizeof(wavHeader.riffChunkId) - sizeof(wavHeader.riffChunkDataSize);
    fwrite(&wavHeader.riffChunkDataSize, sizeof(wavHeader.riffChunkDataSize), 1, pcm);
    
    fseek(pcm, sizeof(wavHeader) - sizeof(wavHeader.dataChunkDataSize), SEEK_SET);
    fwrite(&wavHeader.dataChunkDataSize, sizeof(wavHeader.dataChunkDataSize), 1, pcm);
    
    fclose(pcm);
    av_packet_free(&pkt);
    avformat_close_input(&ctx);
}


- (void)showSpec:(AVFormatContext *)ctx {
    // 获取输入流,这里是数组，因为打开一个音频设备，就是一种流
    AVStream *stream = ctx->streams[0];
    // 获取音频参数
    AVCodecParameters *params = stream->codecpar;
    // 声道数 这里mono是单声道，1
    
    FFLog(@"声道数%d",params->channels);
    FFLog(@"声率数%d",params->sample_rate);
    FFLog(@"采样格式%d",params->format);
    FFLog(@"采样格式%s",av_get_sample_fmt_name((AVSampleFormat)params->format));
    FFLog(@"采样格式%d",av_get_bits_per_sample(params->codec_id));;
}

- (void)stopRecord {
    self.isRecoding = NO;
}

//MARK: PCM数据写入
WAVHeader::WAVHeader(AVCodecParameters *params) {
    channels = params->channels;
    sampleRate = params->sample_rate;
    bitsPerSample = av_get_bits_per_sample(params->codec_id);
    audioFormat = (params->codec_id >= AV_CODEC_ID_PCM_F32BE) ? AUDIO_FORMAT_PCM:AUDIO_FORMAT_PCM;
    blockAlign = (channels * bitsPerSample) >> 3;
    byteRate = blockAlign * sampleRate;
}
@end

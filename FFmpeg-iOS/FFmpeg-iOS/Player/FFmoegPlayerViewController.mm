//
//  FFmoegPlayerViewController.m
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2024/1/14.
//
#include <iostream>

#import <Masonry/Masonry.h>
#import "FFmoegPlayerViewController.h"
#import "OpenGLView20.h"
#import "OpenGLMetalKitView.h"
#include "CFFmpegPlayer.hpp"
@interface FFmoegPlayerViewController () {
    CFFmpegPlayer *_player;
}
@property(nonatomic, strong) UISlider *progressSlider;
@property(nonatomic, strong) OpenGLMetalKitView *metalview;
@property(nonatomic, strong) UISlider *sounderSilder;

@property(nonatomic, strong) UIButton *playButton;
@property(nonatomic, strong) UIButton *stopButton;
@property(nonatomic, strong) UIButton *silenceButton;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *totalTimeLabel;

@property(nonatomic, strong) UILabel *soundLabel;



@end

@implementation FFmoegPlayerViewController
- (void)dealloc {
    delete _player;
    _player = nullptr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //渲染View
    // Do any additional setup after loading the view.
    [self initPlayer];
    [self configureUI];
    
}

- (void)configureUI {
    [self.view addSubview:self.metalview];
    [self.view addSubview:self.playButton];
    [self.view addSubview:self.stopButton];
    [self.view addSubview:self.progressSlider];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.totalTimeLabel];
    [self.view addSubview:self.silenceButton];
    [self.view addSubview:self.sounderSilder];
    [self.view addSubview:self.soundLabel];
    [self.metalview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.height.mas_equalTo(400);
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.metalview.mas_leading);
        make.top.mas_equalTo(self.metalview.mas_bottom);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    [self.stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.playButton.mas_trailing).offset(10);
        make.top.width.height.mas_equalTo(self.playButton);
    }];
    [self.soundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(0);
        make.width.mas_equalTo(50);
        make.top.height.mas_equalTo(self.playButton);
    }];
    [self.sounderSilder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.soundLabel.mas_leading).offset(-10);
        make.width.mas_equalTo(150);
        make.top.height.mas_equalTo(self.playButton);
    }];
    [self.silenceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.sounderSilder.mas_leading).offset(-10);
        make.top.width.height.mas_equalTo(self.playButton);
    }];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.silenceButton.mas_leading).offset(-10);
        make.width.mas_equalTo(50);
        make.top.height.mas_equalTo(self.playButton);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.totalTimeLabel.mas_leading).offset(-10);
        make.top.width.height.mas_equalTo(self.totalTimeLabel);
    }];
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.timeLabel.mas_leading).offset(-10);
        make.leading.mas_equalTo(self.stopButton.mas_trailing).offset(-10);
        make.height.top.mas_equalTo(self.totalTimeLabel);
    }];
}



- (void)initPlayer {
    _player = new CFFmpegPlayer();
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MyHeartWillGoOn" ofType:@"mp4"];
    const char *fileName = [filePath cStringUsingEncoding:NSUTF8StringEncoding];
    // 传入文件路径
    _player->setFilename(fileName);
    __weak typeof(self) weakSelf = self;
    _player->setPlayFailFunc([weakSelf](CFFmpegPlayer * player){
        [weakSelf playFailFunc:player];
    });
    _player->setInitFinishFunc([weakSelf](CFFmpegPlayer * player){
        [weakSelf initFinishFunc:player];
    });
    _player->setTimeChangeFunc([weakSelf](CFFmpegPlayer * player){
        [weakSelf timeChangeFunc:player];
    });
    _player->setStateChangeFunc([weakSelf](CFFmpegPlayer * player){
        [weakSelf stateChangeFunc:player];
    });
    _player->setFrameDevodedFunc([weakSelf](CFFmpegPlayer * player,uint8_t * data,uint64_t len,int width,int height){
        [weakSelf frameDevodedFunc:player imgData:data len:len width:width height:height];
    });
    
}

- (void)initFinishFunc:(CFFmpegPlayer *)player {
    self.progressSlider.maximumValue = player->getDuration();
    [self updateLabel:self.totalTimeLabel seconds:player->getDuration()];
    
    NSLog(@"---%s---",__func__);
}

- (void)playFailFunc:(CFFmpegPlayer *)player {

    NSLog(@"---%s---",__func__);
}

- (void)timeChangeFunc:(CFFmpegPlayer *)player {
    int seconds = player->getTime();
    [self updateLabel:self.timeLabel seconds:seconds];
    self.progressSlider.value = seconds;
}

- (void)stateChangeFunc:(CFFmpegPlayer *)player {
    BOOL isPluse = NO;
    BOOL isEnable = NO;
    switch (player->getState()) {
        case CFFmpegPlayer::Stopped:
            self.progressSlider.value = self.progressSlider.minimumValue;
            [self updateLabel:self.timeLabel seconds:0];
            [self updateLabel:self.totalTimeLabel seconds:0];
            isPluse = YES;
            break;
        case CFFmpegPlayer::Playing:
            isEnable = YES;
            break;
        case CFFmpegPlayer::Paused:
            isPluse = YES;
            isEnable = YES;
            break;
    }
    self.playButton.selected = isPluse;
    self.playButton.enabled = isEnable;
    self.silenceButton.enabled = isEnable;
    self.progressSlider.enabled = isEnable;
    self.sounderSilder.enabled = isEnable;
}

- (void)frameDevodedFunc:(CFFmpegPlayer *)player
                 imgData:(uint8_t *)data len:(uint64_t)len
                   width:(int)width height:(int)height {
    NSData *imgData = [[NSData alloc] initWithBytes:data length:len];
    free(data);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_metalview updateYUVData:imgData width:width hegiht:height];
//        [self->_myview setVideoSize:width height:height];
//        [self->_myview displayYUV420pData:data width:width height:height];
    });
    
    NSLog(@"---%s---",__func__);
}

- (void)playAction:(UIButton *)button {
    BOOL isPuse = button.isSelected;
    button.selected = !isPuse;
    if (isPuse) {
        _player->play();
    } else {
        _player->pluse();
    }
    
}

- (void)stopAction:(UIButton *)button {
    _player->stop();
}

- (void)silenceAction:(UIButton *)button {
    BOOL isSilence = button.isSelected;
    button.selected = !isSilence;
    _player->setMute(!isSilence);
}

- (void)progressValueChange:(UISlider *)slider {
    [self updateLabel:self.timeLabel seconds:int(slider.value)];
}

- (void)progressValueClick:(UISlider *)slider {
    _player->setTime(int(slider.value));
}

- (void)sounderValueChange:(UISlider *)slider {
    int sound = slider.value;
    _player->setVolumn(sound);
    self.soundLabel.text = [NSString stringWithFormat:@"%d",sound];
}

- (void)updateLabel:(UILabel *)label seconds:(NSInteger)seconds {
    NSString *h = [[NSString stringWithFormat:@"0%ld",seconds / 3600] substringToIndex:2];
    NSString *m = [[NSString stringWithFormat:@"0%ld",(seconds % 3600) / 60] substringToIndex:2];
    NSString *s = [[NSString stringWithFormat:@"0%ld",(seconds % 3600) % 60] substringToIndex:2];
    label.text = [NSString stringWithFormat:@"%@:%@:%@",h,m,s];

}

//MARK: getter & setter
- (OpenGLMetalKitView *)metalview {
    if (!_metalview) {
        _metalview = [[OpenGLMetalKitView alloc] initWithFrame:self.view.bounds];
    }
    return _metalview;
}

- (UIButton *)playButton {
    if(!_playButton) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.cornerRadius = 20;
        button.layer.borderWidth = 1;
        button.layer.backgroundColor = [UIColor blueColor].CGColor;
        [button setTitle:@"播放" forState:UIControlStateNormal];
        [button setTitle:@"暂停" forState:UIControlStateSelected];
        [button addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
        _playButton = button;
    }
    return _playButton;
}


- (UIButton *)stopButton {
    if(!_stopButton) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"停止" forState:UIControlStateNormal];
        button.layer.cornerRadius = 20;
        button.layer.borderWidth = 1;
        button.layer.backgroundColor = [UIColor blueColor].CGColor;
        [button addTarget:self action:@selector(stopAction:) forControlEvents:UIControlEventTouchUpInside];
        _stopButton = button;
    }
    return _stopButton;
}

- (UIButton *)silenceButton {
    if(!_silenceButton) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"静音" forState:UIControlStateNormal];
        [button setTitle:@"已静音" forState:UIControlStateSelected];
        button.layer.cornerRadius = 20;
        button.layer.borderWidth = 1;
        button.layer.backgroundColor = [UIColor blueColor].CGColor;
        [button addTarget:self action:@selector(silenceAction:) forControlEvents:UIControlEventTouchUpInside];
        _silenceButton = button;
    }
    return _silenceButton;
}

- (UISlider *)progressSlider {
    if(!_progressSlider) {
        UISlider *slider = [[UISlider alloc] init];
        slider.minimumValue = 0;
        _progressSlider = slider;
        [_progressSlider addTarget:self action:@selector(progressValueChange:) forControlEvents:UIControlEventValueChanged];
        [_progressSlider addTarget:self action:@selector(progressValueClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _progressSlider;
}

- (UISlider *)sounderSilder {
    if(!_sounderSilder) {
        UISlider *slider = [[UISlider alloc] init];
        slider.minimumValue = 0;
        slider.minimumValue = 100;
        [_sounderSilder addTarget:self action:@selector(sounderValueChange:) forControlEvents:UIControlEventValueChanged];
        _sounderSilder = slider;
    }
    return _sounderSilder;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        _timeLabel = label;
    }
    return _timeLabel;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        _totalTimeLabel = label;
    }
    return _totalTimeLabel;
}

- (UILabel *)soundLabel {
    if (!_soundLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        _soundLabel.text = @"100";
        _soundLabel = label;
    }
    return _soundLabel;
}
@end

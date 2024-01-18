//
//  WAVRecordAndPlayViewController.m
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2023/12/31.
//
#import "WAVRecordManager.h"
#import "WAVPlayManager.h"
#import "FileMannager.h"
#import "WAVRecordAndPlayViewController.h"

@interface WAVRecordAndPlayViewController ()<WAVRecordManagerDelegate>
@property(nonatomic,strong) UIButton *recordButton;
@property(nonatomic,strong) UIButton *stopButton;
@property(nonatomic,strong) UIButton *playButton;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,copy) NSURL *filePath;
@end

@implementation WAVRecordAndPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WAVRecordManager.shareInstance.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.recordButton];
    [self.view addSubview:self.stopButton];
    [self.view addSubview:self.playButton];
    self.timeLabel.frame = CGRectMake(100, 100, 200, 40);
    self.recordButton.frame = CGRectMake(100, 200, 200, 40);
    self.stopButton.frame = CGRectMake(100, 300, 200, 40);
    self.playButton.frame = CGRectMake(100, 400, 200, 40);
    [[self.timeLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
   [[self.recordButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
   [[self.stopButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    [[self.playButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
    
}

- (void)recordAction {
    if([WAVRecordManager.shareInstance isRecoding]) {
        return;
    }
    self.filePath = [NSURL fileURLWithPath:[FileMannager localFilePathWAV]];
    [WAVRecordManager.shareInstance startRecordWithFilePath:self.filePath];
}

- (void)stopAction {
    [WAVRecordManager.shareInstance stopRecord];
}

- (void)playAction {
    if(!self.filePath || [WAVPlayManager.shareInstance isPlaying]) {
        return;
    }
    [[WAVPlayManager shareInstance] startPlayWithFilePath:self.filePath];
}

//MARK: WAVRecordManagerDelegate
- (void)recordTime:(NSInteger)ms {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.timeLabel.text = [NSString stringWithFormat:@"录制的时长:%ld:%ld",ms/1000,ms % 1000];
    });
}

//MARK: getter
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
        _timeLabel = label;
    }
    return _timeLabel;
}

- (UIButton *)recordButton {
    if (!_recordButton) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"开始录制" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
        _recordButton = button;
    }
    return _recordButton;
}

- (UIButton *)stopButton {
    if (!_stopButton) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"停止录制" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(stopAction) forControlEvents:UIControlEventTouchUpInside];
        _stopButton = button;
    }
    return _stopButton;
}


- (UIButton *)playButton {
    if (!_playButton) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:@"播放录制音频" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
        _playButton = button;
    }
    return _playButton;
}
@end

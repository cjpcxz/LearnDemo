//
//  WAVRecordManager.h
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2023/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol WAVRecordManagerDelegate <NSObject>
// 录制时长，返回ms
- (void)recordTime:(NSInteger)ms;

@end
@interface WAVRecordManager : NSObject
@property(nonatomic,assign,readonly)BOOL isRecoding;
@property(nonatomic,weak)id<WAVRecordManagerDelegate> delegate;

+ (instancetype)shareInstance;

- (void)startRecordWithFilePath:(NSURL *)filePath;

- (void)stopRecord;
@end

NS_ASSUME_NONNULL_END

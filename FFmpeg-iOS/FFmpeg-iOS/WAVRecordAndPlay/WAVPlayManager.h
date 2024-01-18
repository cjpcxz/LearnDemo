//
//  WAVPlayManager.h
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2023/12/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WAVPlayManager : NSObject
@property(nonatomic,assign,readonly)BOOL isPlaying;

+ (instancetype)shareInstance;
- (void)startPlayWithFilePath:(NSURL *)filePath;
- (void)stopRecord;
@end

NS_ASSUME_NONNULL_END

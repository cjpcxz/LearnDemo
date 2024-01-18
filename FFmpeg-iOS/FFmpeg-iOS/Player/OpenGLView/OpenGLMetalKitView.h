//
//  OpenGLMetalKitView.h
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2024/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenGLMetalKitView : UIView
- (void)updateYUVData:(NSData *)yuvData width:(int)width hegiht:(int)height;
@end

NS_ASSUME_NONNULL_END

//
//  main.m
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2023/12/14.
//

#import <UIKit/UIKit.h>
#include "SDL.h"
#import "FFmpegMannagerViewController.h"
// SDL初始化必须要用SDL的Main，不经过SDL
int main(int argc, char * argv[]) {
    
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        FFmpegMannagerViewController *vc = [[FFmpegMannagerViewController alloc] init];
       
        [UIApplication sharedApplication].keyWindow.rootViewController =  [[UINavigationController alloc] initWithRootViewController:vc];
        [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
    }
    return 0;
}

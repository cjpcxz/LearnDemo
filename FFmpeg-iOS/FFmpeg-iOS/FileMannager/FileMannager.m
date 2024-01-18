//
//  FileMannager.m
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2023/12/31.
//

#import "FileMannager.h"

@implementation FileMannager

+ (NSString *)localFilePathWAV {
    return [[self localFolderPath] stringByAppendingPathComponent:[self localPathNameWithFormat:@"wav"]];
}

+ (NSString *)localPathNameWithFormat:(NSString *)fmt {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd-HH-mm-ss-SSS"];
    NSString *fileName = [NSString stringWithFormat:@"record-%@.%@", [formater stringFromDate:[NSDate date]],fmt];
    return fileName;
}


+ (NSString *)localFolderPath {
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *paths = [documents objectAtIndex:0];
    NSString *folderPaths = [paths stringByAppendingPathComponent:@"FFMPEG"];
    folderPaths = [folderPaths stringByAppendingPathComponent:@"Files"];
    //本地地址不在则创建
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL isDirectoryExit = [fileManager fileExistsAtPath:folderPaths isDirectory:&isDirectory];
    if (!(isDirectoryExit && isDirectory)) {
        NSError *error;
        [fileManager createDirectoryAtPath:folderPaths withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
        }
    }
    return folderPaths;
}
@end

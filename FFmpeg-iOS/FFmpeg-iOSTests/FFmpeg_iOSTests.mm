//
//  FFmpeg_iOSTests.m
//  FFmpeg-iOSTests
//
//  Created by 陈晶泊 on 2023/12/14.
//
#include "CFFmpegPlayer.hpp"
#import <XCTest/XCTest.h>

@interface FFmpeg_iOSTests : XCTestCase {
    CFFmpegPlayer *_player;
}

@end

@implementation FFmpeg_iOSTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    _player = new CFFmpegPlayer();
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MyHeartWillGoOn" ofType:@"mp4"];
    const char *fileName = [filePath cStringUsingEncoding:NSUTF8StringEncoding];
    // 传入文件路径
    _player->setFilename(fileName);
    _player->play();
    [self waitForExpectationsWithTimeout:3 handler:^(NSError * _Nullable error) {
        
    }];
    delete _player;
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

//
//  FFMpegCommonHeader.h
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2023/12/30.
//

#ifndef FFMpegCommonHeader_h
#define FFMpegCommonHeader_h


#endif /* FFMpegCommonHeader_h */

#define FFLog NSLog

// 返回错误描述
#define AV_ERROR_BUF(ret) \
    char errbuf[1024]; \
    av_strerror(ret, errbuf, sizeof (errbuf));


//
//  ZZAVPlayerTool.m

//  Created by  on 2019/11/20.
//  Copyright © 2019 . All rights reserved.
//

#import "ZZAVPlayerTool.h"
#import <AVFoundation/AVFoundation.h>
@interface ZZAVPlayerTool ()

@end

@implementation ZZAVPlayerTool

#pragma mark - init methods
- (instancetype)init{
    if (self == [super init]) {
        [self config];
    }
    return self;
}
- (void)config{

}
#pragma mark - public methods
/// 设置时间显示
+ (NSString *)zz_avPlayerConvertTime:(CGFloat)second{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    if (second / 3600 >= 1) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    }else {
        [dateFormatter setDateFormat:@"mm:ss"];
    }
    return [dateFormatter stringFromDate:date];
}
/// 获取视频的第一帧图片
+ (UIImage *)zz_avPlayerGetFirstImageWtihUrl:(NSURL *)avUrl{
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:avUrl options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    /// 获取视频第一帧图片
    CGImageRef image = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}
/// 获取视频总时间
+ (NSInteger)zz_avPlayerGetVideoTotalTimeWithURL:(NSURL*)url{
     NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    // 初始化视频媒体文件
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:opts];
    NSInteger seconds = ceil(asset.duration.value / asset.duration.timescale);
    return seconds;
}

/** 文档地址 */
+ (NSString *)documentPath{
    
    BOOL isDir = YES;
    NSString *docPath = [self getPathOfDictionory:NSDocumentDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:docPath isDirectory:&isDir ]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return docPath;
}
+ (NSString *)getPathOfDictionory:(NSSearchPathDirectory )searchDictionary {
    return NSSearchPathForDirectoriesInDomains(searchDictionary, NSUserDomainMask, YES).lastObject;
}




#pragma mark - Getters and Setters


@end

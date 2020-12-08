//
//  ZZAVPlayerTool.h
//  
//  Created by  on 2019/11/20.
//  Copyright © 2019 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZAVPlayerTool : NSObject
/// 是否包含视频轨道
+(BOOL)zz_avPlayerHaveTracksWithURL:(NSURL *)avUrl;
/// 设置时间显示
+ (NSString *)zz_avPlayerConvertTime:(CGFloat)second;
/// 获取视频的第一帧图片
+ (UIImage *)zz_avPlayerGetFirstImageWtihUrl:(NSURL *)avUrl;
/// 获取视频总时间
+ (NSInteger)zz_avPlayerGetVideoTotalTimeWithURL:(NSURL*)url;
/// 根据 url 得到完整路径、
+ (NSString*)zz_avPlayerGetDocumentPathWithUrl:(NSURL*)url;
/** 文档地址 */
+ (NSString *)zzx_documentByAppendingPathComponent:(NSString *)string;


@end

NS_ASSUME_NONNULL_END

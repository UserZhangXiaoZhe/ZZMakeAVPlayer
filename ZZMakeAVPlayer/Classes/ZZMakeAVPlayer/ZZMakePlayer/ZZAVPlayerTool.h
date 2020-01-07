//
//  ZZAVPlayerTool.h
//  
//  Created by  on 2019/11/20.
//  Copyright © 2019 . All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZAVPlayerTool : NSObject

/// 设置时间显示
+ (NSString *)zz_avPlayerConvertTime:(CGFloat)second;
/// 获取视频的第一帧图片
+ (UIImage *)zz_avPlayerGetFirstImageWtihUrl:(NSURL *)avUrl;
/// 获取视频总时间
+ (NSInteger)zz_avPlayerGetVideoTotalTimeWithURL:(NSURL*)url;

/** 文档地址 */
+ (NSString *)documentPath;


@end

NS_ASSUME_NONNULL_END

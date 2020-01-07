//
//  ZZAVPlayer.h
//  
//  Created by  on 2019/11/20.
//  Copyright © 2019 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "ZZAVPlayerTool.h"
#import "ZZAVPlayerViewConfiguration.h"

NS_ASSUME_NONNULL_BEGIN
@class ZZAVPlayer;
@protocol ZZAVPlayerDelegate <NSObject>


/// 播放器的状态和错误码
- (void)zz_player:(ZZAVPlayer *)avPlayer
   avPlayerStatus:(ZZAVPlayerStatus)avPlayerStatus
avPlayerErrorCode:(ZZAVPlayerErrorCode)avPlayerErrorCode;

/// 播放进度
/// @param avPlayer 播放器
/// @param progress 进度 0～1
/// @param currentTime 当前时间
/// @param durationTime 总时间
- (void)zz_player:(ZZAVPlayer *)avPlayer progress:(CGFloat)progress currentTime:(CGFloat)currentTime durationTime:(CGFloat)durationTime;

@end
@interface ZZAVPlayer : NSObject

/** 视频总时间 */
@property (nonatomic,readonly,assign) CGFloat totalTime;
/** 视频第一帧图片 */
@property (nonatomic,readonly,strong) UIImage *fristImage;

/** 代理 */
@property (nonatomic,weak) id <ZZAVPlayerDelegate> delegate;

/** 进入后台是否停止播放，默认yes */
@property (nonatomic,assign) BOOL isStopWhenAppEnterBackground;
/** 是否立即播放，默认yes */
@property (nonatomic,assign) BOOL isNowPlay;

+ (instancetype)sharedAVPlayer;

/// 获取AVPlayerLayer
-(AVPlayerLayer*)zz_playerGetPlayerLayerWithURL:(NSURL *)avUrl;
/// 开始播放
-(void)zz_playerSeekToTime:(CGFloat)seconds;
/// 恢复播放
-(void)zz_playerResume;
/// 暂停
-(void)zz_playerPause;
/// 停止
-(void)zz_playerStop;
/// 重播
-(void)zz_playerReplayWithURL:(NSURL *)avUrl;
@end

NS_ASSUME_NONNULL_END

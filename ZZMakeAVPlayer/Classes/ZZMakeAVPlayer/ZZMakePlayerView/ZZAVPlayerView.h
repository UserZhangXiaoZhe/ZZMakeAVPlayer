//
//  ZZAVPlayerView.h

//  Created by  on 2019/11/20.
//  Copyright © 2019 . All rights reserved.
//

/**
 描述：播放器展示view
*/

#import <UIKit/UIKit.h>
#import "ZZAVPlayerViewConfiguration.h"
#import "ZZAVPlayerTool.h"

NS_ASSUME_NONNULL_BEGIN

@class ZZAVPlayerView;
@protocol ZZAVPlayerViewDelegate <NSObject>

@required
/** 设备方向描述 */
- (void)zz_avPlayerView:(ZZAVPlayerView*)playerView deviceDirection:(ZZAVPlayerDeviceDirection )direction;
/** 播放状态 */
- (void)zz_avPlayerView:(ZZAVPlayerView*)playerView avPlayerStatus:(ZZAVPlayerStatus )playerStatus;
/** 控制工具view显示状态 */
- (void)zz_avPlayerView:(ZZAVPlayerView*)playerView controlViewStatus:(ZZAVPlayerControlViewStatus )controlViewStatus;
@optional

@end

@interface ZZAVPlayerView : UIView

@property (nonatomic, weak) id<ZZAVPlayerViewDelegate> delegate;

@property (nonatomic,readonly,strong) ZZAVPlayerViewConfiguration *configuration;//初始化配置

/** 视频播放地址数组 随机播放和顺序播放只有设置了该属性才生效*/
@property (nonatomic, strong)NSArray *videoArray;
/** 视频地址数组在数组中位置，随机播放和顺序播放只有设置了该属性才生效 */
@property (nonatomic,assign) NSInteger videoIndex;

/** 初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame WithConfiguration:(ZZAVPlayerViewConfiguration *)configuration;

/** 播放视频并设置开始播放时间 */
- (void)startPlayWithURL:(NSURL *)avUrl startTime:(CGFloat)starTtime;

- (void)stopPlay;
@end

NS_ASSUME_NONNULL_END

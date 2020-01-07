//
//  ZZAVPlayerViewConfiguration.h

//  Created by  on 2019/11/20.
//  Copyright © 2019 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const ZZKEY_VIDEOPATH;
FOUNDATION_EXTERN NSString *const ZZKEY_VIDEONAME;
FOUNDATION_EXTERN NSString *const ZZKEY_VIDEOAUTHOR;
FOUNDATION_EXTERN NSString *const ZZKEY_VIDEOTYPE;

//手势操作的类型
typedef NS_ENUM(NSInteger,ZZAVPlayerGestureType) {
    ZZAVPlayerGestureTypeProgress,  //视频进度调节操作
    ZZAVPlayerGestureTypeVoice,     //声音调节操作
    ZZAVPlayerGestureTypeLight,     //屏幕亮度调节操作
    ZZAVPlayerGestureTypeNone,      //其他情况
};

//播放类型
typedef NS_ENUM(NSInteger,ZZAVPlayerPlayType) {
    ZZAVPlayerPlayTypeReplay,   //重复播放
    ZZAVPlayerPlayTypeOrder,    //顺序播放
    ZZAVPlayerPlayTypeRandom,   //随机播放
    ZZAVPlayerPlayTypeOnce,     //仅播放一次
    ZZAVPlayerPlayTypeCycle,    //循环播放
};

typedef NS_ENUM(NSInteger,ZZAVPlayerStatus){
    ZZAVPlayerStatusLoading,    ///< 加载中
    ZZAVPlayerStatusPlaying,    ///< 播放中
    ZZAVPlayerStatusEnd,        ///< 播放结束
    ZZAVPlayerStatusStopped,    ///< 停止
    ZZAVPlayerStatusPause,      ///< 播放暂停
    ZZAVPlayerStatusError,      ///< 出错
    ZZAVPlayerStatusBack,       ///< 返回
};

typedef NS_ENUM(NSInteger,ZZAVPlayerErrorCode){
    ZZAVPlayerErrorCodeNoError,             ///< 正常
    ZZAVPlayerErrorCodeOtherStatus,         ///< 其他错误
    ZZAVPlayerErrorCodeOutTime,             ///< 超时
    ZZAVPlayerErrorCodeNotFound,            ///< 未找到
    ZZAVPlayerErrorCodeNoNetwork,           ///< 无网络
    ZZAVPlayerErrorCodeNetworkInterrupt,    ///< 网络中断
    ZZAVPlayerErrorCodeUrlError             ///< 网址错误
};

//手机方向
typedef NS_ENUM(NSInteger,ZZAVPlayerDeviceDirection) {
    ZZAVPlayerDeviceDirectionCustom,    //其他
    ZZAVPlayerDeviceDirectionTop,       //上
    ZZAVPlayerDeviceDirectionBottom,    //下
    ZZAVPlayerDeviceDirectionLeft,      //左
    ZZAVPlayerDeviceDirectionRight,     //右
};
 // 控制工具view显示状态
typedef NS_ENUM(NSInteger,ZZAVPlayerControlViewStatus) {
    ZZAVPlayerControlViewStatusShow,          //显示
    ZZAVPlayerControlViewStatusHidden,        //隐藏
};

@interface ZZAVPlayerViewConfiguration : NSObject

/** 主色调 */
@property(nonatomic,strong) UIColor *mainColor;
/** 设置自动隐藏面板时间，默认5秒，为0时表示关闭自动隐藏功能 */
@property (nonatomic,assign) CGFloat autoHideTime;
/** 视频的显示模式,默认按原视频比例显示,多余两边留黑  */
@property (nonatomic,assign) AVLayerVideoGravity avPlayerGravity;
/** 返回标题文字，默认 "正在播放" */
@property (nonatomic,strong) NSString *backString;
/** 是否立即播放，默认yes */
@property (nonatomic,assign) BOOL isNowPlay;
/** 是否显示 控制工具view， 默认NO*/
@property (nonatomic,assign) BOOL isHiddenControlView;
/** 是否用视频第一帧显示为占位背景，默认NO */
@property (nonatomic,assign) BOOL isHaveFristImage;
/** 是否使用手势控制音量和亮度，默认yes */
@property (nonatomic,assign) BOOL isEnableVolumeGesture;
/** 是否使用手势控制播放进度，默认yes */
@property (nonatomic,assign) BOOL isPlayProgressGesture;
/** 是否允许横竖屏，默认yes */
@property (nonatomic,assign) BOOL isCanHorizontalOrVerticalScreen;
/** 是否打开重力感应，默认yes */
@property (nonatomic,assign) BOOL isOpenGravitySensing;
/** 手势滑动触发的最小距离，默认3 */
@property (nonatomic,assign) CGFloat gestureSliderMinX;
/** 设置播放类型，默认重复播放 */
@property (nonatomic,assign) ZZAVPlayerPlayType avPlayerType;

/************ 内部使用 可以获取,别改数据 ************/
/** 播放器状态 */
@property (nonatomic,assign) ZZAVPlayerStatus avPlayerStatus;
/** 视频总时间 */
@property (nonatomic,assign) CGFloat totalTime;
/** 视频地址 */
@property (nonatomic,strong) NSURL *avUrl;
/** 视频第一帧图片 */
@property (nonatomic,strong) UIImage *avPlayerFirstImage;
/** 判断当前的状态是否显示为全屏 */
@property (nonatomic,assign) BOOL isFullScreen;
/** 用来判断手势是否移动过 */
@property (nonatomic,assign) BOOL isGestureMoved;
/** 记录touch开始的点 */
@property (nonatomic,assign) CGPoint touchBeginPoint;
/** 记录触摸开始的音量 */
@property (nonatomic,assign) CGFloat touchBeginVoiceValue;
/** 手势控制的类型 判断当前手势是在控制进度、声音、亮度 */
@property (nonatomic,assign) ZZAVPlayerGestureType gestureType;


@end

NS_ASSUME_NONNULL_END

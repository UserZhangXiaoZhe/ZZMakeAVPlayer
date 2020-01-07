//
//  ZZAVPlayerFastView.h

//  Created by  on 2019/11/20.
//  Copyright © 2019 zz. All rights reserved.

/**
 描述：快进快退提示view
*/
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZAVPlayerFastView : UIView

/** 触摸开始时视频播放的时间 */
@property (nonatomic,assign) CGFloat touchBeginValue;
/** 正在手势滑动快进快退 */
@property (nonatomic,assign) BOOL isMoveGestureFast;

- (void)setIsMoveGestureFast:(BOOL)moveGestureFast;
- (void)setProgressTintColor:(UIColor *)color;
- (void)updateFastValue:(CGFloat)value TotalTime:(CGFloat)time;

@end

NS_ASSUME_NONNULL_END

//
//  ZZAVPlayerLightView.h

//  Created by  on 2019/11/20.
//  Copyright © 2019 . All rights reserved.

/**
 描述：播放器亮度调节指示View
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZAVPlayerLightView;
@protocol ZZAVPlayerLightViewDelegate <NSObject>

@optional

@end


@interface ZZAVPlayerLightView : UIView

@property (nonatomic, weak) id<ZZAVPlayerLightViewDelegate> delegate;

/// 记录触摸开始亮度
@property (nonatomic,assign) CGFloat touchBeginLightValue;
/// 是否改变亮度
@property (nonatomic,assign) BOOL isChangeLightValue;

/// 设置数据
- (void)updateLightValue:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END

//
//  ZZAVPlayerSlider.h

//  Created by  on 2019/11/20.
//  Copyright © 2019 . All rights reserved.
//

/**
描述：进度条view
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZAVPlayerSlider;
@protocol ZZAVPlayerSliderDelegate <NSObject>

@optional

@end


@interface ZZAVPlayerSlider : UISlider

@property (nonatomic, weak) id<ZZAVPlayerSliderDelegate> delegate;

@property (nonatomic, strong) UIView *tapView;
/// 基础view
@property (nonatomic, strong) UIView *baseView;
/// 缓冲背景view
@property (nonatomic, strong) UIView *bufferView;
/// 跟随(手指滑动)背景view
@property (nonatomic, strong) UIView *trackView;
/// 滑动图片image
@property (nonatomic, strong) UIImageView *slipImgView;
/// 缓冲值
@property (nonatomic, assign) float bufferValue;
/// 跟随(手指滑动)值
@property (nonatomic, assign) float trackValue;

@end

NS_ASSUME_NONNULL_END

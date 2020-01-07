//
//  ZZAVPlayerLightView.m

//  Created by  on 2019/11/20.
//  Copyright © 2019 . All rights reserved.
//

#import "ZZAVPlayerLightView.h"

@interface ZZAVPlayerLightView ()

/** 给显示亮度的view添加毛玻璃效果 */
@property (nonatomic,strong) UIVisualEffectView *effectView;

@end

@implementation ZZAVPlayerLightView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.redColor;
        [self setupSubview];
    }
    return self;
}

#pragma mark - Private methods
-(void)setupSubview
{
    
}

#pragma mark - public methods
- (void)updateLightValue:(CGFloat)value{
    /// 判断控制一下, 不能超出 0~1
    value = MAX(0, value);
    value = MIN(value, 1);
    /// 改变屏幕亮度
    [UIScreen mainScreen].brightness = value;
}

#pragma mark - Getters and Setters
-(void)setIsChangeLightValue:(BOOL)changeLightValue{
    _isChangeLightValue = changeLightValue;
    if (changeLightValue) {
        [UIView animateWithDuration:0.3 animations:^{
            self.hidden = !changeLightValue;
        }];
    }else{
        self.hidden = !changeLightValue;
    }
}
- (CGFloat)touchBeginLightValue{
    return [UIScreen mainScreen].brightness; /// 当前亮度
}
@end

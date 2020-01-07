//
//  ZZAVPlayerViewConfiguration.m

//  Created by  on 2019/11/20.
//  Copyright © 2019 zz. All rights reserved.
//

#import "ZZAVPlayerViewConfiguration.h"

NSString *const ZZKEY_VIDEOPATH   = @"ZZVideoPath";
NSString *const ZZKEY_VIDEONAME   = @"ZZVideoName";
NSString *const ZZKEY_VIDEOAUTHOR = @"ZZVideoAuthor";
NSString *const ZZKEY_VIDEOTYPE   = @"ZZVideoType";

@interface ZZAVPlayerViewConfiguration ()

@end

@implementation ZZAVPlayerViewConfiguration

#pragma mark - init methods
- (instancetype)init{
    if (self == [super init]) {
        [self config];
    }
    return self;
}
- (void)config{
    self.mainColor = UIColor.blackColor;
    self.isHaveFristImage = YES;
    self.isEnableVolumeGesture = YES;
    self.isHiddenControlView = NO;
    self.isNowPlay = YES;
    self.avPlayerGravity = AVLayerVideoGravityResizeAspect;
    self.autoHideTime = 5.0;
    self.avPlayerType = ZZAVPlayerPlayTypeCycle;
    self.backString = @"正在播放";
    self.isCanHorizontalOrVerticalScreen = YES;
    self.avPlayerStatus = ZZAVPlayerPlayTypeOrder;
    self.isOpenGravitySensing = YES;
    self.isPlayProgressGesture = YES;
    self.gestureSliderMinX = 3;
    self.isGestureMoved = NO;
    self.gestureType = ZZAVPlayerGestureTypeNone;
    self.avPlayerFirstImage = [UIImage imageNamed:@"zzMakePlayer_background"];
}
#pragma mark - Private methods

#pragma mark - public methods

#pragma mark - Delegate
//(多个代理方法依次往下写)

#pragma mark - Getters and Setters


@end

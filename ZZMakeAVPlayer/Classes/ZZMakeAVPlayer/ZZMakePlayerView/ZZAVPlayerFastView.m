//
//  ZZAVPlayerFastView.m

//  Created by  on 2019/11/20.
//  Copyright © 2019 zz. All rights reserved.
//

#import "ZZAVPlayerFastView.h"
#import "ZZAVPlayerTool.h"

@interface ZZAVPlayerFastView ()

@property(nonatomic,strong) UIProgressView *progressView;
@property(nonatomic,strong) UILabel *timeLabel;

@end

@implementation ZZAVPlayerFastView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupSubview];
    }
    return self;
}

#pragma mark - Private methods
-(void)setupSubview
{
    CGFloat H = self.frame.size.height / 4;
    CGFloat w = self.frame.size.width * 2 / 3;
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, H)];
    self.timeLabel.center = CGPointMake(self.frame.size.width*.5, H*1.5);
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.font = [UIFont systemFontOfSize:(13)];
    self.timeLabel.textColor = UIColor.whiteColor;
    [self addSubview:self.timeLabel];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.frame = CGRectMake(0, 0, w, 2);
    self.progressView.center = CGPointMake(self.frame.size.width*.5, H*3);
    [self addSubview:self.progressView];
}

#pragma mark - public methods
- (void)setProgressTintColor:(UIColor *)color{
    _progressView.progressTintColor = color;
}
- (void)updateFastValue:(CGFloat)value TotalTime:(CGFloat)time{
    CGFloat x = value / time;
    [self.progressView setProgress:x animated:NO];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ / %@", [ZZAVPlayerTool zz_avPlayerConvertTime:value], [ZZAVPlayerTool zz_avPlayerConvertTime:time]];
}
- (void)setIsMoveGestureFast:(BOOL)moveGestureFast{
    _isMoveGestureFast = moveGestureFast;
    [UIView animateWithDuration:0.3 animations:^{
        self.hidden = !moveGestureFast;
    }];
}

#pragma mark - Delegate
//(多个代理方法依次往下写)


#pragma mark - Getters and Setters

@end

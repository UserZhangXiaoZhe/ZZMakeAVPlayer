//
//  ZZAVPlayerSettingView.m

//  Created by  on 2020/1/7.
//  Copyright © 2020 . All rights reserved.
//

#import "ZZAVPlayerSettingView.h"

@interface ZZAVPlayerSettingView ()

/// 描述
@property (nonatomic,readwrite,strong) UILabel *tipsLabel;

@end

@implementation ZZAVPlayerSettingView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubview];
    }
    return self;
}

- (void)dealloc{
    
#ifdef DEBUG
    NSLog(@"%s",__func__);
#endif
}

#pragma mark - Private methods
-(void)setupSubview{
    self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
}

#pragma mark - public methods


#pragma mark - Delegate


#pragma mark - Getters and Setters

@end

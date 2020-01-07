//
//  ZZAVPlayerSlider.m

//  Created by  on 2019/11/20.
//  Copyright © 2019 . All rights reserved.
//

#import "ZZAVPlayerSlider.h"

@interface ZZAVPlayerSlider ()

/// 描述
@property (nonatomic,readwrite,strong) NSString*status;

@end

@implementation ZZAVPlayerSlider

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

}

#pragma mark - public methods


#pragma mark - Delegate
//(多个代理方法依次往下写)


#pragma mark - Getters and Setters

@end

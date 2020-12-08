//
//  ZZViewController.m
//  ZZMakeAVPlayer
//
//  Created by UserZhangXiaoZhe on 01/07/2020.
//  Copyright (c) 2020 UserZhangXiaoZhe. All rights reserved.
//

#import "ZZViewController.h"
#import "ZZAVPlayerVC.h"
@interface ZZViewController ()

@end

@implementation ZZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitle:@"视频播放" forState:UIControlStateNormal];
    button.bounds = CGRectMake(0, 0, button.intrinsicContentSize.width, button.intrinsicContentSize.height);
    button.center = CGPointMake(self.view.center.x, 200);
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}
- (void)clickButton:(UIButton *)button {
    ZZAVPlayerVC *vc = [[ZZAVPlayerVC alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:^{}];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

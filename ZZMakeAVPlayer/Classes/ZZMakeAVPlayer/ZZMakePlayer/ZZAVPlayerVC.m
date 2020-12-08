//
//  ZZAVPlayerVC.m

//  Created by  on 2019/11/25.
//  Copyright © 2019 . All rights reserved.
//

#import "ZZAVPlayerVC.h"
#import "ZZAVPlayerView.h"
#import "ZZAVPlayerMacro.h"
#import "NSBundle+ZZAVPlayerBundle.h"

@interface ZZAVPlayerVC ()<ZZAVPlayerViewDelegate>

@property (nonatomic,strong)ZZAVPlayerView *playerView;

@end

@implementation ZZAVPlayerVC

#pragma mark - Life Cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupNavgationItem];
    [self setupSubview];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

#ifdef DEBUG
- (void)dealloc{
    [self.playerView stopPlay];
    NSLog(@"%s",__func__);
}
#endif

#pragma mark - Private method
-(void)setupNavgationItem{
    
}
-(void)setupSubview{
    self.view.backgroundColor = [UIColor clearColor];
    //刀剑如梦
    NSURL *urlPath1 = [[NSBundle getCurrentBundle] URLForResource:@"刀剑如梦.mp3" withExtension:nil];
    
    NSURL *urlPath2 = [[NSBundle getCurrentBundle] URLForResource:@"陈一发.mp4" withExtension:nil];
    
    //NSString *tempPath = [[ZZAVPlayerTool documentPath] stringByAppendingPathComponent:self.fileName];
    //NSURL *urlPath = [NSURL fileURLWithPath:tempPath];

    NSMutableDictionary *mutableParam1 = [NSMutableDictionary dictionary];
    mutableParam1[ZZKEY_VIDEONAME] = @"刀剑如梦.mp3";
    mutableParam1[ZZKEY_VIDEOPATH] = urlPath1;
    
    NSMutableDictionary *mutableParam2 = [NSMutableDictionary dictionary];
    mutableParam2[ZZKEY_VIDEONAME] = @"陈一发.mp4";
    mutableParam2[ZZKEY_VIDEOPATH] = urlPath2;
    
    if (self.fileArray == nil) {
        self.fileArray = [NSMutableArray array];
        [self.fileArray addObject:mutableParam1];
        [self.fileArray addObject:mutableParam2];
    }
    
    self.playerView = [[ZZAVPlayerView alloc] initWithFrame:CGRectMake(0, 0, ZZAVPlayer_SCREEN_W, ZZAVPlayer_SCREEN_H)];
    self.playerView.delegate = self;
    self.playerView.videoArray = self.fileArray;
    self.playerView.videoIndex = 0;
    
    NSURL *webUrl  = [NSURL URLWithString:@"https://mp4.vjshi.com/2018-08-31/3ba67e58deb45fefe7f7d3d16dbf2b16.mp4"];
    [self.playerView startPlayWithURL:webUrl startTime:0];
    
    [self.view addSubview:self.playerView];
}
#pragma mark - Public Method


#pragma mark - Event Response
/// 电池状态栏管理
- (BOOL)prefersStatusBarHidden{
    if (self.playerView.configuration.isFullScreen) {
        return YES;
    }else{
        return self.playerView.configuration.isHiddenControlView;
    }
}

#pragma mark - Delegate
-(void)zz_avPlayerView:(ZZAVPlayerView *)playerView deviceDirection:(ZZAVPlayerDeviceDirection)direction{
    [super setNeedsStatusBarAppearanceUpdate];
}
-(void)zz_avPlayerView:(ZZAVPlayerView *)playerView controlViewStatus:(ZZAVPlayerControlViewStatus)controlViewStatus{
    [super setNeedsStatusBarAppearanceUpdate];
}
-(void)zz_avPlayerView:(ZZAVPlayerView *)playerView avPlayerStatus:(ZZAVPlayerStatus)playerStatus{
    switch (playerStatus) {
        case ZZAVPlayerStatusBack:{
            [self dismissViewControllerAnimated:YES completion:nil];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Override
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark - Getters and Setters


@end

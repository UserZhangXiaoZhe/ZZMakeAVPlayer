//
//  ZZAVPlayerView.m

//  Created by  on 2019/11/20.
//  Copyright © 2019 . All rights reserved.
//

#import "ZZAVPlayerView.h"
#import <MediaPlayer/MPVolumeView.h>
#import "ZZAVPlayer.h"

#import "ZZAVPlayerFastView.h"
#import "ZZAVPlayerLightView.h"
#import "ZZAVPlayerSlider.h"
#import "ZZAVPlayTypeView.h"
#import "ZZAVPlayerVideoListView.h"
#import "ZZAVPlayerSettingView.h"

#import "UIColor+ZZAVPlayerColor.h"
#import "UIImage+ZZAVPlayerImage.h"
#import "ZZAVPlayerMacro.h"

static CGFloat const TopViewH = 50;

@interface ZZAVPlayerView ()<
UIGestureRecognizerDelegate,
ZZAVPlayerDelegate,
ZZAVPlayTypeViewDelegate,
ZZAVPlayerVideoListViewDelegate,
ZZAVPlayerSettingViewDelegate>

/* ********************* 播放器 *********************** */
@property (nonatomic,strong) ZZAVPlayer *avPlayer;
@property (nonatomic,strong) NSTimer *timer;//定时器
@property (nonatomic,assign) CGFloat startTime;//视频开始时间
@property (nonatomic,readwrite,strong) ZZAVPlayerViewConfiguration *configuration;//初始化配置

/* ******************** 布局视图 ********************** */
/** 播放器展示Layer */
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
/** 显示播放器 */
@property (nonatomic,strong) UIView *contentView;
/** 底部操作工具栏 */
@property (nonatomic,strong) UIImageView *bottomView;
/** 顶部操作工具栏 */
@property (nonatomic,strong) UIImageView *topView;
/** 开始播放前背景占位图片 */
@property (nonatomic,strong) UIImageView *backgroundImageView;
/** 显示播放视频的title */
@property (nonatomic,strong) UILabel *topTitleLabel;
/** 控制全屏的按钮 */
@property (nonatomic,strong) UIButton *fullScreenButton;
/** 播放暂停按钮 */
@property (nonatomic,strong) UIButton *playOrPauseButton;
/** 居中的暂停按钮 */
@property (nonatomic,strong) UIButton *pauseButton;
/** 左上角关闭按钮 */
@property (nonatomic,strong) UIButton *backButton;
/** 显示播放时间的UILabel */
@property (nonatomic,strong) UILabel *leftTimeLabel;
@property (nonatomic,strong) UILabel *rightTimeLabel;
/** 进度滑块 */
@property (nonatomic,strong) ZZAVPlayerSlider *playScheduleSlider;
/** 亮度调节 */
@property (nonatomic,strong) ZZAVPlayerLightView *lightView;
/** 快进快退 */
@property (nonatomic,strong) ZZAVPlayerFastView *fastView;
/** 播放顺序方式 */
@property (nonatomic,strong) ZZAVPlayTypeView *playTypeView;
/** 播放列表 */
@property (nonatomic,strong) ZZAVPlayerVideoListView *videoListView;
/** 播放设置 */
@property (nonatomic,strong) ZZAVPlayerSettingView *videoSettingView;
/** 声音滑块 */
@property (nonatomic,strong) UISlider *volumeSlider;
/** 显示缓冲进度 */
@property (nonatomic,strong) UIProgressView *loadingProgress;
/** 菊花（加载框）*/
@property (nonatomic,strong) UIActivityIndicatorView *loadingView;
/** 收藏按钮 */
@property (nonatomic,strong) UIButton *collectButton;
/** 下载按钮 */
@property (nonatomic,strong) UIButton *downloadButton;
/** 清晰度按钮 */
@property (nonatomic,strong) UIButton *definitionButton;

/** 蒙板 */
@property (nonatomic, strong) UIButton *maskBtn;

/*************** 记录视图初始位置 ***************/
/** 父视图 */
@property (nonatomic,assign) CGRect superViewFrame;
/** 显示播放器 */
@property (nonatomic,assign) CGRect contentViewFrame;
/** 底部操作工具栏 */
@property (nonatomic,assign) CGRect bottomViewFrame;
/** 顶部操作工具栏 */
@property (nonatomic,assign) CGRect topViewFrame;
/** 开始播放前背景占位图片 */
@property (nonatomic,assign) CGRect backImageViewFrame;
/** 显示播放视频的title */
@property (nonatomic,assign) CGRect topTitleLabelFrame;
/** 控制全屏的按钮 */
@property (nonatomic,assign) CGRect fullScreenButtonFrame;
/** 播放暂停按钮 */
@property (nonatomic,assign) CGRect playOrPauseButtonFrame;
/** 居中显示的暂停按钮 */
@property (nonatomic,assign) CGRect pauseButtonFrame;
/** 左上角关闭按钮 */
@property (nonatomic,assign) CGRect backButtonFrame;
/** 菊花（加载框）*/
@property (nonatomic,assign) CGRect loadingViewFrame;
/** 快进快退 */
@property (nonatomic,assign) CGRect fastViewFrame;
/** 播放方式 */
@property (nonatomic,assign) CGRect playTypeViewFrame;
/** 亮度条 */
@property (nonatomic,assign) CGRect lightViewFrame;
/** 显示播放时间的UILabel */
@property (nonatomic,assign) CGRect leftTimeLabelFrame;
@property (nonatomic,assign) CGRect rightTimeLabelFrame;
/** 播放进度滑块 */
@property (nonatomic,assign) CGRect playScheduleSliderFrame;
/** 显示缓冲进度 */
@property (nonatomic,assign) CGRect loadingProgressFrame;

@end

@implementation ZZAVPlayerView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self==[super initWithFrame:frame]) {
        self.configuration = [[ZZAVPlayerViewConfiguration alloc] init];
        [self setupSubview];
        [self addNotification];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame WithConfiguration:(ZZAVPlayerViewConfiguration *)configuration{
    self = [super initWithFrame:frame];
    if (self) {
        self.configuration = configuration;
        [self setupSubview];
        [self addNotification];
    }
    return self;
}
-(void)dealloc{
    
    //[self.avPlayer zz_playerStop];
    NSLog(@"%s",__func__);
}

#pragma mark - Private methods
//初始化
-(void)setupSubview{
    self.backgroundColor = UIColor.blackColor;
    // 显示播放器layer视图层
    [self addSubview:self.contentView];
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.loadingView];
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    [self addSubview:self.fastView];
    [self addSubview:self.pauseButton];
    //暂时隐藏亮度调节
    //[self addSubview:self.lightView];
    
    [self.bottomView addSubview:self.playOrPauseButton];
    [self.bottomView addSubview:self.leftTimeLabel];
    [self.bottomView addSubview:self.rightTimeLabel];
    [self.bottomView addSubview:self.fullScreenButton];
    [self.bottomView addSubview:self.loadingProgress];
    [self.bottomView addSubview:self.playScheduleSlider];
    
    [self.topView addSubview:self.backButton];
    [self.topView addSubview:self.topTitleLabel];
    
    /** 父视图 */
    self.superViewFrame = self.frame;
    /** 显示播放器 */
    self.contentViewFrame = self.contentView.frame;
    /** 底部操作工具栏 */
    self.bottomViewFrame = self.bottomView.frame;
    /** 顶部操作工具栏 */
    self.topViewFrame = self.topView.frame;
    /** 开始播放前背景占位图片 */
    self.backImageViewFrame = self.backgroundImageView.frame;
    /** 显示播放视频的title */
    self.topTitleLabelFrame = self.topTitleLabel.frame;
    /** 控制全屏的按钮 */
    self.fullScreenButtonFrame = self.fullScreenButton.frame;
    /** 播放暂停按钮 */
    self.playOrPauseButtonFrame = self.playOrPauseButton.frame;
    self.pauseButtonFrame = self.pauseButton.frame;
    /** 左上角关闭按钮 */
    self.backButtonFrame = self.backButton.frame;
    /** 进度滑块 */
    self.fastViewFrame = self.fastView.frame;
    /** 亮度条 */
    self.lightViewFrame = self.lightView.frame;
    /** 显示播放时间的UILabel */
    self.leftTimeLabelFrame = self.leftTimeLabel.frame;
    self.rightTimeLabelFrame = self.rightTimeLabel.frame;
    /** 显示缓冲进度 */
    self.loadingProgressFrame = self.loadingProgress.frame;
    /** 播放进度滑块 */
    self.playScheduleSliderFrame = self.playScheduleSlider.frame;
    /** 菊花（加载框）*/
    self.loadingViewFrame = self.loadingView.frame;

    // 单击的 Recognizer
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1; // 单击
    singleTap.numberOfTouchesRequired = 1;
    [self.contentView addGestureRecognizer:singleTap];
    
    // 双击的 Recognizer
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTouchesRequired = 1; //手指数
    doubleTap.numberOfTapsRequired = 2; // 双击
    [self.contentView addGestureRecognizer:doubleTap];
    
    // 解决点击当前view时候响应其他控件事件
    [singleTap setDelaysTouchesBegan:YES];
    [doubleTap setDelaysTouchesBegan:YES];
    //如果双击成立，则取消单击手势（双击的时候不回走单击事件）
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
}
#pragma mark - 添加通知
-(void)addNotification{
    //横竖屏切换 通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}
#pragma mark -  创建只执行一次的定时器,来自动隐藏控制view
-(void)setupTimer{
    // 为0时表示关闭自动隐藏功能
    if (self.configuration.autoHideTime <= 0) return;
    
    [self invalidTimer];
    
    // 创建只执行一次的定时器
    NSTimer *timer = [NSTimer timerWithTimeInterval:self.configuration.autoHideTime target:self selector:@selector(autohiddenControlView) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    self.timer = timer;
}
/// 使定时器失效
-(void)invalidTimer{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autohiddenControlView) object:nil];
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark - 显示、隐藏控制view
-(void)showControlView{
    if (self.configuration.avPlayerStatus == ZZAVPlayerStatusPlaying) {
        [self setupTimer];
    }else{
        [self invalidTimer];
    }
    self.configuration.isHiddenControlView =  NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomView.alpha = 1.0;
        self.topView.alpha = 1.0;
    }];
    if ([self.delegate respondsToSelector:@selector(zz_avPlayerView:controlViewStatus:)]) {
        [self.delegate zz_avPlayerView:self controlViewStatus:(ZZAVPlayerControlViewStatusShow)];
    }
}
/// 隐藏控制view
-(void)hiddenControlView{
    self.configuration.isHiddenControlView = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomView.alpha = 0;
        self.topView.alpha = 0;
    }];
    if ([self.delegate respondsToSelector:@selector(zz_avPlayerView:controlViewStatus:)]) {
        [self.delegate zz_avPlayerView:self controlViewStatus:(ZZAVPlayerControlViewStatusHidden)];
    }
}
/// 自动隐藏控制view
-(void)autohiddenControlView{
    [self hiddenControlView];
    [self invalidTimer];
    if (self.configuration.avPlayerStatus == ZZAVPlayerStatusPlaying) {
        if (self.bottomView.alpha == 1.0) {
            [self hiddenControlView];
            [self invalidTimer];
        }
    }
}
#pragma mark -  播放和暂停
- (void)playOrPauseAction:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (self.configuration.avPlayerStatus == ZZAVPlayerStatusPlaying) {
        [self.avPlayer zz_playerPause];
    }else if (self.configuration.avPlayerStatus == ZZAVPlayerStatusPause) {
        [self.avPlayer zz_playerResume];
    }else if (self.configuration.avPlayerStatus == ZZAVPlayerStatusStopped) {
        
        [self.avPlayer zz_playerSeekToTime:self.startTime];
    }else if (self.configuration.avPlayerStatus == ZZAVPlayerStatusEnd) {
        
        [self.avPlayer zz_playerSeekToTime:self.startTime];
    }
}
#pragma mark -  返回按钮
- (void)goBackAction:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(zz_avPlayerView:avPlayerStatus:)]) {
        
        [self.delegate zz_avPlayerView:self avPlayerStatus:ZZAVPlayerStatusBack];
        [self.avPlayer zz_playerStop];
        self.avPlayer = nil;
    }
}
#pragma mark - 进度条的拖拽事件 监听UISlider拖动状态
- (void)sliderValueChanged:(UISlider*)slider forEvent:(UIEvent*)event {
    //MyLog(@"进度条的拖拽:%f",slider.value);
    UITouch *touchEvent = [[event allTouches]anyObject];
    switch(touchEvent.phase) {
        case UITouchPhaseBegan:{
            [self.avPlayer zz_playerPause];
            self.playOrPauseButton.selected = NO;
        }
            break;
        case UITouchPhaseMoved:{
            self.leftTimeLabel.text = [ZZAVPlayerTool zz_avPlayerConvertTime:slider.value];
        }
            break;
        case UITouchPhaseEnded:{
            self.playOrPauseButton.selected = YES;
            
            CGFloat second = slider.value;
            self.startTime = second;
            [self.playScheduleSlider setValue:second animated:NO];
            [self.avPlayer zz_playerSeekToTime:second];
        }
            break;
        case UITouchPhaseCancelled:{
           
        }
            break;
        default:
            break;
    }
}
#pragma mark - 视频进度条的点击事件
- (void)tapGestureForSlider:(UITapGestureRecognizer *)gesture{
    CGPoint touchLocation = [gesture locationInView:self.playScheduleSlider];
    CGFloat value = (self.playScheduleSlider.maximumValue - self.playScheduleSlider.minimumValue) * (touchLocation.x / self.playScheduleSlider.frame.size.width);
    
    self.startTime = value;
    [self.playScheduleSlider setValue:value animated:YES];
    [self.avPlayer zz_playerSeekToTime:value];
    
}

#pragma mark - 底部按钮事件处理
- (void)bottomButtonAction:(UIButton*)sender{
    [self hiddenControlView];
    
    self.maskBtn.hidden = NO;
    [self addSubview:self.maskBtn];
    
    if (sender.tag ==  520) {
        //列表
        self.videoListView.hidden = NO;
        [self addSubview:self.videoListView];
        [self bringSubviewToFront:self.videoListView];
    }else if (sender.tag ==  521){
        //播放顺序
        self.playTypeView.hidden = NO;
        [self addSubview:self.playTypeView];
        [self bringSubviewToFront:self.playTypeView];
        
    }else if (sender.tag ==  522){
        //设置
       self.videoSettingView.hidden = NO;
       [self addSubview:self.videoSettingView];
       [self bringSubviewToFront:self.videoSettingView];
    }
}

- (void)maskBtnClick:(UIButton*)sender{
    
    self.videoListView.hidden = YES;
    [self.videoListView removeFromSuperview];
    
    self.playTypeView.hidden = YES;
    [self.playTypeView removeFromSuperview];
    
    self.videoSettingView.hidden = YES;
    [self.videoSettingView removeFromSuperview];
    
    [self.maskBtn removeFromSuperview];
    
}

#pragma mark -  全屏切换方法
- (void)fullScreenAction:(UIButton*)sender{
    sender.selected = !sender.selected;
    self.configuration.isFullScreen = sender.selected;
    if (sender.selected) {
        [self switchScreen:ZZAVPlayerDeviceDirectionRight];
    }else{
        [self switchScreen:(ZZAVPlayerDeviceDirectionTop)];
    }
    
    if ([self.delegate respondsToSelector:@selector(zz_avPlayerView:deviceDirection:)]) {
           [self.delegate zz_avPlayerView:self deviceDirection:(ZZAVPlayerDeviceDirectionRight)];
       }
}

#pragma mark - 加载、开始、暂停播放时的UI
-(void)loadingPlayerOnView{
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    self.backgroundImageView.hidden = NO;
    self.pauseButton.hidden = YES;
    self.playOrPauseButton.selected = NO;
}
/// 开始播放时的UI
-(void)stratPlayerOnView{
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
    self.backgroundImageView.hidden = YES;
    self.pauseButton.hidden = YES;
    self.playOrPauseButton.selected = YES;
    [self setupTimer];
}
/// 暂停播放时的UI
-(void)pausePlayerOnView{
    
    if (self.configuration.gestureType == ZZAVPlayerGestureTypeProgress) {
        self.pauseButton.hidden = YES;
    }else{
        self.pauseButton.hidden = NO;
        [self showControlView];
    }
    
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
    self.backgroundImageView.hidden = YES;
    self.playOrPauseButton.selected = NO;
}
#pragma mark - 结束、停止、重复播放时的UI
-(void)endPlayerOnView{
    switch (self.configuration.avPlayerType) {
        case ZZAVPlayerPlayTypeOnce:{//仅一次
            [self stopPlayerOnView];
        }
            break;
        case ZZAVPlayerPlayTypeReplay:{//重复
            [self replayPlayerOnView];
        }
            break;
        case ZZAVPlayerPlayTypeOrder:{//顺序
            if (self.videoArray.count == 1 || self.videoArray.count == 0) {
                [self replayPlayerOnView];
            }else if (self.videoArray.count > 0) {
                self.videoIndex += 1;
                if (self.videoIndex >= self.videoArray.count) {
                    [self stopPlayerOnView];
                }else{
                    NSDictionary *dict = self.videoArray[self.videoIndex];
                    [self rePlayWithURL:dict[ZZKEY_VIDEOPATH] startTime:0];
                }
            }
        }
            break;
        case ZZAVPlayerPlayTypeRandom:{//随机
            if (self.videoArray.count == 1 || self.videoArray.count == 0) {
                [self replayPlayerOnView];
            }else if (self.videoArray.count > 0) {
                NSInteger index = arc4random() % self.videoArray.count;
                self.videoIndex = index;
                
                NSDictionary *dict = self.videoArray[self.videoIndex];
                [self rePlayWithURL:dict[ZZKEY_VIDEOPATH] startTime:0];
            }
        }
            break;
        case ZZAVPlayerPlayTypeCycle:{//循环
            if (self.videoArray.count == 1 || self.videoArray.count == 0) {
                [self replayPlayerOnView];
            }else if (self.videoArray.count > 0) {
                self.videoIndex += 1;
                self.videoIndex = self.videoIndex >= self.videoArray.count ? 0 : self.videoIndex;
                
                NSDictionary *dict = self.videoArray[self.videoIndex];
                [self rePlayWithURL:dict[ZZKEY_VIDEOPATH] startTime:0];
            }
        }
            break;
        default:
            break;
    }
}
/// 停止播放时的UI
-(void)stopPlayerOnView{
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
    self.backgroundImageView.hidden = NO;
    self.pauseButton.hidden = NO;
    self.playOrPauseButton.selected = NO;
    self.playScheduleSlider.value = 0.0;
    self.startTime = 0;
    [self showControlView];
}
/// 重复播放操作
- (void)replayPlayerOnView{
    self.loadingView.hidden = NO;
    [self.loadingView startAnimating];
    self.backgroundImageView.hidden = NO;
    self.pauseButton.hidden = YES;
    
    self.playScheduleSlider.value = 0;//指定初始值
    [self rePlayWithURL:self.configuration.avUrl startTime:0];
}
/// 播放出错时的UI
-(void)errorPlayerOnView{

}

#pragma mark -  横竖屏切换
-(void)switchScreen:(ZZAVPlayerDeviceDirection)direction{
    //MyLog(@"%f -- %f",ZZAVPlayer_SCREEN_W,ZZAVPlayer_SCREEN_H);
    if (direction == ZZAVPlayerDeviceDirectionLeft) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
            self.layer.frame = CGRectMake(0, 0, ZZAVPlayer_SCREEN_W, ZZAVPlayer_SCREEN_H);

            self.contentView.frame = self.bounds;
            self.playerLayer.frame = self.bounds;
            self.backgroundImageView.frame = self.bounds;
            
            self.fastView.center = CGPointMake(ZZAVPlayer_SCREEN_H*.5, ZZAVPlayer_SCREEN_W*.5);
            
            self.maskBtn.frame = self.bounds;
            self.playTypeView.frame = CGRectMake(ZZAVPlayer_SCREEN_H*.7, 0, ZZAVPlayer_SCREEN_H*.3, ZZAVPlayer_SCREEN_W);
            self.videoListView.frame = CGRectMake(ZZAVPlayer_SCREEN_H*.7, 0, ZZAVPlayer_SCREEN_H*.3, ZZAVPlayer_SCREEN_W);
            self.videoSettingView.frame = CGRectMake(ZZAVPlayer_SCREEN_H*.7, 0, ZZAVPlayer_SCREEN_H*.3, ZZAVPlayer_SCREEN_W);
            
            self.loadingView.center = CGPointMake(ZZAVPlayer_SCREEN_H*.5, ZZAVPlayer_SCREEN_W*.5);
            self.lightView.center = CGPointMake(ZZAVPlayer_SCREEN_H*.5, ZZAVPlayer_SCREEN_W*.5);
            self.volumeSlider.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
            self.pauseButton.center = CGPointMake(ZZAVPlayer_SCREEN_H*.5, ZZAVPlayer_SCREEN_W*.5);
            
            self.topView.frame = CGRectMake(0, 0, ZZAVPlayer_SCREEN_H, TopViewH);
            self.topView.backgroundColor = [UIColor colorWithHexString:@"00000033"];
            self.backButton.frame = self.backButtonFrame;
            self.topTitleLabel.frame = self.topTitleLabelFrame;
            
            self.bottomView.frame = CGRectMake(0, ZZAVPlayer_SCREEN_W-TopViewH, ZZAVPlayer_SCREEN_H, TopViewH);
            self.bottomView.backgroundColor = [UIColor colorWithHexString:@"00000033"];
            
            CGFloat bottomCenterY = TopViewH*.5;
            self.playOrPauseButton.center = CGPointMake(30, bottomCenterY);
            self.leftTimeLabel.center = CGPointMake(80, bottomCenterY);
            self.leftTimeLabel.textAlignment = NSTextAlignmentCenter;
            self.fullScreenButton.center = CGPointMake(ZZAVPlayer_SCREEN_H - CGRectGetWidth(self.fullScreenButton.frame)*.5, bottomCenterY);
            
            self.definitionButton.hidden = NO;
            self.definitionButton.center = CGPointMake(CGRectGetMinX(self.fullScreenButton.frame)-CGRectGetWidth(self.definitionButton.frame)*.5, bottomCenterY);
            self.downloadButton.hidden = NO;
            self.downloadButton.center = CGPointMake(CGRectGetMinX(self.definitionButton.frame)-CGRectGetWidth(self.downloadButton.frame)*.5-10, bottomCenterY);
            self.collectButton.hidden = NO;
            self.collectButton.center = CGPointMake(CGRectGetMinX(self.downloadButton.frame)-CGRectGetWidth(self.collectButton.frame)*.5-10, bottomCenterY);
        
            self.rightTimeLabel.center = CGPointMake(CGRectGetMinX(self.collectButton.frame)-CGRectGetWidth(self.rightTimeLabel.frame)*.5-10, bottomCenterY);
            self.rightTimeLabel.textAlignment = NSTextAlignmentCenter;
            CGFloat loadingWidth = CGRectGetMinX(self.rightTimeLabel.frame) - CGRectGetMaxX(self.leftTimeLabel.frame) - 10;
            self.loadingProgress.frame = CGRectMake(CGRectGetMaxX(self.leftTimeLabel.frame)+5, 0, loadingWidth, 2);
            self.loadingProgress.center = CGPointMake(self.loadingProgress.center.x, bottomCenterY);
            self.playScheduleSlider.frame = CGRectMake(0, 0, CGRectGetWidth(self.loadingProgress.frame)+6, 20);
            self.playScheduleSlider.center = self.loadingProgress.center;
        } completion:^(BOOL finished) {
            
        }];
    }
    else if (direction == ZZAVPlayerDeviceDirectionRight){
        [UIView animateWithDuration:0.5 animations:^{
            self.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
            self.layer.frame = CGRectMake(0, 0, ZZAVPlayer_SCREEN_W, ZZAVPlayer_SCREEN_H);
            self.contentView.frame = self.bounds;
            self.playerLayer.frame = self.bounds;
            self.backgroundImageView.frame = self.bounds;
            
            self.fastView.center = CGPointMake(ZZAVPlayer_SCREEN_H*.5, ZZAVPlayer_SCREEN_W*.5);
            self.maskBtn.frame = self.bounds;
            self.playTypeView.frame = CGRectMake(ZZAVPlayer_SCREEN_H*.7, 0, ZZAVPlayer_SCREEN_H*.3, ZZAVPlayer_SCREEN_W);
            self.videoListView.frame = CGRectMake(ZZAVPlayer_SCREEN_H*.7, 0, ZZAVPlayer_SCREEN_H*.3, ZZAVPlayer_SCREEN_W);
            self.videoSettingView.frame = CGRectMake(ZZAVPlayer_SCREEN_H*.7, 0, ZZAVPlayer_SCREEN_H*.3, ZZAVPlayer_SCREEN_W);
            
            self.loadingView.center = CGPointMake(ZZAVPlayer_SCREEN_H*.5, ZZAVPlayer_SCREEN_W*.5);
            self.lightView.center = CGPointMake(ZZAVPlayer_SCREEN_H*.5, ZZAVPlayer_SCREEN_W*.5);
            self.volumeSlider.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
            self.pauseButton.center = CGPointMake(ZZAVPlayer_SCREEN_H*.5, ZZAVPlayer_SCREEN_W*.5);
            
            self.topView.frame = CGRectMake(0, 0, ZZAVPlayer_SCREEN_H, TopViewH);
            self.topView.backgroundColor = [UIColor colorWithHexString:@"00000033"];
            self.backButton.frame = self.backButtonFrame;
            self.topTitleLabel.frame = self.topTitleLabelFrame;
            
            self.bottomView.frame = CGRectMake(0, ZZAVPlayer_SCREEN_W-TopViewH, ZZAVPlayer_SCREEN_H, TopViewH);
            self.bottomView.backgroundColor = [UIColor colorWithHexString:@"00000033"];
            
            CGFloat bottomCenterY = TopViewH*.5;
            self.playOrPauseButton.center = CGPointMake(30, bottomCenterY);
            self.leftTimeLabel.center = CGPointMake(70, bottomCenterY);
            self.leftTimeLabel.textAlignment = NSTextAlignmentCenter;
            self.fullScreenButton.center = CGPointMake(ZZAVPlayer_SCREEN_H - CGRectGetWidth(self.fullScreenButton.frame)*.5, bottomCenterY);
            
            self.definitionButton.hidden = NO;
            self.definitionButton.center = CGPointMake(CGRectGetMinX(self.fullScreenButton.frame)-CGRectGetWidth(self.definitionButton.frame)*.5, bottomCenterY);
            self.downloadButton.hidden = NO;
            self.downloadButton.center = CGPointMake(CGRectGetMinX(self.definitionButton.frame)-CGRectGetWidth(self.downloadButton.frame)*.5-10, bottomCenterY);
            self.collectButton.hidden = NO;
            self.collectButton.center = CGPointMake(CGRectGetMinX(self.downloadButton.frame)-CGRectGetWidth(self.collectButton.frame)*.5-10, bottomCenterY);
            
            self.rightTimeLabel.center = CGPointMake(CGRectGetMinX(self.collectButton.frame)-CGRectGetWidth(self.rightTimeLabel.frame)*.5-10, bottomCenterY);
            self.rightTimeLabel.textAlignment = NSTextAlignmentCenter;
            CGFloat loadingWidth = CGRectGetMinX(self.rightTimeLabel.frame) - CGRectGetMaxX(self.leftTimeLabel.frame) - 10;
            self.loadingProgress.frame = CGRectMake(CGRectGetMaxX(self.leftTimeLabel.frame)+5, 0, loadingWidth, 2);
            self.loadingProgress.center = CGPointMake(self.loadingProgress.center.x, bottomCenterY);
            self.playScheduleSlider.frame = CGRectMake(0, 0, CGRectGetWidth(self.loadingProgress.frame)+6, 20);
            self.playScheduleSlider.center = self.loadingProgress.center;
        }];
    }
    else if (direction == ZZAVPlayerDeviceDirectionTop || direction == ZZAVPlayerDeviceDirectionBottom){
        [UIView animateWithDuration:0.3 animations:^{
            self.layer.transform = CATransform3DIdentity;
            self.layer.frame = self.superViewFrame;
            self.playerLayer.frame = self.bounds;
            self.backgroundImageView.frame = self.backImageViewFrame;
            
            self.volumeSlider.layer.transform = CATransform3DIdentity;
            
            self.contentView.frame = self.contentViewFrame;
            self.topView.backgroundColor = UIColor.clearColor;
            self.topView.frame = self.topViewFrame;
            self.bottomView.backgroundColor = UIColor.clearColor;
            self.bottomView.frame = self.bottomViewFrame;
            self.topTitleLabel.frame = self.topTitleLabelFrame;
            self.backButton.frame = self.backButtonFrame;
            self.playOrPauseButton.frame = self.playOrPauseButtonFrame;
            self.pauseButton.frame = self.pauseButtonFrame;
            self.loadingProgress.frame = self.loadingProgressFrame;
            self.playScheduleSlider.frame = self.playScheduleSliderFrame;
            self.leftTimeLabel.frame = self.leftTimeLabelFrame;
            self.leftTimeLabel.textAlignment = NSTextAlignmentLeft;
            self.rightTimeLabel.frame = self.rightTimeLabelFrame;
            self.rightTimeLabel.textAlignment = NSTextAlignmentRight;
            self.fullScreenButton.frame = self.fullScreenButtonFrame;
            self.fastView.frame = self.fastViewFrame;
            self.loadingView.frame = self.loadingViewFrame;
            self.lightView.frame = self.lightViewFrame;
            self.definitionButton.hidden = YES;
            self.downloadButton.hidden = YES;
            self.collectButton.hidden = YES;
            self.lightView.hidden = YES;
            
            self.maskBtn.hidden = YES;
            self.playTypeView.hidden = YES;
            self.videoListView.hidden = YES;
            self.videoSettingView.hidden = YES;
        }];
    }
}
#pragma mark - 手势事件处理
// 单击手势方法 显示/隐藏
- (void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [UIView animateWithDuration:0.3 animations:^{
       if (self.topView.alpha == 1.0) {
           [self hiddenControlView];
       }else{
           [self showControlView];
       }
    }];
}
// 双击手势方法 暂停/播放
- (void)handleDoubleTap:(UITapGestureRecognizer *)doubleTap{
    [self playOrPauseAction:self.playOrPauseButton];
    [self showControlView];
}

#pragma mark - 旋转屏幕
- (void)onDeviceOrientationChange{
    //判断是否开启重力感应
    if (self.configuration.isOpenGravitySensing == NO) {
        return;
    }
    //设备方向
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    ZZAVPlayerDeviceDirection direction = ZZAVPlayerDeviceDirectionCustom;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:{
            direction = ZZAVPlayerDeviceDirectionTop;
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:{
            direction = ZZAVPlayerDeviceDirectionBottom;
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            direction = ZZAVPlayerDeviceDirectionLeft;
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            direction = ZZAVPlayerDeviceDirectionRight;
        }
            break;
        default:
            break;
    }
    
    if (direction == ZZAVPlayerDeviceDirectionCustom) return;
    
    //是否全屏
    if ((direction == ZZAVPlayerDeviceDirectionLeft) || (direction == ZZAVPlayerDeviceDirectionRight)) {
        self.configuration.isFullScreen = YES;
    }else{
        self.configuration.isFullScreen = NO;
    }
    //切换全半屏
    if ([self.delegate respondsToSelector:@selector(zz_avPlayerView:deviceDirection:)]) {
        [self.delegate zz_avPlayerView:self deviceDirection:direction];
    }
    // 旋转屏幕
    [self switchScreen:(direction)];
}

#pragma mark - 开始播放
- (void)startPlayWithURL:(NSURL *)avUrl startTime:(CGFloat)startTime{
    self.configuration.avUrl = avUrl;
    self.startTime = startTime;
    
    self.playerLayer = [self.avPlayer zz_playerGetPlayerLayerWithURL:avUrl];
    self.playerLayer.frame = self.bounds;
    [self.contentView.layer addSublayer:self.playerLayer];
    
    [self beforePlayWithURL:avUrl time:startTime];
}
/// 重播
- (void)rePlayWithURL:(NSURL *)avUrl startTime:(CGFloat)startTime{
    self.configuration.avUrl = avUrl;
    self.startTime = startTime;
    [self.avPlayer zz_playerReplayWithURL:avUrl];
    [self beforePlayWithURL:avUrl time:startTime];
}
#pragma mark - 播放前准备
-(void)beforePlayWithURL:(NSURL *)avUrl time:(CGFloat)time{
    if (self.configuration.isHaveFristImage) {
        self.configuration.avPlayerFirstImage = self.avPlayer.fristImage;
        self.backgroundImageView.image = self.configuration.avPlayerFirstImage;
    }
    if (time > 0) {
        //播放
        [self.avPlayer zz_playerSeekToTime:time];
    }
    self.leftTimeLabel.text = [ZZAVPlayerTool zz_avPlayerConvertTime:time];
    self.rightTimeLabel.text = [ZZAVPlayerTool zz_avPlayerConvertTime:self.avPlayer.totalTime];
    self.playScheduleSlider.maximumValue = self.avPlayer.totalTime;
    self.playScheduleSlider.value = time;
    
    self.fastView.isMoveGestureFast = NO;
    self.configuration.isGestureMoved = NO;
    self.configuration.totalTime = self.avPlayer.totalTime;
}

-(void)stopPlay{
    [self.avPlayer zz_playerStop];
}
#pragma mark - Touches 触摸手势
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //不允许多个手势同时操作
    UITouch *touch = (UITouch *)touches.anyObject;
    if (touches.count > 1 || touch.tapCount > 1 || event.allTouches.count > 1) {
        return;
    }
    
    //手指点击的不是本视图, 不做响应
    if (![[(UITouch *)touches.anyObject view] isEqual:self.contentView] && ![[(UITouch *)touches.anyObject view] isEqual:self]) {
        return;
    }
    [super touchesBegan:touches withEvent:event];
    
    //是否移动
    self.configuration.isGestureMoved = NO;
    //开始位置
    self.configuration.touchBeginPoint = [touches.anyObject locationInView:self];
    //重置手势
    self.configuration.gestureType = ZZAVPlayerGestureTypeNone;
    //开始值
    self.fastView.touchBeginValue = self.playScheduleSlider.value;
    //亮度
    self.lightView.isChangeLightValue = NO;
    //声音
    self.configuration.touchBeginVoiceValue = self.volumeSlider.value;
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //不允许多个手势同时操作
    UITouch *touch = (UITouch *)touches.anyObject;
    if (touches.count > 1 || touch.tapCount > 1 || event.allTouches.count > 1) {
        return;
    }
    
    //手指点击的不是本视图, 不做响应
    if (![[(UITouch *)touches.anyObject view] isEqual:self.contentView] && ![[(UITouch *)touches.anyObject view] isEqual:self]) {
        return;
    }
    [super touchesBegan:touches withEvent:event];
    
    //移动的距离过于小,不做响应
    CGPoint tempPoint = [(UITouch *)touches.anyObject locationInView:self];
    if (fabs(tempPoint.x - self.configuration.touchBeginPoint.x) < self.configuration.gestureSliderMinX &&
        fabs(tempPoint.y - self.configuration.touchBeginPoint.y) < self.configuration.gestureSliderMinX) {
        return;
    }
    
    //没有手势时才去判断手势
    if (self.configuration.gestureType == ZZAVPlayerGestureTypeNone) {
        
        //求出滑动角度的tan值，判断出使什么控制手势
        float tan = fabs(tempPoint.y - self.configuration.touchBeginPoint.y) / fabs(tempPoint.x - self.configuration.touchBeginPoint.x);
        //开平方根
        if (tan < 1 / sqrt(3)) {
            //当滑动角度小于30度的时候, 快进手势
            self.configuration.gestureType = ZZAVPlayerGestureTypeProgress;
            [self.avPlayer zz_playerPause];
            //是否允许快进
            if (!self.configuration.isPlayProgressGesture) {
                return;
            }
        }else if (tan > sqrt(3)){
            //当滑动角度大于60度的时候, 声音和亮度

            if (self.configuration.touchBeginPoint.x < self.bounds.size.width*0.5) {
                //左边 亮度
                self.configuration.gestureType = ZZAVPlayerGestureTypeLight;
                self.lightView.isChangeLightValue = YES;
            }else{
                //右边 声音
                self.configuration.gestureType = ZZAVPlayerGestureTypeVoice;
            }
            //是否允许调节
            if (!self.configuration.isEnableVolumeGesture) {
                return;
            }
        }else{
            //其他情况
           self.configuration.gestureType = ZZAVPlayerGestureTypeNone;
        }
    }

    //处理手势事件
    if (self.configuration.gestureType == ZZAVPlayerGestureTypeProgress) {
        //快进快退
        CGFloat value = [self moveFastViewWithTempPoint:tempPoint];
        self.fastView.isMoveGestureFast = YES;
        [self.fastView updateFastValue:value TotalTime:self.configuration.totalTime];
        
        self.leftTimeLabel.text = [ZZAVPlayerTool zz_avPlayerConvertTime:value];
        [self.playScheduleSlider setValue:value animated:YES];
    }else if (self.configuration.gestureType == ZZAVPlayerGestureTypeLight) {
        //全屏才能调节亮度
        if (self.configuration.isFullScreen) {
            //根据 触摸开始时的亮度 和 触摸开始时的点
            //来计算现在的亮度
            CGFloat value = self.lightView.touchBeginLightValue - ((tempPoint.y - self.configuration.touchBeginPoint.y)/self.bounds.size.height);
            [self.lightView updateLightValue:value];
        }
    }else if (self.configuration.gestureType == ZZAVPlayerGestureTypeVoice) {
        //全屏才能调节声音
        if (self.configuration.isFullScreen) {
            //根据 触摸开始时的音量 和 触摸开始时的点
            //去计算现在滑动到的音量
            CGFloat value = self.configuration.touchBeginVoiceValue - ((tempPoint.y - self.configuration.touchBeginPoint.y)/self.bounds.size.height);
            //判断控制一下, 不能超出 0~1
            value = MAX(0, value);
            value = MIN(value, 1);
            self.volumeSlider.value = value;
        }
    }
    
    // 有移动距离
    self.configuration.isGestureMoved = YES;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.fastView.isMoveGestureFast = NO;
    self.lightView.isChangeLightValue = NO;
    
    if (self.configuration.isGestureMoved &&
        self.configuration.isPlayProgressGesture &&
        self.configuration.gestureType == ZZAVPlayerGestureTypeProgress) {
        //如果是快进就跳到相应的视频进度
        self.configuration.gestureType = ZZAVPlayerGestureTypeNone;
        
        CGPoint tempPoint = [touches.anyObject locationInView:self];
        CGFloat second = [self moveFastViewWithTempPoint:tempPoint];
        self.playOrPauseButton.selected = YES;
        self.startTime = second;
        [self.playScheduleSlider setValue:second animated:NO];
        [self.avPlayer zz_playerSeekToTime:second];
        
    }
}
// 用来控制移动过程中计算手指划过的时间
- (CGFloat)moveFastViewWithTempPoint:(CGPoint)tempPoint{
    //整个屏幕代表的时间
    CGFloat tempValue = self.fastView.touchBeginValue + self.configuration.totalTime * ((tempPoint.x - self.configuration.touchBeginPoint.x) / (self.frame.size.width));
    tempValue = MAX(0.0, tempValue);
    tempValue = MIN(tempValue, self.configuration.totalTime);
    return tempValue;
}
#pragma mark - ZZAVPlayerDelegate
-(void)zz_player:(ZZAVPlayer *)avPlayer avPlayerStatus:(ZZAVPlayerStatus)avPlayerStatus avPlayerErrorCode:(ZZAVPlayerErrorCode)avPlayerErrorCode{

    //NSLog(@"当前播放状态：%ld",(long)avPlayerStatus);
    
    self.configuration.avPlayerStatus = avPlayerStatus;
    switch (avPlayerStatus) {
        case ZZAVPlayerStatusLoading:{
                [self loadingPlayerOnView];
        }
            break;
        case ZZAVPlayerStatusPlaying:{
                [self stratPlayerOnView];
            }
            break;
        case ZZAVPlayerStatusPause:{
                [self pausePlayerOnView];
            }
            break;
        case ZZAVPlayerStatusStopped:{
                [self stopPlayerOnView];
            }
            break;
        case ZZAVPlayerStatusEnd:{
            [self endPlayerOnView];
        }
            break;
        case ZZAVPlayerStatusError:{
            [self errorPlayerOnView];
        }
            break;
        default:
            break;
    }
}

-(void)zz_player:(ZZAVPlayer *)avPlayer
        progress:(CGFloat)progress
     currentTime:(CGFloat)currentTime
    durationTime:(CGFloat)durationTime{
    
    if (self.fastView.isMoveGestureFast == NO) {
        self.leftTimeLabel.text = [ZZAVPlayerTool zz_avPlayerConvertTime:currentTime];
        self.playScheduleSlider.value = currentTime;
        //NSLog(@"当前播放进度%f",progress);
    }
}
#pragma mark - ZZAVPlayTypeView Delegate
-(void)didSelectWithTypeView:(ZZAVPlayTypeView *)popView type:(NSInteger)type{
    [self maskBtnClick:self.maskBtn];
    
    switch (type) {
        case 0:{
            self.configuration.avPlayerType = ZZAVPlayerPlayTypeOnce;
            [self.downloadButton setTitle:@"单次" forState:(UIControlStateNormal)];
        }
            break;
        case 1:{
            self.configuration.avPlayerType = ZZAVPlayerPlayTypeReplay;
            [self.downloadButton setTitle:@"重复" forState:(UIControlStateNormal)];
        }
            break;
        case 2:{
            self.configuration.avPlayerType = ZZAVPlayerPlayTypeOrder;
            [self.downloadButton setTitle:@"顺序" forState:(UIControlStateNormal)];
        }
            break;
        case 3:{
            self.configuration.avPlayerType = ZZAVPlayerPlayTypeRandom;
            [self.downloadButton setTitle:@"随机" forState:(UIControlStateNormal)];
        }
            break;
        case 4:{
            self.configuration.avPlayerType = ZZAVPlayerPlayTypeCycle;
            [self.downloadButton setTitle:@"循环" forState:(UIControlStateNormal)];
        }
            break;
        default:
            break;
    }

}
#pragma mark - ZZAVPlayerVideoListView Delegate
-(void)didSelectWithVideoListView:(ZZAVPlayerVideoListView *)popView type:(NSInteger)type{
    [self maskBtnClick:self.maskBtn];
    
    self.videoIndex = type;
    NSDictionary *dict = self.videoArray[self.videoIndex];
    [self rePlayWithURL:dict[ZZKEY_VIDEOPATH] startTime:0];
}
#pragma mark - Getters and Setters
- (ZZAVPlayer *)avPlayer{
    if (!_avPlayer) {
        _avPlayer = [ZZAVPlayer sharedAVPlayer];
        _avPlayer.isNowPlay = self.configuration.isNowPlay;
        _avPlayer.isStopWhenAppEnterBackground = NO;
        _avPlayer.delegate = self;
    }
    return _avPlayer;
}
- (UIView*)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:self.bounds];
        _contentView.backgroundColor = UIColor.blackColor;
    }
    return _contentView;
}
- (UIImageView*)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _backgroundImageView;
}
- (ZZAVPlayerFastView*)fastView{
    if (!_fastView) {
        _fastView = [[ZZAVPlayerFastView alloc]initWithFrame:CGRectMake(0, 0, 160, 75)];
        _fastView.center = self.contentView.center;
        _fastView.isMoveGestureFast = NO;
        [_fastView setProgressTintColor:UIColor.orangeColor];
    }
    return _fastView;
}

- (UIButton *)maskBtn{
    if (!_maskBtn) {
        _maskBtn = [[UIButton alloc] init];
        _maskBtn.backgroundColor = [UIColor blackColor];
        _maskBtn.alpha = 0.15;
        _maskBtn.frame = self.bounds;
        [_maskBtn addTarget:self action:@selector(maskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskBtn;
}
- (ZZAVPlayTypeView *)playTypeView{
    if (!_playTypeView) {
        _playTypeView = [[ZZAVPlayTypeView alloc] initWithFrame:CGRectMake(ZZAVPlayer_SCREEN_H*.7, 0, ZZAVPlayer_SCREEN_H*.3, ZZAVPlayer_SCREEN_W)];
        _playTypeView.delegate = self;
        _playTypeView.hidden = YES;
    }
    return _playTypeView;
}
- (ZZAVPlayerVideoListView *)videoListView{
    if (!_videoListView) {
        _videoListView = [[ZZAVPlayerVideoListView alloc] initWithFrame:CGRectMake(ZZAVPlayer_SCREEN_H*.7, 0, ZZAVPlayer_SCREEN_H*.3, ZZAVPlayer_SCREEN_W)];
        _videoListView.delegate = self;
        _videoListView.dataArr = self.videoArray;
        _videoListView.hidden = YES;
    }
    return _videoListView;
}
- (ZZAVPlayerSettingView *)videoSettingView{
    if (!_videoSettingView) {
        _videoSettingView = [[ZZAVPlayerSettingView alloc] initWithFrame:CGRectMake(ZZAVPlayer_SCREEN_H*.7, 0, ZZAVPlayer_SCREEN_H*.3, ZZAVPlayer_SCREEN_W)];
        _videoSettingView.delegate = self;
        _videoSettingView.hidden = YES;
    }
    return _videoSettingView;
}

- (UISlider*)volumeSlider{
    if (!_volumeSlider) {
        /// 声音滑块
        MPVolumeView *volumeView = [[MPVolumeView alloc]init];
        volumeView.transform = CGAffineTransformMakeRotation(M_PI/2);//旋转一下即可 -_-!!
        for (UIControl *view in volumeView.subviews) {
            if ([view.superclass isSubclassOfClass:[UISlider class]]) {
                _volumeSlider = (UISlider*)view;
            }
        }
    }
    return _volumeSlider;
}
- (ZZAVPlayerLightView*)lightView{
    if (!_lightView) {
        _lightView = [[ZZAVPlayerLightView alloc] initWithFrame:CGRectMake(self.frame.size.width - 30 - 20, TopViewH + 20, 30, self.frame.size.width - 100 - 40)];
        _lightView.center = self.contentView.center;
        _lightView.isChangeLightValue = NO;
        CGFloat value = [UIScreen mainScreen].brightness;
        [_lightView updateLightValue:value];
    }
    return _lightView;
}
- (UIActivityIndicatorView*)loadingView{
    if (!_loadingView) {
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _loadingView.center = self.contentView.center;
//        [_loadingView startAnimating];
    }
    return _loadingView;
}
- (UIImageView*)topView{
    if (!_topView) {
        _topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, ZZAVPlayer_STATUS_HEIGHT, self.frame.size.width, TopViewH)];
        _topView.image = [UIImage getImageWithNamed:@"zzMakePlayer_top_shadow"];
        _topView.userInteractionEnabled = YES;
    }
    return _topView;
}
- (UIImageView*)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - TopViewH - ZZAVPlayer_Safe_HEIGHT, self.frame.size.width, TopViewH + ZZAVPlayer_Safe_HEIGHT)];
        _bottomView.image = [UIImage getImageWithNamed:@"zzMakePlayer_bottom_shadow"];
        _bottomView.userInteractionEnabled = YES;
    }
    return _bottomView;
}

- (UIButton*)playOrPauseButton{
    if (!_playOrPauseButton) {
        _playOrPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playOrPauseButton.frame = CGRectMake(0, 0, TopViewH, TopViewH);
        [_playOrPauseButton addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_playOrPauseButton setImage:[UIImage getImageWithNamed:@"zzMakePlayer_播放-全屏"] forState:UIControlStateNormal];
        [_playOrPauseButton setImage:[UIImage getImageWithNamed:@"zzMakePlayer_播放-全屏"] forState:UIControlStateDisabled];
        [_playOrPauseButton setImage:[UIImage getImageWithNamed:@"zzMakePlayer_暂停-全屏"] forState:UIControlStateSelected];
        _playOrPauseButton.selected = self.configuration.isNowPlay;//默认状态，即默认自动播放
    }
    return _playOrPauseButton;
}
- (UIButton*)pauseButton{
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pauseButton.frame = CGRectMake(0, 0, TopViewH, TopViewH);
        _pauseButton.center = self.center;
        [_pauseButton addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
        [_pauseButton setBackgroundImage:[UIImage getImageWithNamed:@"zzMakePlayer_播放-全屏"] forState:UIControlStateNormal];
        self.pauseButton.hidden = YES;
    }
    return _pauseButton;
}
- (ZZAVPlayerSlider*)playScheduleSlider{
    if (!_playScheduleSlider) {
        _playScheduleSlider = [[ZZAVPlayerSlider alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.loadingProgress.frame)+6, 20)];
        _playScheduleSlider.center = self.loadingProgress.center;
        _playScheduleSlider.backgroundColor = [UIColor clearColor];
        _playScheduleSlider.minimumValue = 0.0;
        [_playScheduleSlider setThumbImage:[UIImage getImageWithNamed:@"zzMakePlayer_dot"] forState:UIControlStateNormal];
        //进度条
        _playScheduleSlider.minimumTrackTintColor = UIColor.orangeColor;
        //背景条
        _playScheduleSlider.maximumTrackTintColor = [UIColor clearColor];
        _playScheduleSlider.value = 0.0;//指定初始值
        //进度条的拖拽事件
        [_playScheduleSlider addTarget:self action:@selector(sliderValueChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
        //给进度条添加单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureForSlider:)];
        tap.delegate = self;
        [_playScheduleSlider addGestureRecognizer:tap];
    }
    return _playScheduleSlider;
}
- (UIProgressView*)loadingProgress{
    if (!_loadingProgress) {
        _loadingProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _loadingProgress.frame = CGRectMake(CGRectGetMaxX(self.playOrPauseButton.frame), TopViewH/2-1, self.bottomView.frame.size.width- 2*TopViewH, 2);
        _loadingProgress.trackTintColor = UIColor.lightGrayColor;
        _loadingProgress.progressTintColor = [self.configuration.mainColor colorWithAlphaComponent:0.2];
        [_loadingProgress setProgress:0.0 animated:NO];
    }
    return _loadingProgress;
}
- (UIButton*)fullScreenButton{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullScreenButton.frame = CGRectMake(self.bottomView.frame.size.width-TopViewH, 0, TopViewH, TopViewH);
        _fullScreenButton.showsTouchWhenHighlighted = NO;
        [_fullScreenButton addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
        [_fullScreenButton setImage:[UIImage getImageWithNamed:@"zzMakePlayer_全屏"] forState:UIControlStateNormal];
        [_fullScreenButton setImage:[UIImage getImageWithNamed:@"zzMakePlayer_全屏"] forState:UIControlStateSelected];
    }
    return _fullScreenButton;
}
- (UILabel*)leftTimeLabel{
    if (!_leftTimeLabel) {
        _leftTimeLabel = [UILabel new];
        _leftTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.playOrPauseButton.frame), TopViewH-20, TopViewH, 20);
        _leftTimeLabel.textAlignment = NSTextAlignmentLeft;
        _leftTimeLabel.textColor = [UIColor whiteColor];
        _leftTimeLabel.font = [UIFont systemFontOfSize:11];
        _leftTimeLabel.text = [ZZAVPlayerTool zz_avPlayerConvertTime:0.0];//设置默认值
    }
    return _leftTimeLabel;
}
- (UILabel*)rightTimeLabel{
    if (!_rightTimeLabel) {
        _rightTimeLabel = [UILabel new];
        _rightTimeLabel.frame = CGRectMake(self.bottomView.frame.size.width- 2*TopViewH, TopViewH-20, TopViewH, 20);
        _rightTimeLabel.textAlignment = NSTextAlignmentRight;
        _rightTimeLabel.textColor = [UIColor whiteColor];
        _rightTimeLabel.font = [UIFont systemFontOfSize:11];
        _rightTimeLabel.text = [ZZAVPlayerTool zz_avPlayerConvertTime:10.0];//设置默认值
    }
    return _rightTimeLabel;
}
- (UIButton*)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(5, 5, 30, 30);
        [_backButton setImage:[UIImage getImageWithNamed:@"zzMakePlayer_返回"] forState:(UIControlStateNormal)];
        [_backButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UILabel*)topTitleLabel{
    if (!_topTitleLabel) {
        _topTitleLabel = [UILabel new];
        _topTitleLabel.frame = CGRectMake(35, 0, self.topView.frame.size.width-90, 30);
        _topTitleLabel.center = CGPointMake(_topTitleLabel.center.x, _backButton.center.y);
        _topTitleLabel.textColor = [UIColor whiteColor];
        _topTitleLabel.numberOfLines = 1;
        _topTitleLabel.font = [UIFont boldSystemFontOfSize:(16)];
        _topTitleLabel.text = self.configuration.backString;
    }
    return _topTitleLabel;
}
- (UIButton*)collectButton{
    if (!_collectButton) {
        _collectButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _collectButton.frame = CGRectMake(0, 0, TopViewH, 23);
        _collectButton.tag = 520;
        [_collectButton setTitle:@"列表" forState:(UIControlStateNormal)];
        [_collectButton setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
        _collectButton.backgroundColor = UIColor.whiteColor;
        _collectButton.titleLabel.font = [UIFont boldSystemFontOfSize:(12)];
        _collectButton.layer.cornerRadius = 2;
        _collectButton.hidden = YES;
        [_collectButton addTarget:self action:@selector(bottomButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.bottomView addSubview:_collectButton];
    }
    return _collectButton;
}
- (UIButton*)downloadButton{
    if (!_downloadButton) {
        _downloadButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _downloadButton.frame = CGRectMake(0, 0, TopViewH, 23);
        _downloadButton.tag = 521;
        [_downloadButton setTitle:@"顺序" forState:(UIControlStateNormal)];
        [_downloadButton setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
        _downloadButton.backgroundColor = UIColor.whiteColor;
        _downloadButton.titleLabel.font = [UIFont boldSystemFontOfSize:(12)];
        _downloadButton.layer.cornerRadius = 2;
        _downloadButton.hidden = YES;
        [_downloadButton addTarget:self action:@selector(bottomButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.bottomView addSubview:_downloadButton];
    }
    return _downloadButton;
}
- (UIButton*)definitionButton{
    if (!_definitionButton) {
        _definitionButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //2020.1.7 隐藏 definitionButton 宽度为0
        //_definitionButton.frame = CGRectMake(0, 0, TopViewH, 23);
        _definitionButton.frame = CGRectMake(0, 0, 0, 23);
        _definitionButton.tag = 522;
        [_definitionButton setTitle:@"设置" forState:(UIControlStateNormal)];
        [_definitionButton setTitleColor:UIColor.blackColor forState:(UIControlStateNormal)];
        _definitionButton.backgroundColor = UIColor.whiteColor;
        _definitionButton.titleLabel.font = [UIFont boldSystemFontOfSize:(12)];
        _definitionButton.layer.cornerRadius = 2;
        _definitionButton.hidden = YES;
        [_definitionButton addTarget:self action:@selector(bottomButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.bottomView addSubview:_definitionButton];
    }
    return _definitionButton;
}
@end

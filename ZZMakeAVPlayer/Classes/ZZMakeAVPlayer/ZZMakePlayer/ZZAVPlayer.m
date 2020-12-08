//
//  ZZAVPlayer.m

//  Created by  on 2019/11/20.
//  Copyright © 2019 . All rights reserved.
//

#import "ZZAVPlayer.h"
#import "ZZAVPlayerURLSession.h"

#import "UIImage+ZZAVPlayerImage.h"
#import "ZZAVPlayerMacro.h"

static UIBackgroundTaskIdentifier _bgTaskId;

@interface ZZAVPlayer ()
/** 播放状态 */
@property (nonatomic,assign) ZZAVPlayerStatus avPlayerState;
/** 错误的code */
@property (nonatomic,assign) ZZAVPlayerErrorCode avPlayerErrorCode;
/** 当前播放时间 */
@property (nonatomic,assign) CGFloat currentTime;
/** 当前播放进度 0~1 */
@property (nonatomic,assign) CGFloat currentProgress;
/** 缓冲进度 0~1 */
@property (nonatomic,assign) CGFloat loadedProgress;
/** 是否被用户暂停 */
@property (nonatomic,assign) BOOL isUserPause;
/** 是否缓存完成 */
@property (nonatomic,assign) BOOL isLoadComplete;
/** 监听播放进度 */
@property (nonatomic,strong)id avPlayerObserver;

/** 视频总时间 */
@property (nonatomic,readwrite,assign) CGFloat totalTime;
/** 视频第一帧图片 */
@property (nonatomic,readwrite,strong) UIImage *fristImage;
/** AVPlayer */
@property (nonatomic,readwrite,strong) AVPlayer *avPlayer;
/** AVPlayerLayer */
@property (nonatomic,readwrite,strong) AVPlayerLayer *avPlayerLayer;
/** AVPlayerItem */
@property (nonatomic, strong)AVPlayerItem *avPlayerItem;
/** 是否为本地资源 */
@property (nonatomic,readwrite,assign) BOOL isLocalResource;

@property (nonatomic,readwrite,strong)NSURL *avUrl;

@end

@implementation ZZAVPlayer
#pragma mark - init methods
+ (instancetype)sharedAVPlayer {
    static ZZAVPlayer *_playerInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _playerInstance = [[ZZAVPlayer alloc] init];
    });
    return _playerInstance;
}
- (instancetype)init{
    if (self == [super init]) {
        [self config];
    }
    return self;
}
- (void)config{
    _totalTime = 0.0;
    _currentTime = 0.0;
    _currentProgress = 0.0;
    _loadedProgress = 0.0;
    
    _avPlayerState = ZZAVPlayerStatusStopped;
    _avPlayerErrorCode = ZZAVPlayerErrorCodeNoError;
    
    _isStopWhenAppEnterBackground = NO;
    _isUserPause = YES;
    _isLoadComplete = NO;
    _isLocalResource = NO;
    _isNowPlay = YES;
}

#pragma mark - Private methods
-(void)setNotificationAndKVO{
    
    //媒体加载状态
    [self.avPlayerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
    //数据缓冲状态
    [self.avPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:(NSKeyValueObservingOptionNew) context:nil];
    //缓存状态
    [self.avPlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:(NSKeyValueObservingOptionNew) context:nil];
    //播放继续
    [self.avPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:(NSKeyValueObservingOptionNew) context:nil];
    
    // 播放进度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemPlaybackStalled:) name:AVPlayerItemPlaybackStalledNotification object:self.avPlayerItem];
    // 添加视频播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayerItem];
    
    // 后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // 已经进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
}
-(void)removeNotificationAndKVO{
    
    if (!self.avPlayerItem) return;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.avPlayerItem removeObserver:self forKeyPath:@"status"];
    [self.avPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.avPlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.avPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    
    [self.avPlayer removeTimeObserver:self.avPlayerObserver];
    self.avPlayerObserver = nil;
    self.avPlayerItem = nil;
    
}
/// 注销
-(void)releaseAVPlayer{
    [self removeNotificationAndKVO];
    self.avPlayer = nil;
}

#pragma mark - public methods
#pragma mark -  获取AVPlayerLayer
- (AVPlayerLayer *)zz_playerGetPlayerLayerWithURL:(NSURL *)avUrl{
    self.avUrl = avUrl;
    
    //1.判断本地是否有缓存
    NSString *videoPath = [ZZAVPlayerTool zz_avPlayerGetDocumentPathWithUrl:avUrl];
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
        avUrl = [NSURL fileURLWithPath:videoPath];
    }else{
        //2.判断url是否可用
        BOOL isCanUrl = [ZZAVPlayerTool zz_avPlayerHaveTracksWithURL:avUrl];
        if (!isCanUrl) {
            [self setAvPlayerState:ZZAVPlayerStatusError];
            self.avPlayerState = ZZAVPlayerStatusError;
            self.avPlayerErrorCode = ZZAVPlayerErrorCodeUrlError;
            return nil;
        }
    }
    // 3.准备工作
    [self zz_playerBeforePlayWithURL:avUrl];
    
    if (self.isLocalResource) {
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:avUrl options:nil];
        self.avPlayerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
        if (self.avPlayer) {
            [self.avPlayer replaceCurrentItemWithPlayerItem:self.avPlayerItem];
        }else{
            self.avPlayer = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
        }
        self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
        
    }else{
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:avUrl options:nil];
        self.avPlayerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
        if (self.avPlayer) {
            [self.avPlayer replaceCurrentItemWithPlayerItem:self.avPlayerItem];
        }else{
            self.avPlayer = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
        }
        self.avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    }
    
    [self setNotificationAndKVO];
    
    //开启后台处理多媒体事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    //后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    return self.avPlayerLayer;
}
#pragma mark -  重播
-(void)zz_playerReplayWithURL:(NSURL *)avUrl{
    self.avUrl = avUrl;
    [self zz_playerBeforePlayWithURL:avUrl];
    
    self.isLocalResource = YES;
    if (self.isLocalResource) {
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:avUrl options:nil];
        
        NSArray *tracks = [urlAsset tracksWithMediaType:AVMediaTypeVideo];
        if ([tracks count] <= 0) {
            NSLog(@"不可看");
        }
        self.avPlayerItem = [AVPlayerItem playerItemWithAsset:urlAsset];
        if (self.avPlayer) {
            [self.avPlayer replaceCurrentItemWithPlayerItem:self.avPlayerItem];
        }else{
            self.avPlayer = [AVPlayer playerWithPlayerItem:self.avPlayerItem];
        }
    }
    [self setNotificationAndKVO];
    
    //开启后台处理多媒体事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    //后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}
#pragma mark -  播放前准备
-(void)zz_playerBeforePlayWithURL:(NSURL *)avUrl{
    [self.avPlayer pause];
    [self removeNotificationAndKVO];
    self.loadedProgress = 0;
    self.currentTime = 0;
    self.isUserPause = NO;
    
    // 第一帧
    self.fristImage = [ZZAVPlayerTool zz_avPlayerGetFirstImageWtihUrl:avUrl];
    // 总时长
    self.totalTime = [ZZAVPlayerTool zz_avPlayerGetVideoTotalTimeWithURL:avUrl];
    if ([avUrl.scheme isEqualToString:@"file"]) {
        //本地资源
        self.isLocalResource = YES;
        [self setAvPlayerState:self.isNowPlay? ZZAVPlayerStatusPlaying : ZZAVPlayerStatusPause];
    }else{
        self.isLocalResource = NO;
        [self setAvPlayerState:self.isNowPlay? ZZAVPlayerStatusLoading : ZZAVPlayerStatusPause];
    }
    
}
#pragma mark -  开始播放
-(void)zz_playerSeekToTime:(CGFloat)seconds{
    if (self.avPlayerState == ZZAVPlayerStatusStopped) return;
    
    seconds = MAX(0, seconds);
    seconds = MIN(seconds, self.totalTime);
    self.currentTime = seconds;
    
    [self.avPlayer seekToTime:CMTimeMakeWithSeconds(seconds, self.avPlayerItem.currentTime.timescale) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        self.isUserPause = NO;
        [self.avPlayer play];
        if (self.avPlayerItem.isPlaybackBufferEmpty) {
            [self setAvPlayerState:(ZZAVPlayerStatusLoading)];
        }else{
            [self setAvPlayerState:(ZZAVPlayerStatusPlaying)];
        }
        
    }];
}
#pragma mark -  恢复播放
-(void)zz_playerResume{
    [self.avPlayer play];
    [self setAvPlayerState:(ZZAVPlayerStatusPlaying)];
}
#pragma mark -  暂停
-(void)zz_playerPause{
    [self.avPlayer pause];
    [self setAvPlayerState:(ZZAVPlayerStatusPause)];
}
#pragma mark -  停止
-(void)zz_playerStop{
    
    [self.avPlayer seekToTime:kCMTimeZero
              toleranceBefore:kCMTimeZero
               toleranceAfter:kCMTimeZero
            completionHandler:^(BOOL finished) {
        
        if (finished) {
            // 进度处理
            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(zz_player:progress:currentTime:durationTime:)]) {
                
                [self.delegate zz_player:self
                                progress:self.currentProgress
                             currentTime:self.currentTime
                            durationTime:self.totalTime];
            }
            self.isUserPause = NO;
            self.currentTime = 0.0;
            [self setAvPlayerState:(ZZAVPlayerStatusStopped)];
            [self.avPlayer pause];
            [self releaseAVPlayer];
        }
    }];
    
}

#pragma mark -  显示锁屏信息
- (void)setLockingInfo {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //设置歌曲题目
    [dict setObject:self.avUrl.lastPathComponent forKey:MPMediaItemPropertyTitle];
    //设置歌手名
    [dict setObject:self.avUrl.lastPathComponent forKey:MPMediaItemPropertyArtist];
    //设置专辑名
    [dict setObject:self.avUrl.lastPathComponent forKey:MPMediaItemPropertyAlbumTitle];
    //设置显示的图片
    UIImage *newImage = [UIImage getImageWithNamed:@"zzMakePlayer_播放-全屏"];
    [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:newImage] forKey:MPMediaItemPropertyArtwork];
    //设置歌曲时长
    [dict setObject:[NSNumber numberWithDouble:self.totalTime] forKey:MPMediaItemPropertyPlaybackDuration];
    //设置已经播放时长
    [dict setObject:[NSNumber numberWithFloat:CMTimeGetSeconds(self.avPlayer.currentItem.currentTime)] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    //更新字典
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}


#pragma mark - Delegate

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        // 播放器状态
        if ([playerItem status] == AVPlayerItemStatusReadyToPlay) {
            //准备完毕，可以播放
            [self observerStatusWithPlayerItem:playerItem];
        }else if([playerItem status] == AVPlayerItemStatusFailed ||
                 ([playerItem status] == AVPlayerItemStatusUnknown) ) {
            //加载失败
            [self zz_playerStop];
        }
    }else if ( [keyPath isEqualToString:@"loadedTimeRanges"] ){
        //监听播放器的缓冲进度
        [self observerDownloadProgressWithPlayerItem:playerItem];
    }else if ( [keyPath isEqualToString:@"playbackBufferEmpty"] ){
        //监听播放器的缓冲
        if (playerItem.isPlaybackBufferEmpty) {
            self.avPlayerState = ZZAVPlayerStatusLoading;
            [self observerAVPlayerBufferEmpty];
        }
    }else if ( [keyPath isEqualToString:@"playbackLikelyToKeepUp"] ){
        // seekToTime后,可以正常播放，
        // 相当于readyToPlay，一般拖动滑竿菊花转，到了这个状态菊花隐藏
    }
}

/// 处理监听 播放器状态
-(void)observerStatusWithPlayerItem:(AVPlayerItem *)playerItem{
    if (self.isNowPlay){
        [self.avPlayer play];
        [self setAvPlayerState:(ZZAVPlayerStatusPlaying)];
    };
    WeakSelf
    //(1,1) 每一秒执行一次
    self.avPlayerObserver =
    [self.avPlayer addPeriodicTimeObserverForInterval:(CMTimeMake(1, 1))
                                                queue:NULL
                                           usingBlock:^(CMTime time) {
        StrongSelf
        CGFloat current = playerItem.currentTime.value / playerItem.currentTime.timescale;
        NSLog(@"当前播放时间：%.2f",current);
        if (self.isUserPause == NO) {
            //self.avPlayerState = ZZAVPlayerStatusPlaying;
        }
        if (self.currentTime != current) {
            self.currentTime = current > self.totalTime ? self.totalTime : current;
            [self setLockingInfo];
            if ([self.delegate respondsToSelector:@selector(zz_player:progress:currentTime:durationTime:)]) {
                [self.delegate zz_player:self
                                progress:self.currentProgress
                             currentTime:current
                            durationTime:self.totalTime];
            }
        }
    }];
    
}
/// 处理监听 缓冲进度
-(void)observerDownloadProgressWithPlayerItem:(AVPlayerItem *)playerItem{
    //获取缓冲区域
    CMTimeRange timeRange = [[playerItem loadedTimeRanges].firstObject CMTimeRangeValue];
    CGFloat strat = CMTimeGetSeconds(timeRange.start);
    CGFloat duration = CMTimeGetSeconds(timeRange.duration);
    // 缓冲总进度
    NSTimeInterval timeInterval = strat + duration;
    CMTime durationTime = playerItem.duration;
    CGFloat totalTime = CMTimeGetSeconds(durationTime);
    // 计算缓存进度
    self.loadedProgress = timeInterval / totalTime;
    NSLog(@"缓冲总进度：%f",self.loadedProgress);
    
}
/// 处理监听 缓冲区域
-(void)observerAVPlayerBufferEmpty{
    // playbackBufferEmpty会反复进入，因此在bufferingOneSecond延时
    // 播放执行完之前再调用bufferingSomeSecond都忽略
    static BOOL Loading = NO;
    if (Loading) return;
    Loading = YES;
    [self.avPlayer pause];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isUserPause) {
            Loading = NO;
            return ;
        }
        [self.avPlayer play];
        // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
        Loading = YES;
        if (!self.avPlayerItem.isPlaybackLikelyToKeepUp) {
            [self observerAVPlayerBufferEmpty];
        }
    });
    
}

#pragma mark - Notification
///当前视频播放结束
- (void)playerItemDidPlayToEnd:(NSNotification *)notification{
    self.avPlayerState = ZZAVPlayerStatusEnd;
    [self.avPlayer pause];
}
///在监听播放器状态中处理比较准确
- (void)playerItemPlaybackStalled:(NSNotification *)notification{
    // 这里网络不好的时候，就会进入，不做处理
    // 会在playbackBufferEmpty里面缓存之后重新播放
    NSLog(@"buffing-----buffing");
}

- (void)onAppWillResignActive:(NSNotification *)notification {
    NSLog(@"onAppWillResignActive 锁屏");
    if (self.isStopWhenAppEnterBackground) {
        [self zz_playerPause];
        self.isUserPause = NO;
    }
}
- (void)onAppDidBecomeActive:(NSNotification *)notification {
    NSLog(@"onAppDidBecomeActive 解屏");
    if (!self.isUserPause) {
        [self zz_playerResume];
    }
}

- (void)onAppDidEnterBackGround:(NSNotification *)notification {
    NSLog(@"onAppDidEnterBackGround 后台");
    // mp4
    self.avPlayerLayer.player = nil;
    [self beginTask];
}
- (void)onAppWillEnterForeground:(NSNotification *)notification {
    NSLog(@"onAppWillEnterForeground 前台");
    self.avPlayerLayer.player = self.avPlayer;
    [self endBack];
}

- (void)onAppWillTerminate:(NSNotification *)notification {
    NSLog(@"onAppWillTerminate");
}


//app进入后台后保持运行
- (void)beginTask{
    _bgTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"ZZAVPlayer" expirationHandler:^{
        [self endBack];
    }];
}

//结束后台运行，让app挂起
- (void)endBack{
    //切记endBackgroundTask要和beginBackgroundTaskWithExpirationHandler成对出现
    [[UIApplication sharedApplication] endBackgroundTask:_bgTaskId];
    _bgTaskId = UIBackgroundTaskInvalid;
}

#pragma mark - Getters and Setters
-(void)setAvPlayerState:(ZZAVPlayerStatus)avPlayerState{
    _avPlayerState = avPlayerState;
    
    if ([self.delegate respondsToSelector:@selector(zz_player:avPlayerStatus:avPlayerErrorCode:)]) {
           [self.delegate zz_player:self avPlayerStatus:avPlayerState avPlayerErrorCode:self.avPlayerErrorCode];
       }
    
}
-(CGFloat)currentProgress{
    if (self.totalTime > 0) {
        return self.currentTime / self.totalTime;
    }
    return 0;
}
@end

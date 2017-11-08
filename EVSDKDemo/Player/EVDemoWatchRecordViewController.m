//
//  EVDemoWatchRecordViewController.m
//  EVSDKDemo
//
//  Created by Lcrnice on 17/5/12.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import "EVDemoWatchRecordViewController.h"
//#import "EVPlayer.h"
//#import "EVPlayerConfig.h"
#import <EVMediaFramework/EVPlayer.h>
#import <EVMediaFramework/EVPlayerConfig.h>
#import "EVProgressView.h"

@interface EVDemoWatchRecordViewController () <EVPlayerDelegate>

@property (nonatomic, strong) EVPlayer *player;     /**< 播放器 */

@end

@implementation EVDemoWatchRecordViewController {
    NSTimer *_timer;
    UIButton *_statusBtn;
    EVProgressView *_progressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpUIAndConifgPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - player
- (void)setUpUIAndConifgPlayer{
    // UI
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusBtn.frame = CGRectMake(10, height - 60, 40, 30);
    [_statusBtn setTitle:@"播放" forState:UIControlStateSelected];
    [_statusBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [_statusBtn addTarget:self action:@selector(changeVideoStatus:) forControlEvents:UIControlEventTouchUpInside];
    _statusBtn.backgroundColor = [UIColor colorWithRed:.5f green:.5f blue:.5f alpha:1.f];
    [self.view addSubview:_statusBtn];
    
    _progressView = [[EVProgressView alloc] init];
    _progressView.frame = CGRectMake(_statusBtn.frame.origin.x + _statusBtn.frame.size.width + 10,
                                     height - 60,
                                     width - 70,
                                     30);
    [self.view addSubview:_progressView];
    
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view insertSubview:containerView atIndex:0];
    
    
    // player
    self.player = [[EVPlayer alloc] init];
    self.player.playerContainerView = containerView;
    self.player.currentPlaybackTime = self.watchStartPosition;
    self.player.live = NO;
    self.player.lid = self.vid;
    self.player.delegate = self;
    
    __weak typeof(self) wSelf = self;
    [self.player playPrepareComplete:^(EVPlayerResponseCode responseCode, NSDictionary *result, NSError *err) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (responseCode == EVPlayerResponse_Okay) {
            [sSelf.player play];
        } else {
            NSLog(@"录播播放失败：%@", err);
        }
    }];
    
    // start timer
    [self startTimer];
    
    
    __weak typeof(_player) weakPlayer = _player;
    _progressView.dragingSliderCallback = ^(EVProgressView *progressView, float progress){
        typeof(weakPlayer) strongPlayer = weakPlayer;
        double seekPos = progress * strongPlayer.duration;
        // 使用 currentPlaybackTime 设置为依靠关键帧定位
//        strongPlayer.currentPlaybackTime = seekPos;
        // 使用 seekTo: 为精准定位
        [strongPlayer seekTo:seekPos];
    };
}

- (void)changeVideoStatus:(UIButton *)btn {
    if (_statusBtn.selected) {
        [self.player play];
    }
    else {
        [self.player pause];
        
    }
    
    _statusBtn.selected = !_statusBtn.selected;
}

#pragma mark - EVPlayerDelegate
- (void)EVPlayerFirstVideoFrameDidRender:(EVPlayer *)player {
    NSLog(@"视频第一帧已渲染");
}
- (void)EVPlayerDidFinishPlay:(EVPlayer *)player reason:(MPMovieFinishReason)reason {
    NSLog(@"播放完毕");
}

- (void)EVPlayer:(EVPlayer *)player cacheState:(EVPlayerCacheState)state {
    NSLog(@"缓冲状态：%@", @(state));
}


#pragma mark - timer
- (void)startTimer {
    if(_timer != nil){
        return;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateState:) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (nil == _timer) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
}

- (void)updateState:(NSTimer *)timer {
    if (nil == _player) {
        return;
    }
    
    // 更新播放器的缓冲条
    CGFloat duration = _player.duration;
    CGFloat playableDuration = _player.playableDuration;
    if(duration > 0){
        _progressView.cacheProgress = playableDuration / duration;
    }
    else{
        _progressView.cacheProgress = 0.0;
    }
    
    // 更新进度
    _progressView.totalTimeInSeconds = _player.duration;
    _progressView.playProgress = _player.currentPlaybackTime / _player.duration;
}

#pragma mark - btn actions
- (IBAction)close:(id)sender {
    if (_player) {
        [_player shutDown];
        _player = nil;
    }
    
    [self stopTimer];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)resizePlayer:(id)sender {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    CGRect halfFrame = CGRectMake(width/2, 0, width/2, height/2);
    CGRect originFrame = CGRectMake(0, 0, width, height);
    
    static BOOL changed;
    if (changed == false) {
        self.player.playerViewFrame = halfFrame;
    }
    else {
        self.player.playerViewFrame = originFrame;
    }
    changed = !changed;
}




@end

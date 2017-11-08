//
//  EVWatchVRViewController.m
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/7/18.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import "EVWatchVRViewController.h"
#import <EVVRFramework/EVVRPlayer.h>

@interface EVWatchVRViewController () <EVVRPlayerDelegate>
@property (nonatomic, strong) EVVRPlayer *vrPlayer; /**< vr 播放器 */
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation EVWatchVRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.urlString = [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    EVVRPlayer *vrPlayer = [[EVVRPlayer alloc] initVRPlayerWithFrame:self.view.bounds];
    vrPlayer.contentType = self.contentType;
    [self.containerView addSubview:vrPlayer.renderView];
    vrPlayer.renderView.backgroundColor = [UIColor clearColor];
    vrPlayer.delegate = self;
    [vrPlayer playWithUrl:self.urlString isliving:self.living];
    self.vrPlayer = vrPlayer;
    
//    self.vrPlayer.mode = EVVRPlayerModeFingerSingle;
}

- (void)destoryVRVideoPlayer
{
    if (self.vrPlayer) {
        [self.vrPlayer shutdown];
        [self.vrPlayer.renderView removeFromSuperview];
        self.vrPlayer.delegate = nil;
        self.vrPlayer = nil;
    }
}

- (IBAction)close:(id)sender {
    [self destoryVRVideoPlayer];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)switchMode:(UISegmentedControl *)sender {
    NSInteger idx = sender.selectedSegmentIndex;
    EVVRPlayerMode mode = EVVRPlayerModeDefualt;
    if (idx == 0) {
        mode = EVVRPlayerModeGyroSingle;
    } else if (idx == 1) {
        mode = EVVRPlayerModeGyroDuplicate;
    } else if (idx == 2) {
        mode = EVVRPlayerModeGyroDuplicateHorizontal;
    }
    self.vrPlayer.mode = mode;
}

#pragma mark CCVRPlayerDelegate
- (void)evVRPlayer:(EVVRPlayer *)player updateCurrrentTime:(double)time {
//    NSInteger intDuration  = self.vrPlayer.duration;
//    NSInteger intBuffering = 0;
//    double intPosition     = time;
//    NSLog(@"\nVR>>>>>\nduration %ld\nbuffer %ld\nposition %f", (long)intDuration, intBuffering, intPosition);
}

- (void)evVRPlayer:(EVVRPlayer *)player status:(EVVRPlayerStatus)status {
    switch (status) {
        case EVVRPlayerStatusPrepared:
        {
            [self.vrPlayer play];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                double inDuration = self.vrPlayer.duration;
//                NSLog(@"duration:%f", inDuration);
//            });
        }
            break;
            
        case EVVRPlayerStatusBuffering:
            break;
            
        case EVVRPlayerStatusPlaying:
        {
        }
            break;
            
        case EVVRPlayerStatusPaused:
            break;
            
        case EVVRPlayerStatusEnd:
        {
            NSLog(@"INSPlayerStatusEnd");
            [self.vrPlayer stop];
        }
            break;
            
        case EVVRPlayerStatusFailed:
        {
            [self.vrPlayer stop];
        }
            break;
            
        case EVVRPlayerStatusUnknown:
            break;
            
        default:
            break;
    }
}

- (void)evVRPlayerOnloaded:(EVVRPlayer *)player {
    NSLog(@"%s", __FUNCTION__);
}

- (void)evVRPlayerOnLoading:(EVVRPlayer *)player {
    NSLog(@"%s", __FUNCTION__);
}

@end

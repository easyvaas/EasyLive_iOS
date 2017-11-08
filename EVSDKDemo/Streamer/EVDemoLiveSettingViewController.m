//
//  EVDemoLiveSettingViewController.m
//  EVSDKDemo
//
//  Created by mashuaiwei on 16/8/1.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#import "EVDemoLiveSettingViewController.h"
//#import "EVStreamer.h"
#import <EVMediaFramework/EVStreamer.h>
#import "EVDemoLiveViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CCAlertManager.h"
#import "EVMediaAuth.h"

@interface EVDemoLiveSettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn_video_360x640;
@property (weak, nonatomic) IBOutlet UIButton *btn_video_540x960;
@property (weak, nonatomic) IBOutlet UIButton *btn_video_720x1280;
@property (weak, nonatomic) IBOutlet UITextField *videoInitialBitrate;
@property (weak, nonatomic) IBOutlet UISegmentedControl *audioBitrate;
@property (weak, nonatomic) IBOutlet UIButton *audioHAAC;
@property (weak, nonatomic) IBOutlet UIButton *muteBtn;
@property (weak, nonatomic) IBOutlet UIButton *frontCameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *beautyBtn;

@property (nonatomic, assign) EVStreamFrameSize streamFrameSize; /**< 视频流帧尺寸（宽高） */
@property (nonatomic, assign) BOOL useHAAC; /**< 是否使用high aac进行音频编码 */
@property (nonatomic, assign) BOOL mute; /**< 静音 */
@property (nonatomic, assign) BOOL frontCamera; /**< 前置摄像头 */
@property (nonatomic, assign) BOOL beauty; /**< 是否开启美颜 */

@end

@implementation EVDemoLiveSettingViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播设置";
    [self configDefaultSettings];
}


#pragma mark - UIAction

- (IBAction)select_360x640:(UIButton *)sender {
    sender.selected = YES;
    self.btn_video_540x960.selected = NO;
    self.btn_video_720x1280.selected = NO;
}

- (IBAction)select_540x960:(UIButton *)sender {
    sender.selected = YES;
    self.btn_video_360x640.selected = NO;
    self.btn_video_720x1280.selected = NO;
}

- (IBAction)select_720x1280:(UIButton *)sender {
    sender.selected = YES;
    self.btn_video_360x640.selected = NO;
    self.btn_video_540x960.selected = NO;
}
- (IBAction)audioBitrate:(UISegmentedControl *)sender {
    
}

- (IBAction)useHightAAC:(UIButton *)sender {
    sender.selected = !sender.selected;
    _useHAAC = sender.selected;
}

- (IBAction)mute:(UIButton *)sender {
    sender.selected = !sender.selected;
    _mute = sender.selected;
}

- (IBAction)frontCamera:(UIButton *)sender {
    sender.selected = !sender.selected;
    _frontCamera = sender.selected;
}

- (IBAction)beauty:(UIButton *)sender {
    sender.selected = !sender.selected;
    _beauty = sender.selected;
}

- (IBAction)startLive:(UIButton *)sender {
    NSLog(@"start button clicked");
    
    [EVMediaAuth checkAndRequestMicPhoneAndCameraUserAuthed:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pushToLiveViewController];
        });
    } userDeny:nil];
}


#pragma mark - private methods

- (void)pushToLiveViewController{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    EVDemoLiveViewController *liveVC = [storyBoard instantiateViewControllerWithIdentifier:@"EVDemoLiveViewController"];
    NSMutableDictionary *streamerParams = [NSMutableDictionary dictionary];
    [streamerParams setValue:@(self.streamFrameSize) forKey:kStreamFrameSizeKey];
    [streamerParams setValue:@([self.videoInitialBitrate.text integerValue]) forKeyPath:kInitialBitrateKey];
    [streamerParams setValue:@(self.audioBitrate.selectedSegmentIndex) forKeyPath:kAudioBitrateKey];
    [streamerParams setValue:@(self.useHAAC) forKeyPath:kUseHighAACKey];
    [streamerParams setValue:@(self.mute) forKey:kMuteKey];
    [streamerParams setValue:@(self.frontCamera) forKey:kFrontCameraKey];
    [streamerParams setValue:@(self.beauty) forKey:kBeautyKey];
    liveVC.streamerParams = streamerParams;
    [self presentViewController:liveVC animated:YES completion:nil];
}

- (void)configDefaultSettings{
    self.btn_video_360x640.selected = YES;
    [self.audioBitrate setSelectedSegmentIndex:1];
    self.audioHAAC.selected = YES;
    self.frontCameraBtn.selected = YES;
    self.beautyBtn.selected = YES;
    self.frontCamera = YES;
    _beauty = YES;
    _useHAAC = YES;
}

#pragma mark - uitil


@end

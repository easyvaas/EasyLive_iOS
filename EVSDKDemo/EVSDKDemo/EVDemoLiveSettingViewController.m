//
//  EVDemoLiveSettingViewController.m
//  EVSDKDemo
//
//  Created by mashuaiwei on 16/8/1.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#import "EVDemoLiveSettingViewController.h"
#import "EVStreamer.h"
#import "EVDemoLiveViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CCAlertManager.h"

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
    
    __weak typeof(self) wSelf = self;
    [self checkAndRequestMicPhoneAndCameraUserAuthed:^{
        __strong typeof(wSelf) sSelf = wSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            [sSelf pushToLiveViewController];
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
// 摄像头 和 麦克风授权
- (void)checkAndRequestMicPhoneAndCameraUserAuthed:(void(^)())userAuthed
                                          userDeny:(void(^)())userDeny
{
    [self requestCameraAuthedUserAuthed:^{
        [self requestMicPhoneAuthedUserAuthed:userAuthed userDeny:userDeny];
    } userDeny:userDeny];
}

// 摄像头授权
- (void)requestCameraAuthedUserAuthed:(void(^)())userAuthed
                             userDeny:(void(^)())userDeny
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus cameraAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if ( cameraAuthStatus == AVAuthorizationStatusAuthorized )
    {
        
        if ( userAuthed )
        {
            userAuthed();
        }
        
    }
    else if ( cameraAuthStatus == AVAuthorizationStatusNotDetermined )
    {
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if ( granted )
            {
                if ( userAuthed )
                {
                    userAuthed();
                }
            }
            else
            {
                if ( userDeny )
                {
                    userDeny();
                }
            }
        }];
    }
    else if ( cameraAuthStatus == AVAuthorizationStatusDenied || cameraAuthStatus == AVAuthorizationStatusRestricted )
    {
        if ( [UIDevice currentDevice].systemVersion.floatValue < 8.0 )
        {
            [[CCAlertManager shareInstance] performComfirmTitle:@"提示" message:@"易直播请求访问您的摄像机和麦克风,请到设置->隐私->相机 | 麦克风 -> 易直播 进行相应的授权" cancelButtonTitle:@"取消" comfirmTitle:@"确定" WithComfirm:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
            } cancel:nil];
        }
        else
        {
            [[CCAlertManager shareInstance] performComfirmTitle:@"提示" message:@"易直播请求访问您的摄像头" cancelButtonTitle:@"不允许" comfirmTitle:@"允许" WithComfirm:^{
                BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != nil);
                if (canOpenSettings)
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            } cancel:^{
                if ( userDeny )
                {
                    userDeny();
                }
            }];
        }
    }
}

// 麦克风授权
- (void)requestMicPhoneAuthedUserAuthed:(void(^)())userAuthed
                               userDeny:(void(^)())userDeny
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ( [audioSession respondsToSelector:@selector(recordPermission)] )
    {
        AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
        switch ( permission )
        {
            case AVAudioSessionRecordPermissionGranted:
                
                if ( userAuthed )
                {
                    userAuthed();
                }
                break;
                
            case AVAudioSessionRecordPermissionDenied:
            {
                [[CCAlertManager shareInstance] performComfirmTitle:@"提示" message:@"易直播请求访问您的麦克风" cancelButtonTitle:@"不允许" comfirmTitle:@"允许" WithComfirm:^{
                    BOOL canOpenSettings = (UIApplicationOpenSettingsURLString != nil);
                    if (canOpenSettings)
                    {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }
                } cancel:^{
                    if ( userDeny )
                    {
                        userDeny();
                    }
                }];
            }
                break;
                
            case AVAudioSessionRecordPermissionUndetermined:
            {
                [self askForMicAuthedUserAuthed:userAuthed userDeny:userDeny];
            }
                break;
                
            default:
                break;
        }
    }
    else if ( [[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)] )
    {
        [self askForMicAuthedUserAuthed:userAuthed userDeny:userDeny];
    }
}

/**
 *  使用系统默认的方式请求麦克风授权 只适配 iOS 7 以上的手机
 *
 *  @param userAuthed 用户授权成功
 *  @param userDeny   用户授权拒绝
 */
- (void)askForMicAuthedUserAuthed:(void(^)())userAuthed
                         userDeny:(void(^)())userDeny
{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if ( granted )
        {
            if ( userAuthed )
            {
                userAuthed();
            }
        }
        else
        {
            [[CCAlertManager shareInstance] performComfirmTitle:@"提示" message:@"易直播请求访问您的麦克风,请到设置->隐私-> 麦克风 -> 易直播 进行相应的授权" cancelButtonTitle:@"取消" comfirmTitle:@"确定" WithComfirm:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root"]];
            } cancel:userDeny];
        }
    }];
}

@end

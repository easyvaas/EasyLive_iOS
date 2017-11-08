//
//  EVDemoLiveViewController.m
//  EVSDKDemo
//
//  Created by mashuaiwei on 16/7/28.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#import "EVDemoLiveViewController.h"
//#import "EVStreamer.h"
#import <EVMediaFramework/EVStreamer.h>
#import "CCAlertManager.h"
#import <AVFoundation/AVFoundation.h>
#import "EVNetRequestManager.h"
//#import "EVSDKManager.h"
#import <EVSDKBaseFramework/EVSDKManager.h>
#import "EVGenerateQRViewController.h"
#import "EVConfigBeautyLevelViewController.h"

static NSString * const kAgoraId = @"";

@interface EVDemoLiveViewController ()<EVStreamerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *vidLbl;
@property (weak, nonatomic) IBOutlet UIButton *muteBtn;
@property (weak, nonatomic) IBOutlet UIButton *frontCameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *flashlightBtn;
@property (weak, nonatomic) IBOutlet UIButton *beautyBtn;
@property (weak, nonatomic) IBOutlet UIButton *musicBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (nonatomic, strong) EVStreamer *streamer; /**< 直播端推流器 */
@property (nonatomic, copy) NSString *vid;  /**< 视频id */
@property (nonatomic, assign) NSInteger currentBeautyLevel;
@property (nonatomic, assign) BOOL isBeautyEnable;

@property (nonatomic, assign) BOOL musicNeedContinue;   /**< 记录音乐是否需要继续播放 */

@end

@implementation EVDemoLiveViewController

#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    [self configCustomUI];
    [self setupEncoder];
    [self setUpNotification];
}

- (void)dealloc{
    _streamer.delegate = nil;
    [_streamer shutDown];
    _streamer = nil;
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - IBAction

- (IBAction)dismiss:(UIButton *)sender
{
    __weak typeof(self) wSelf = self;
    NSLog(@"chat state: %ld", self.streamer.chatState);
    if (self.streamer.chatState == EVVideoChatStateRemoteVideoRendered) {
        [[CCAlertManager shareInstance] performComfirmTitle:@"提示" message:@"请先结束连麦" comfirmTitle:@"好的" WithComfirm:^{
            __strong typeof(wSelf) sSelf = wSelf;
            [sSelf.streamer leaveChannel];
            sSelf.chatBtn.selected = !sSelf.chatBtn.selected;
        }];
        
        return;
    }
    
    
    [[CCAlertManager shareInstance] performComfirmTitle:@"提示" message:@"是否停止当前直播?" cancelButtonTitle:@"取消" comfirmTitle:@"确定" WithComfirm:^{
        __strong typeof(wSelf) sSelf = wSelf;
        [sSelf.streamer shutDown];
        [wSelf dismissViewControllerAnimated:YES completion:nil];
    } cancel:^{
        
    }];
}

- (IBAction)switchCamera:(UIButton *)sender
{
    BOOL font = !sender.selected;
    if (font) {
        self.flashlightBtn.selected = NO;
    }
    sender.userInteractionEnabled = NO;
    sender.selected = [self.streamer swithCamera] ? font : !font;
    sender.userInteractionEnabled = YES;
}

- (IBAction)flashLightON:(UIButton *)sender
{
    if (self.frontCameraBtn.selected) {
        return;
    }
    BOOL on = !sender.selected;
    [self.streamer turnOnFlashLight:on];
    sender.selected = on;
}

- (IBAction)mute:(UIButton *)sender {
    BOOL on = !sender.selected;
    [self.streamer muteStream:on];
    sender.selected = on;
}
- (IBAction)beauty:(UIButton *)sender {
    EVConfigBeautyLevelViewController *beautyVC = [EVConfigBeautyLevelViewController instanceVC];
    beautyVC.index = self.currentBeautyLevel-1;
    beautyVC.segValueChanged = ^(NSInteger index) {
        self.currentBeautyLevel = index;
        // 设置推流器美颜等级
        [self.streamer configBeautyLevel:index];
    };
    beautyVC.isBeautyEnable = self.isBeautyEnable;
    beautyVC.switchValueChanged = ^(BOOL YorN) {
        // 是否开启推流器美颜
        [self.streamer enableFaceBeauty:YorN];
        self.isBeautyEnable = YorN;
    };
    [beautyVC showInViewController:self];
}
- (IBAction)music:(UIButton *)sender {
    BOOL on = !sender.selected;
    if (on) {
        self.musicNeedContinue = YES;
        [self.streamer BGMPlayWithPath:[[NSBundle mainBundle] pathForResource:@"zebra" ofType:@"mp3"]];
    } else {
        self.musicNeedContinue = NO;
        [self.streamer BGMPause];
    }
    
    sender.selected = on;
}
- (IBAction)changeVolume:(UISlider *)sender {
    self.streamer.BGMVolume = sender.value;
}

- (IBAction)valueChanged:(UISlider *)sender
{
    [self.streamer cameraZoomWithFactor:sender.value];
}
- (IBAction)interactiveLiveButtonClicked:(UIButton *)sender {
    if (!self.streamer.agoraAppid) {
        [[CCAlertManager shareInstance] performComfirmTitle:nil message:@"请先设置agoraAppid" comfirmTitle:@"确定" WithComfirm:nil];
        return;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.streamer joinChannel:@"evtest002"];
    } else {
        [self.streamer leaveChannel];
    }
}
- (void)generateQR:(UIGestureRecognizer *)sender {
    if (self.vid) {
        EVGenerateQRViewController *QRVC = [EVGenerateQRViewController new];
        QRVC.infoString = self.vid;
        [self presentViewController:QRVC animated:YES completion:nil];
    }
}


#pragma mark - EVStreamerDelegate

- (void)EVStreamerStreamStateChanged:(EVVideoStreamerState)state{
    switch (state) {
        case EVVideoStreamerStreamIdle:
            NSLog(@"闲置状态，未推流");
            break;
            
        case EVVideoStreamerStreamError:
            NSLog(@"推流失败");
            break;
            
        case EVVideoStreamerStreamConnecting:
            NSLog(@"服务器连接中");
            break;
            
        case EVVideoStreamerStreamConnected:
            NSLog(@"开始推流");
            [[CCAlertManager shareInstance] performComfirmTitle:nil message:@"开始推流" comfirmTitle:@"确定" WithComfirm:nil];
            break;
            
        case EVVideoStreamerStreamDisconnecting:
            NSLog(@"断开连接");
            break;
            
        default:
            break;
    }
}

- (void)EVStreamerBufferStateChanged:(EVVideoStreamerStreamBufferState)state{
    switch (state) {
        case EVVideoStreamerStreamBufferStateNormal:
            NSLog(@"正常推流");
            break;
            
        case EVVideoStreamerStreamBufferStateLv1:
            NSLog(@"当前网络比较差，等级1，还可以坚持继续播");
            break;
            
        case EVVideoStreamerStreamBufferStateLv2:
            NSLog(@"当前网络弱爆了，等级2，建议关闭直播");
            break;
            
        case EVVideoStreamerStreamBufferStateLv3:
            NSLog(@"当前网络无法直播，可以直接掐掉了");
            break;
            
        default:
            break;
    }
}

- (void)EVStreamerUpdateVideoChatState:(EVVideoChatState)chatState{
    NSLog(@"连麦状态：%lu", chatState);
}



#pragma mark - notification

- (void)didEnterForeground
{
    if (self.musicNeedContinue) {
        [self.streamer BGMResume];
    }
    
}

- (void)didEnterBackground
{
    if (self.musicNeedContinue) {
        [self.streamer BGMPause];
    }
}


#pragma mark - private methods

- (void)configCustomUI{
    self.muteBtn.selected = [self.streamerParams[kMuteKey] boolValue];
    self.frontCameraBtn.selected = [self.streamerParams[kFrontCameraKey] boolValue];
    self.flashlightBtn.selected = [self.streamerParams[kFlashlightKey] boolValue];
    self.isBeautyEnable = [self.streamerParams[kBeautyKey] boolValue];
    if (self.isBeautyEnable) {
        self.currentBeautyLevel = 3;
    }
    [self.vidLbl addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(generateQR:)];
        tap;
    })];
}

- (void)setupEncoder
{
    [self.view insertSubview:self.streamer.preview atIndex:0];
    self.streamer.delegate = self;
    self.streamer.videoBitrate = [(NSNumber *)self.streamerParams[kInitialBitrateKey] integerValue];
    self.streamer.audioBitrate = [(NSNumber *)self.streamerParams[kAudioBitrateKey] integerValue];
    self.streamer.useHEAAC = [(NSNumber *)self.streamerParams[kUseHighAACKey] boolValue];
    self.streamer.mute = [self.streamerParams[kMuteKey] boolValue];
    self.streamer.frontCamera = [self.streamerParams[kFrontCameraKey] boolValue];
    self.streamer.flashOn = [self.streamerParams[kFlashlightKey] boolValue];
    [self.streamer enableFaceBeauty:[self.streamerParams[kBeautyKey] boolValue]];
    self.streamer.agoraAppid = kAgoraId;
    
    __weak typeof(self) wSelf = self;
    [self.streamer livePrepareComplete:^(EVStreamerResponseCode responseCode, NSDictionary *result, NSError *err) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (responseCode == EVStreamerResponse_Okay) {
            [sSelf startLive];
        } else {
            [[CCAlertManager shareInstance] performComfirmTitle:@"err" message:err.description comfirmTitle:@"okay" WithComfirm:nil];
        }
    }];
}

- (void)startLive{
    [self.streamer startPreview];
    
    [self generateLid];
}

- (void)generateLid{
//    NSString *url = [NSString stringWithFormat:@"http://video.api.easyvaas.com/genstream?appid=%@", [EVSDKManager appID]];
    NSString *url = [NSString stringWithFormat:@"http://api.video.easyvaas.com/v2/server/live/create?appid=%@", [EVSDKManager appID]];
    __weak typeof(self) wSelf = self;
    [EVNetRequestManager httpGetWithUrl:url moreHeaders:nil success:^(NSDictionary *info) {
        NSLog(@"------get vid info: %@", info);
        
        __strong typeof(wSelf) sSelf = wSelf;
        NSNumber *state = info[@"state"];
        if ([state integerValue] == 0) {
            NSDictionary *content = info[@"content"];
            NSString *lid = content[@"lid"];
            if (lid) {
                [sSelf startWithVid:lid];
            }
        }else{
            [[CCAlertManager shareInstance] performComfirmTitle:nil message:@"获取lid失败" cancelButtonTitle:@"确定" comfirmTitle:@"重试" WithComfirm:^{
                [sSelf generateLid];
            } cancel:nil];
        }
    } failure:^(NSError *err) {
        __strong typeof(wSelf) sSelf = wSelf;
        [[CCAlertManager shareInstance] performComfirmTitle:nil message:@"获取vid失败" cancelButtonTitle:@"确定" comfirmTitle:@"重试" WithComfirm:^{
            [sSelf generateLid];
        } cancel:nil];
    }];
}

- (void)startWithVid:(NSString *)vid {
    self.vid = vid;
    self.vidLbl.text = [NSString stringWithFormat:@"vid: %@", self.vid];
//    NSString *encodeKey = [self.key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    self.streamer.URI = [NSString stringWithFormat:@"pushlocate?support=1&proto=2&lid=%@&key=%@", self.vid, encodeKey];
    self.streamer.lid = self.vid;
    __weak typeof(self) wSelf = self;
    [self.streamer liveStartComplete:^(EVStreamerResponseCode responseCode, NSDictionary *result, NSError *err) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (responseCode == EVStreamerResponse_Okay) {
            [sSelf.streamer startStream];
        } else {
          [[CCAlertManager shareInstance] performComfirmTitle:nil message:[NSString stringWithFormat:@"%@", err.userInfo[@"info"]] comfirmTitle:@"OK" WithComfirm:nil];
        }
    }];
}

- (void)setUpNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
}


#pragma mark - setters and getters

- (EVStreamer *)streamer{
    if ( !_streamer ){
        _streamer = [[EVStreamer alloc] init];
    }
    
    return _streamer;
}


@end

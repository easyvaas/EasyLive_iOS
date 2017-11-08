//
//  EVMediaAuth.m
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/7/25.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import "EVMediaAuth.h"
#import <AVFoundation/AVFoundation.h>
#import "CCAlertManager.h"

@implementation EVMediaAuth

// 摄像头 和 麦克风授权
+ (void)checkAndRequestMicPhoneAndCameraUserAuthed:(void(^)())userAuthed
                                          userDeny:(void(^)())userDeny
{
    [self requestCameraAuthedUserAuthed:^{
        [self requestMicPhoneAuthedUserAuthed:userAuthed userDeny:userDeny];
    } userDeny:userDeny];
}

// 摄像头授权
+ (void)requestCameraAuthedUserAuthed:(void(^)())userAuthed
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
+ (void)requestMicPhoneAuthedUserAuthed:(void(^)())userAuthed
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
+ (void)askForMicAuthedUserAuthed:(void(^)())userAuthed
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

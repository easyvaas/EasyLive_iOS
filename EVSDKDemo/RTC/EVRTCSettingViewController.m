//
//  EVRTCSettingViewController.m
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/7/11.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import "EVRTCSettingViewController.h"
#import <EVRTCFramework/EVRTCConfig.h>

@interface EVRTCSettingViewController ()

@property (weak, nonatomic) IBOutlet UIView *ev180pView;
@property (weak, nonatomic) IBOutlet UIView *ev360pView;
@property (weak, nonatomic) IBOutlet UIView *ev720pView;

@end

@implementation EVRTCSettingViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configProfile:self.currentProfile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchTo180p:(id)sender {
    [self configProfile:EVRtcVideoProfile_320x180];
}
- (IBAction)switchTo360p:(id)sender {
    [self configProfile:EVRtcVideoProfile_640x360];
}
- (IBAction)switchTo720p:(id)sender {
    [self configProfile:EVRtcVideoProfile_1280x720];
}

#pragma mark - helpers
- (void)configProfile:(EVRtcVideoProfile)profile {
    self.ev180pView.backgroundColor =
    self.ev360pView.backgroundColor =
    self.ev720pView.backgroundColor =
    [UIColor clearColor];
    
    switch (profile) {
        case EVRtcVideoProfile_320x180: {
            self.ev180pView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.2];
            break;
        }
        case EVRtcVideoProfile_640x360: {
            self.ev360pView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.2];
            break;
        }
        case EVRtcVideoProfile_1280x720: {
            self.ev720pView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.2];
            break;
        }
            
        default:
            break;
    }
    
    self.currentProfile = profile;
}

@end

//
//  EVDemoRootViewController.m
//  EVSDKDemo
//
//  Created by mashuaiwei on 16/7/25.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#import "EVDemoRootViewController.h"
#import "EVSDKManager.h"
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import "CCAlertManager.h"

@interface EVDemoRootViewController ()
@property (weak, nonatomic) IBOutlet UITextField *appidField;
@property (weak, nonatomic) IBOutlet UITextField *appkeyField;
@property (weak, nonatomic) IBOutlet UITextField *appSecreteField;
@property (weak, nonatomic) IBOutlet UITextField *useridField;
@property (weak, nonatomic) IBOutlet UILabel *SDKVersionLabel;

@end

@implementation EVDemoRootViewController


#pragma mark - life circle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self addObserver];
    self.SDKVersionLabel.text = [NSString stringWithFormat:@"SDK Version:%@", [EVSDKManager SDKVersion]];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - over write

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([EVSDKManager isSDKInitedSuccess]) {
        return YES;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"SDK尚未初始化！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UIView *subviews in self.view.subviews) {
        [subviews endEditing:YES];
    }
}


#pragma mark - UIAction

- (IBAction)initSDKButtonClicked:(UIButton *)sender {
    [self initSDK];
}


#pragma mark - notifications

- (void)initSDKError:(NSNotification *)notification{
    NSLog(@"---notification:%@", notification);
    NSString *message = [NSString stringWithFormat:@"%@", notification.object];
    [[CCAlertManager shareInstance] performComfirmTitle:notification.name message:message comfirmTitle:@"确定" WithComfirm:nil];
}

- (void)initSDKSuccess{
    [[CCAlertManager shareInstance] performComfirmTitle:@"初始化SDK成功" message:nil comfirmTitle:@"确定" WithComfirm:nil];
}


#pragma mark - private methods

- (void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initSDKError:) name:EVSDKInitErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initSDKSuccess) name:EVSDKInitSuccessNotification object:nil];
}

- (void)initSDK{
    NSString *appid = self.appidField.text;
    NSString *appkey = self.appkeyField.text;
    NSString *appsecret = self.appSecreteField.text;
    NSString *userid = self.useridField.text;
    
    // 一般
    [EVSDKManager initSDKWithAppID:appid appKey:appkey appSecret:appsecret userID:userid];
}

@end

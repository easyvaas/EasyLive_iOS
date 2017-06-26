//
//  EVDemoWatchSettingViewController.m
//  EVSDKDemo
//
//  Created by mashuaiwei on 16/8/13.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#import "EVDemoWatchSettingViewController.h"
#import "EVDemoWatchViewController.h"
#import "EVScanQRViewController.h"
#import "CCAlertManager.h"
#import "EVDemoWatchRecordViewController.h"

static NSString * const kEVWatchLive = @"EVWatchLive";
static NSString * const kEVWatchRecord = @"EVWatchRecord";

@interface EVDemoWatchSettingViewController ()

@property (weak, nonatomic) IBOutlet UIButton *liveBtn;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UITextField *liveVidField;

@property (nonatomic, assign) BOOL isLive; /**< 是否是直播 */

@end

@implementation EVDemoWatchSettingViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self configUI];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)configUI{
    self.isLive = YES;
    self.liveBtn.selected = YES;
    
    [self liveBtnClicked:self.liveBtn];
}
- (IBAction)liveBtnClicked:(UIButton *)sender {
    self.isLive = YES;
    sender.selected = YES;
    self.recordBtn.selected = NO;
}
- (IBAction)recordBtnClicked:(UIButton *)sender {
    self.isLive = NO;
    sender.selected = YES;
    self.liveBtn.selected = NO;
}

- (IBAction)scanQR:(id)sender {
    EVScanQRViewController *scanVC = [EVScanQRViewController new];
    __weak typeof(self) wSelf = self;
    scanVC.getQrCode = ^(NSString *string) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (string.length > 0) {
            sSelf.liveVidField.text = string;
        }
    };
    [self presentViewController:scanVC animated:YES completion:nil];
}
- (IBAction)watchVideo:(id)sender {
    NSString *segueStr = kEVWatchLive;
    
    if (self.isLive == false) {
        segueStr = kEVWatchRecord;
    }
    
    if (self.liveVidField.text.length == 0) {
        [[CCAlertManager shareInstance] performComfirmTitle:@"提示" message:@"未输入lid！" cancelButtonTitle:nil comfirmTitle:@"ok" WithComfirm:nil cancel:nil];
        return;
    }
    [self performSegueWithIdentifier:segueStr sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *vid = self.liveVidField.text;
    if ([segue.identifier isEqualToString:kEVWatchLive]) {
        EVDemoWatchViewController * watchVC = segue.destinationViewController;
        watchVC.vid = vid;
    } else if ([segue.identifier isEqualToString:kEVWatchRecord]) {
        EVDemoWatchRecordViewController *recordVC = segue.destinationViewController;
        recordVC.vid = vid;
    }
}

@end

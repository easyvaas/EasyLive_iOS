//
//  EVScanQRViewController.h
//  EVSDKDemo
//
//  Created by Lcrnice on 17/5/5.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVScanQRViewController : UIViewController

@property (nonatomic, copy) void (^getQrCode)(NSString *stringQR);

@end


/*
 * usage
 
 EVScanQRViewController *scanVC = [EVScanQRViewController new];
 __weak typeof(self) wSelf = self;
 scanVC.getQrCode = ^(NSString *string) {
     __strong typeof(wSelf) sSelf = wSelf;
     if (string.length > 0) {
         <#handle string#>
     }
 };
 [self presentViewController:scanVC animated:YES completion:nil];
 
*/

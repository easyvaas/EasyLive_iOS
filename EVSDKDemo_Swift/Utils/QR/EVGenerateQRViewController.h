//
//  EVGenerateQRViewController.h
//  EVSDKDemo
//
//  Created by Lcrnice on 17/5/5.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVGenerateQRViewController : UIViewController

@property (nonatomic, copy) NSString *infoString;

@end


/*
 * usage
 
 EVGenerateQRViewController *QRVC = [EVGenerateQRViewController new];
 QRVC.infoString = <#your vid string#>;
 [self presentViewController:QRVC animated:YES completion:nil];
 
*/

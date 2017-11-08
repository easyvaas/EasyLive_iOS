//
//  EVShareViewController.h
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/7/28.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVShareViewController : UIViewController

@property (nonatomic, copy) NSString *urlString;

+ (instancetype)instanceVC;
- (void)showInViewController:(UIViewController *)parentViewController;

@end

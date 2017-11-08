//
//  EVConfigBeatyLevelViewController.h
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/6/21.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVConfigBeautyLevelViewController : UIViewController

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isBeautyEnable;
@property (nonatomic, copy) void(^segValueChanged)(NSInteger index);
@property (nonatomic, copy) void(^switchValueChanged)(BOOL YorN);

+ (instancetype)instanceVC;
- (void)showInViewController:(UIViewController *)parentViewController;

@end

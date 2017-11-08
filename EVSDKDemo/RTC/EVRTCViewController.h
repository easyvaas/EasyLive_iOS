//
//  EVRTCViewController.h
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/7/11.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EVRTCFramework/EVRTCConfig.h>

@interface EVRTCViewController : UIViewController

@property (copy, nonatomic) NSString *roomName;
@property (nonatomic, assign) EVRtcClientRole role;
@property (nonatomic, assign) EVRtcVideoProfile profile;

@end

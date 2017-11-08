//
//  EVScreenManager.h
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/7/15.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVScreenManager : NSObject

@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;

+ (instancetype)share;
- (void)setDeviceOrientationTo:(UIDeviceOrientation)orientation;

@end

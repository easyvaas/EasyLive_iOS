//
//  EVScreenManager.m
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/7/15.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import "EVScreenManager.h"

@implementation EVScreenManager

+ (instancetype)share {
    static EVScreenManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [EVScreenManager new];
    });
    
    return manager;
}

- (void)setDeviceOrientationTo:(UIDeviceOrientation)orientation {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    self.fullScreen = UIDeviceOrientationIsLandscape(orientation);
    
    @try {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortraitUpsideDown]
                                    forKey:@"orientation"];
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:orientation]
                                    forKey:@"orientation"];
    }
    @catch (NSException *exception) {
        NSLog(@"转屏错误：%@", exception);
    }
}

@end

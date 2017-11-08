//
//  VideoViewLayouter.h
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/7/12.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoSession.h"

@interface VideoViewLayouter : NSObject

- (void)layoutSessions:(NSArray<VideoSession *> *)sessions
           fullSession:(VideoSession *)fullSession
           inContainer:(UIView *)container;
- (VideoSession *)responseSessionOfGesture:(UIGestureRecognizer *)gesture
                                inSessions:(NSArray<VideoSession *> *)sessions
                           inContainerView:(UIView *)container;

@end

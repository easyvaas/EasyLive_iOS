//
//  EVRTCVideoRegion.h
//  EVRTC
//
//  Created by Lcrnice on 2017/7/4.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVRTCConfig.h"

@interface EVRTCVideoRegion : NSObject

@property (assign, nonatomic) NSUInteger uid;
@property (assign, nonatomic) double x;
@property (assign, nonatomic) double y;
@property (assign, nonatomic) double width;
@property (assign, nonatomic) double height;
@property (assign, nonatomic) NSInteger zOrder;     //optional, [0, 100] //0 (default): bottom most, 100: top most
@property (assign, nonatomic) double alpha;         //optional, [0, 1.0] where 0 denotes throughly transparent, 1.0 opaque
@property (assign, nonatomic) EVRtcRenderMode renderMode;

@end

//
//  EVProgressView.h
//  EVSDKDemo
//
//  Created by Lcrnice on 17/5/12.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EVProgressView;

typedef void(^DragingSliderCallback)(EVProgressView *progressView, float progress);

@interface EVProgressView : UIView

@property (nonatomic) float totalTimeInSeconds;
@property (nonatomic) float cacheProgress;
@property (nonatomic) float playProgress;
@property (nonatomic, copy) DragingSliderCallback dragingSliderCallback;

@end

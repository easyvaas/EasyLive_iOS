//
//  VideoSession.h
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/7/12.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoSession : NSObject

@property (assign, nonatomic) NSUInteger uid;
@property (strong, nonatomic) UIView *hostingView;
@property (nonatomic, assign, readonly) BOOL isLocal;

- (instancetype)initWithUID:(NSUInteger)uid;
@end

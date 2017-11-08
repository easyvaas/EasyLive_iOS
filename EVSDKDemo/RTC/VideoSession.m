//
//  VideoSession.m
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/7/12.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import "VideoSession.h"

@implementation VideoSession

- (instancetype)initWithUID:(NSUInteger)uid {
    if (self = [super init]) {
        self.uid = uid;
        
        if (uid == 0) {
            _isLocal = YES;
        }
        
        self.hostingView = [[UIView alloc] init];
        self.hostingView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return self;
}

@end

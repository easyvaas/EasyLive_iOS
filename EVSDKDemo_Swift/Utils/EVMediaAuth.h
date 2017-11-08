//
//  EVMediaAuth.h
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/7/25.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVMediaAuth : NSObject

+ (void)checkAndRequestMicPhoneAndCameraUserAuthed:(void(^)())userAuthed
                                          userDeny:(void(^)())userDeny;

@end

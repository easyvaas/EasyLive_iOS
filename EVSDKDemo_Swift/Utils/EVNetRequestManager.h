//
//  EVNetRequestManager.h
//  EVSDKDemo
//
//  Created by mashuaiwei on 16/8/12.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVNetRequestManager : NSObject

+ (NSURLSessionDataTask *)httpGetWithUrl:(NSString *)url moreHeaders:(NSDictionary *)moreHeaders success:(void(^)(NSDictionary *info))successBlock failure:(void(^)(NSError *err))failureBlock;

@end

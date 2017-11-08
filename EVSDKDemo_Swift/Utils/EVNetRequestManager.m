//
//  EVNetRequestManager.m
//  EVSDKDemo
//
//  Created by mashuaiwei on 16/8/12.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#import "EVNetRequestManager.h"

@implementation EVNetRequestManager

+ (NSURLSessionDataTask *)httpGetWithUrl:(NSString *)url moreHeaders:(NSDictionary *)moreHeaders success:(void(^)(NSDictionary *))successBlock failure:(void(^)(NSError *))failureBlock{
    return [self netRequestWithUploadData:nil url:url moreHeaders:moreHeaders httpMethod:@"GET" success:^(NSData *data) {
        NSError *jsonErr = nil;
        NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonErr];
        if (jsonErr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(jsonErr);
            });
        } else if (successBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                successBlock(info);
            });
        }
    } failure:^(NSError *err) {
        if (failureBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock(err);
            });
        }
    }];
}

+ (NSURLSessionDataTask *)netRequestWithUploadData:(NSData *)data url:(NSString *)url moreHeaders:(NSDictionary *)moreHeaders httpMethod:(NSString *)httpMethod success:(void(^)(NSData *))successBlock failure:(void(^)(NSError *))failureBlock{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = 4;
    request.HTTPMethod = httpMethod;
    NSMutableDictionary *originHeader = [NSMutableDictionary dictionaryWithDictionary:request.allHTTPHeaderFields];
    [moreHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [originHeader setValue:obj forKey:key];
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            [originHeader setValue:[obj stringValue] forKey:key];
        } else {
            [originHeader setValue:[NSString stringWithFormat:@"%@", obj] forKey:key];
        }
    }];
    request.allHTTPHeaderFields = originHeader;
    request.HTTPBody = data;
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }else{
            NSInteger statusCode = [httpResponse statusCode];
            if ( statusCode == 200) {
                if (successBlock) {
                    successBlock(data);
                }
            } else {
                NSString *detail = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary *info  = nil;
                if (detail) {
                    info = @{
                             @"info" : detail,
                             };
                }
                NSError *err = [NSError errorWithDomain:@"EVSDKDemoDomain" code:statusCode userInfo:info];
                if (failureBlock) {
                    failureBlock(err);
                }
            }
        }
    }];
    [task resume];
    
    return task;
}

@end

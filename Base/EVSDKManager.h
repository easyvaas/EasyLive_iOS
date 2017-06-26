//
//  EVSDKManager.h
//  EVBaseTool
//
//  Created by mashuaiwei on 16/7/25.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability-completeness"

FOUNDATION_EXTERN NSString * const EVSDKInitSuccessNotification;
FOUNDATION_EXTERN NSString * const EVSDKInitErrorNotification;

@interface EVSDKManager : NSObject

/**
 *  初始化SDK（建议在用户登录成功后调用, 用户重新登录后则需要重新注册）
 *
 *  @param appID        注册的 app ID
 *  @param appKey       注册的 app key
 *  @param appSecret    注册的 app secret
 *  @param userid       用户唯一标识符（无需与真实账号一致，但必须是一一映射关系）
 */
+ (void)initSDKWithAppID:(NSString *__nonnull)appID
                  appKey:(NSString *__nonnull)appKey
               appSecret:(NSString *__nonnull)appSecret
                  userID:(NSString *__nonnull)userID;

/**
 *  获取 app id
 */
+ (NSString *)appID;

/**
 *  获取 app key
 */
+ (NSString *)appKey;

/**
 *  获取 app secret
 */
+ (NSString *)appSecret;

/**
 *  获取 user data
 */
+ (NSString *)userID;

/**
 *  查看 SDK 是否成功初始化
 */
+ (BOOL)isSDKInitedSuccess;

@end

#pragma clang diagnostic pop

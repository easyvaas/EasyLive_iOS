//
//  EVMessageProtocol.h
//  EVMessage
//
//  Created by mashuaiwei on 16/7/10.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVMessageConfig.h"

@protocol EVMessageProtocol <NSObject>

@required
/**
 *  消息服务器连接成功
 */
- (void)EVMessageConnected;

/**
 *  消息服务器连接失败
 *
 *  @param error 失败原因
 */
- (void)EVMessageConnectError:(NSError *)error;

@optional
/**
 *  断开连接
 *
 *  @param code   错误码
 *  @param reason 原因
 */
- (void)EVMessageDidCloseWithCode:(EVMessageErrorCode)code
                           reason:(NSString *)reason;

/**
 *  接收到新消息
 *
 *  @param channel  频道
 *  @param userid   用户 id
 *  @param message  消息内容
 *  @param userData 自定义消息
 */
- (void)EVMessageRecievedNewMessageInChannel:(NSString *)channel
                                  sendedFrom:(NSString *)userid
                                     message:(NSString *)message
                                    userData:(NSDictionary *)userData;

/**
 *  有用户加入频道
 *
 *  @param userids 加入的用户
 *  @param channel 频道
 */
- (void)EVMessageUsers:(NSArray <NSString *>*)userids
           joinedChannel:(NSString *)channel;

/**
 *  有用户从频道离开
 *
 *  @param userids 离开的用户
 *  @param channel 频道
 */
- (void)EVMessageUsers:(NSArray <NSString *>*)userids
           leftChannel:(NSString *)channel;

/**
 *  更新点赞数
 *
 *  @param likeCount 更新后的点赞数
 *  @param channel   频道
 */
- (void)EVMessageDidUpdateLikeCount:(long long)likeCount
                          inChannel:(NSString *)channel;

/**
 *  更新正在观看数
 *
 *  @param watchingCount 更新后的正在观看数
 *  @param channel       频道
 */
- (void)EVMessageDidUpdateWatchingCount:(NSInteger)watchingCount
                              inChannel:(NSString *)channel;

/**
 *  更新观看人次
 *
 *  @param watchedCount 更新后的观看人次
 *  @param channel      频道
 */
- (void)EVMessageDidUpdateWatchedCount:(NSInteger)watchedCount
                             inChannel:(NSString *)channel;



@end

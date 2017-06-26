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
 *  @param topic    话题
 *  @param userid   用户 id
 *  @param message  消息内容
 *  @param userData 自定义消息
 */
- (void)EVMessageRecievedNewMessageInTopic:(NSString *)topic
                               sendedFrom:(NSString *)userid
                                  message:(NSString *)message
                                 userData:(NSDictionary *)userData;

/**
 *  有用户加入话题
 *
 *  @param userids 加入的用户
 *  @param topic   话题
 */
- (void)EVMessageUsers:(NSArray <NSString *>*)userids
           joinedTopic:(NSString *)topic;

/**
 *  有用户从话题离开
 *
 *  @param userids 离开的用户
 *  @param topic   话题
 */
- (void)EVMessageUsers:(NSArray <NSString *>*)userids
             leftTopic:(NSString *)topic;

/**
 *  更新点赞数
 *
 *  @param likeCount 更新后的点赞数
 *  @param topic     话题
 */
- (void)EVMessageDidUpdateLikeCount:(long long)likeCount
                            inTopic:(NSString *)topic;

/**
 *  更新正在观看数
 *
 *  @param watchingCount 更新后的正在观看数
 *  @param topic         话题
 */
- (void)EVMessageDidUpdateWatchingCount:(NSInteger)watchingCount
                                inTopic:(NSString *)topic;

/**
 *  更新观看人次
 *
 *  @param watchedCount 更新后的观看人次
 *  @param topic        话题
 */
- (void)EVMessageDidUpdateWatchedCount:(NSInteger)watchedCount
                               inTopic:(NSString *)topic;



@end

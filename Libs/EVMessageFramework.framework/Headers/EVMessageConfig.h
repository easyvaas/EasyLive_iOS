//
//  EVMessageConfig.h
//  EVMessage
//
//  Created by mashuaiwei on 16/8/9.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#ifndef EVMessageConfig_h
#define EVMessageConfig_h
/**
 *  消息模块错误码
 */
typedef NS_ENUM(NSInteger, EVMessageErrorCode) {
    EVMessageErrorNone = 0,                     /**< 无错误 */
    
    EVMessageErrorNetworkTimeout = -1001,       /**< 连接超时 */
    EVMessageErrorNetworkInvalidURL = -1002,    /**< URL 错误 */
    EVMessageErrorNetworkNotConnect = -1003,    /**< 未连接 */
    EVMessageErrorNetworkUnkown = -1104,        /**< 未知网络错误 */
    
    EVMessageErrorSDKNotInit = -2001,           /**< SDK 未初始化或初始化不成功 */
    
    EVMessageErrorInternalServer = -3001,       /**< 消息服务器内部错误 */
    EVMessageErrorPermissionDenied = -3002,     /**< 没有权限 */
    EVMessageErrorJoinChannel = -3003,          /**< 加入频道失败 */
    EVMessageErrorSend = -3004,                 /**< 发送失败 */
    EVMessageErrorShutuped = -3005,             /**< 被禁言 */
};

typedef NS_ENUM(NSUInteger, EVMessageOperationCode) {
    EVMessageOperationNone = 0,
    EVMessageOperationSet,
    EVMessageOperationDelete,
};

typedef NS_OPTIONS(NSUInteger, EVMessageType) {
  EVMessageTypeAll      = 0,
  EVMessageTypeMsg      = 1 << 0,
  EVMessageTypeSystem   = 1 << 1,
  EVMessageTypeGift     = 1 << 2,
  EVMessageTypeRedPack  = 1 << 3
};

typedef NS_ENUM(NSUInteger, EVMessageLevel) {
    EVMessageLevel_0 = 0,
    EVMessageLevel_1,
    EVMessageLevel_2,
    EVMessageLevel_3,
    EVMessageLevel_4,   // default level
    EVMessageLevel_5,
    EVMessageLevel_6,
    EVMessageLevel_7,
    EVMessageLevel_8,
    EVMessageLevel_9,
    EVMessageLevel_10
};

#endif /* EVMessageConfig_h */

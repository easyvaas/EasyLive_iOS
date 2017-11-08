//
//  EVRTCConfig.h
//  EVRTC
//
//  Created by Lcrnice on 2017/7/4.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#ifndef EVRTCConfig_h
#define EVRTCConfig_h

typedef NS_ENUM(NSInteger, EVRtcClientRole) {
    EVRtc_ClientRole_Master = 0,        /**< 主播 */
    EVRtc_ClientRole_LiveGuest = 1,     /**< 连麦观众 */
    EVRtc_ClientRole_Guest = 2,         /**< 观众 */
};

typedef NS_ENUM(NSUInteger, EVRtcOfflineReason) {
    EVRtc_UserOffline_Quit = 0,
    EVRtc_UserOffline_Dropped = 1,
    EVRtc_UserOffline_BecomeAudience = 2,
};

typedef NS_ENUM(NSUInteger, EVRtcRenderMode) {
    EVRtc_Render_Hidden = 1,                /**< 裁剪画面，填充显示 */
    EVRtc_Render_Fit = 2,                   /**< 不裁剪画面，自适应视图 */
    EVRtc_Render_Adaptive = 3,              /**< 如果屏幕方向一致，则等同于 AgoraRtc_Render_Hidden；屏幕方向不一致，则等同于 AgoraRtc_Render_Fit */
};

typedef NS_ENUM(NSInteger, EVRtcVideoStreamType) {
    EVRtc_VideoStream_High = 0,             /**< 高清晰度，默认*/
    EVRtc_VideoStream_Low = 1,              /**< 低清晰度 */
};

typedef NS_ENUM(NSInteger, EVRtcResponseCode) {
    EVRtcResponseCode_None = 0,                 /**< 无错误 */
    EVRtcResponseCode_Server = -1004,           /**< SDK 内部网络请求错误 */
    EVRtcResponseCode_NoAppId = -2002,          /**< 获取 App id 失败 */
    EVRtcResponseCode_Core = -4000,             /**< 核心处理模块错误 */
    EVRtcResponseCode_NoRtcId = -4001,          /**< 没有传入连麦 id */
    EVRtcResponseCode_NoCanvasView = -4002,     /**< 没有传入画布视图 */
    EVRtcResponseCode_NotTheMaster = -4003,     /**< 操作用户不是 master */
    EVRtcResponseCode_NoRegions = -4004,        /**< 没有传入 Regions 数组 */
    EVRtcResponseCode_NoChannel = -4005,        /**< 没有传入频道字符串 */
    EVRtcResponseCode_MasterExit = -4006,       /**< 主播退出了频道 */
    EVRtcResponseCode_GuestExceeded = -4007,    /**< 连麦观众超出了6个 */
};

typedef NS_ENUM(NSInteger, EVRtcVideoProfile) {
    EVRtcVideoProfile_320x180 = 0,          /**< 流畅 */
    EVRtcVideoProfile_640x360,              /**< 标清(默认) */
    EVRtcVideoProfile_1280x720,             /**< 高清 */
};

#endif /* EVRTCConfig_h */

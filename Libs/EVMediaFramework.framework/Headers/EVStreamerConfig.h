//
//  EVStreamerConfig.h
//  EVCoreStreamer
//
//  Created by mashuaiwei on 16/7/28.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#ifndef EVStreamerConfig_h
#define EVStreamerConfig_h

// 直播端网络请求的结果码
typedef NS_ENUM(NSUInteger, EVStreamerResponseCode) {
    EVStreamerResponse_Okay = 0,
    EVStreamerResponse_error_sdkNotInitedOrInitedFailure = 1,           /**< 没有进行sdk初始化，或者sdk初始化失败 */
    EVStreamerResponse_error_sdkLiveRequestError,                       /**< 直播请求失败 */
    EVStreamerResponse_error_sdkNotLivePrepareOrPrepareFailure,         /**< 没有调用直播准备接口，或调用直播准备失败 */
    EVStreamerResponse_error_sdkNoLid,                                  /**< 没有设置 lid, lid 一定要在 liveStart 之前设置 */
    EVStreamerResponse_error_sdkNoURI,                                  /**< 没有设置URI, URI 一定要在 liveStart 之前设置 */
    EVStreamerResponse_error_sdkInitHardware,                           /**< 初始化硬件错误 */
};

// 视频编码器类型
typedef NS_ENUM(NSUInteger, EVVideoCodec) {
    /// 视频编码器 - h264 软件编码器
    EVVideoCodec_X264 = 0,
    /// 视频编码器 - KSY265 软件编码器
    EVVideoCodec_QY265,
    /// 视频编码器 - iOS VT264硬件编码器 (iOS 8.0以上支持)
    EVVideoCodec_VT264,
    /// 视频编码器 - 由SDK自动选择（ VT264 > X264）
    EVVideoCodec_AUTO = 100,
    /// 视频编码器 - gif
    EVVideoCodec_GIF,
};

// 直播场景
typedef NS_ENUM(NSUInteger, EVLiveScene) {
    /// 默认通用场景(不确定场景时使用)
    EVLiveScene_Default = 0,
    /// 秀场场景, 主播上半身为主
    EVLiveScene_Showself,
    /// 游戏场景
    EVLiveScene_Game,
};

// 音效类型
typedef NS_ENUM(NSUInteger, EVAudioEffectType){
    /// 初始化时状态为空闲
    EVAudioEffectType_NONE = 0,
    /// 大叔
    EVAudioEffectType_MALE,
    /// 萝莉
    EVAudioEffectType_FEMALE,
    /// 宏大
    EVAudioEffectType_HEROIC,
    /// 机器人
    EVAudioEffectType_ROBOT,
};

// 编码输出视频的size
typedef NS_ENUM(NSUInteger, EVStreamFrameSize) {
    EVStreamFrameSize_default = 0,
    EVStreamFrameSize_360x640 = EVStreamFrameSize_default,
    EVStreamFrameSize_540x960,
    EVStreamFrameSize_720x1280,
};

// 音频上传码率(单位：kbps)
typedef NS_ENUM(NSUInteger, EVStreamerAudioBitrate) {
    EVStreamerAudioBitrate_32 = 32,
    EVStreamerAudioBitrate_48 = 48,
    EVStreamerAudioBitrate_64 = 64,
    EVStreamerAudioBitrate_128 = 128,
};

// 采集尺寸
typedef NS_ENUM (NSInteger, EVStreamerVideoFrameSize)
{
    EVStreamerVideoFrameSize_192x144 = 1,
    EVStreamerVideoFrameSize_320x240,
    EVStreamerVideoFrameSize_480x360,
    EVStreamerVideoFrameSize_640x480,
    EVStreamerVideoFrameSize_1280x720,
    EVStreamerVideoFrameSize_1920x1080
};

/**
 视频推流状态
 
 - EVVideoStreamerStreamIdle: 闲置状态，即未推流
 - EVVideoStreamerStreamConnecting: 连接视频流服务器中
 - EVVideoStreamerStreamConnected: 连上了视频流服务器
 - EVVideoStreamerStreamDisconnecting: 与视频服务器断开连接
 - EVVideoStreamerStreamError: 推流失败/出错
 */
typedef NS_ENUM(NSUInteger, EVVideoStreamerState) {
    EVVideoStreamerStreamIdle = 0,
    EVVideoStreamerStreamConnecting,
    EVVideoStreamerStreamConnected,
    EVVideoStreamerStreamDisconnecting,
    EVVideoStreamerStreamError,
};


/**
 视频发送缓冲区状态
 
 - EVVideoStreamerStreamBufferStateNormal: 正常状态，发送缓冲区基本无数据
 - EVVideoStreamerStreamBufferStateLv1: 大概有4s的待发数据, network bad
 - EVVideoStreamerStreamBufferStateLv2: 大概有10s的待发数据, network worse
 - EVVideoStreamerStreamBufferStateLv3: 持续5s保持在EVVideoStreamerStreamBufferStateLv2状态, network worst
 */
typedef NS_ENUM(NSUInteger, EVVideoStreamerStreamBufferState) {
    EVVideoStreamerStreamBufferStateNormal = 0,
    EVVideoStreamerStreamBufferStateLv1,
    EVVideoStreamerStreamBufferStateLv2,
    EVVideoStreamerStreamBufferStateLv3,
};

typedef NS_ENUM(NSUInteger, CCVideoEncodeQuality) {
    CCVideoEncodeQualityLow,
    CCVideoEncodeQualityBalance,
    CCVideoEncodeQualityHigh,
};


/**
 连麦状态

 - EVVideoChatStateIdle: 闲置状态，即未连麦
 - EVVideoChatStateChannelJoining: 正在加入房间，即正在连麦
 - EVVideoChatStateChannelJoined: 已经加入房间，即已经连上
 - EVVideoChatStateRemoteVideoRendered: 远程传过来的画面已经得到了渲染
 - EVVideoChatStateChannelLeaving: 离开房间
 - EVVideoChatStateChannelLeaved: 已离开房间
 */
typedef NS_ENUM(NSUInteger, EVVideoChatState) {
    EVVideoChatStateIdle = 0,
    EVVideoChatStateChannelJoining,
    EVVideoChatStateChannelJoined,
    EVVideoChatStateRemoteVideoRendered,
    EVVideoChatStateChannelLeaving,
    EVVideoChatStateChannelLeaved,
};

// 音乐的播放状态
typedef NS_ENUM(NSUInteger, EVAudioPlayerState) {
    EVAudioPlayerStateNoPlaying,            /**< 未播放 */
    EVAudioPlayerStatePlayPreparing,        /**< 播放准备中 */
    EVAudioPlayerStatePlaying,              /**< 正在播放 */
    EVAudioPlayerStatePlayFailure,          /**< 播放失败 */
    EVAudioPlayerStateInterrupted,          /**< 播放被中断 */
    EVAudioPlayerStatePlayComplete,         /**< 播放完成 */
    EVAudioPlayerStateStopped,              /**< 播放停止 */
    EVAudioPlayerStatePaused,               /**< 暂停 */
};

#endif /* EVStreamerConfig_h */

//
//  EVPlayerConfig.h
//  EVCorePlayer
//
//  Created by mashuaiwei on 16/7/31.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#ifndef EVPlayerConfig_h
#define EVPlayerConfig_h

typedef NS_ENUM(NSInteger, EVPlayerState)
{
    EVPlayerStateUnknown,               /**< 未知状态 */
    EVPlayerStateBuffering,             /**< 缓冲中 */
    EVPlayerStatePlaying,               /**< 播放中 */
    EVPlayerStateComplete,              /**< 视频结束 */
    EVPlayerStateConnectFailed,         /**< 连接失败 */
};

/// 视频解码模式
typedef NS_ENUM(NSUInteger, EVMovieVideoDecoderMode) {
    // 视频解码方式采用软解
    EVMovieVideoDecoderMode_Software = 0,
    // 视频解码方式采用硬解
    EVMovieVideoDecoderMode_Hardware,
    // 自动选择解码方式，8.0以上的系统优先选择硬解
    EVMovieVideoDecoderMode_AUTO,
    // 使用系统接口进行解码和渲染，只适用于8.0及以上系统，低于8.0的系统自动使用软解
    EVMovieVideoDecoderMode_DisplayLayer,
};

typedef NS_ENUM(NSInteger, EVPlayerScalingMode) {
    EVPlayerScalingModeDefault,    // default is EVPlayerScalingModeFill
    EVPlayerScalingModeScaleCenter,// show scaling in center
    EVPlayerScalingModeAspectFit,  // Uniform scale until one dimension fits
    EVPlayerScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
    EVPlayerScalingModeFill = EVPlayerScalingModeDefault,       // Non-uniform scale. Both render dimensions will exactly match the visible bounds
};

typedef NS_ENUM(NSInteger, EVPlayerCacheState) {
    EVPlayerCacheStateCaching,      /**< 缓冲中 */
    EVPlayerCacheStateFinish        /**< 缓冲完毕 */
};

#endif /* EVPlayerConfig_h */

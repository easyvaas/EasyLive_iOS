//
//  EVPlayer.h
//  EVPlayer
//
//  Created by mashuaiwei on 16/8/1.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "EVPlayerConfig.h"
@class EVPlayer;

/**
 *  播放器准备阶段的响应码
 */
typedef NS_ENUM(NSUInteger, EVPlayerResponseCode) {
    EVPlayerResponse_Okay = 0,                                  /**< 观看请求成功 */
    EVPlayerResponse_error_sdkNotInitedOrInitedFailure = 1,     /**< 没有进行sdk初始化，或者sdk初始化失败 */
    EVPlayerResponse_error_sdkPlayRequestError,                 /**< 观看请求失败 */
    EVPlayerResponse_error_sdkNoPlayerContainerView,            /**< 没有设置视频显示的 container view */
    EVPlayerResponse_error_sdkNoLid,                            /**< 没有设置 lid */
};

typedef void(^EVPlayerCompleteBlock)(EVPlayerResponseCode responseCode, NSDictionary *result, NSError *err);


/**
 播放器的回调代理
 */
@protocol EVPlayerDelegate <NSObject>

@optional
/**
 视频第一帧被渲染

 @param player 播放器
 */
- (void)EVPlayerFirstVideoFrameDidRender:(EVPlayer *)player;

/**
 播放状态

 @param player 播放器
 @param state 状态值
 */
- (void)EVPlayer:(EVPlayer *)player playbackState:(NSInteger)state;

/**
 暗示重新加载

 @param player 播放器
 */
- (void)EVPlayerSeguestedToReload:(EVPlayer *)player;

/**
 播放结束

 @param player 播放器
 @param reason 结束原因
 */
- (void)EVPlayerDidFinishPlay:(EVPlayer *)player reason:(MPMovieFinishReason)reason;

/**
 播放器缓冲状态

 @param player 播放器
 @param state 缓冲状态
 */
- (void)EVPlayer:(EVPlayer *)player cacheState:(EVPlayerCacheState)state;

@end


@interface EVPlayer : NSObject

@property (nonatomic, strong) UIView *playerContainerView;                  /**< 播放器将会在此 view 上渲染播放画面,必须在调用 playPrepareComplete: 之前设置(必填) */
@property (nonatomic, assign) EVMovieVideoDecoderMode videoDecoderMode;     /**< 设置视频解码方式 default = EVMovieVideoDecoderMode_AUTO (需要在 -prepare 之前配置)*/
@property (nonatomic, assign) NSTimeInterval bufferTimeMax;                 /**< 指定播放时的缓冲时长，单位秒. 直播流 default = 2，点播流 default = 3600 (需要在 -prepare 之前配置) */
@property (nonatomic, assign) int rotateDegress;                            /**< 指定逆时针旋转角度，只能是0/90/180/270, 不符合上述值不进行旋转 */
@property (nonatomic, assign) BOOL live;                                    /**< 是否是直播（必填） */
@property (nonatomic, assign) BOOL shouldMute;                              /**< 是否静音 */
@property (nonatomic, assign) BOOL shouldHideVideo;                         /**< 是否隐藏视频，隐藏视频时播放器本身不再进行渲染动作 */
@property (nonatomic, assign) BOOL mirror;                                  /**< 是否镜像显示视频 */
@property (nonatomic, assign) CGRect playerViewFrame;                       /**< 播放器视图的 frame */
@property (nonatomic, copy) NSString *lid;                                  /**< 流 id (必填) */
@property (nonatomic, copy) NSString *playURLString;                        /**< 播放地址（lid 为空时，才会进行 url 的逻辑，两者只能用其一） */
@property (nonatomic, weak) id<EVPlayerDelegate> delegate;                  /**< 代理回调 */
@property (nonatomic, readonly) NSTimeInterval duration;                    /**< 总回放的时长（单位：s） */
@property (nonatomic, readonly) NSTimeInterval playableDuration;            /**< 可播放的时长，即缓冲时长（单位：s） */
@property (nonatomic, readonly) NSInteger bufferingProgress;                /**< 缓冲百分比（单位：1，完全缓冲为100）(deprecated) */
@property (nonatomic) NSTimeInterval currentPlaybackTime;                   /**< 当前回放到的时刻，设置它可以改变回放的进度（单位：s） */
@property (nonatomic) MPMovieScalingMode scalingMode;                       /**< 缩放模式，default is MPMovieScalingModeAspectFit */
@property (nonatomic, copy) void(^videoDataBlock)(CMSampleBufferRef pixelBuffer);   /**< 视频数据回调 */
@property (nonatomic, copy) void(^audioDataBlock)(CMSampleBufferRef sampleBuffer);  /**< 音频数据回调 */

/**
 *  播放准备阶段
 *
 *  @param complete 准备完成的回调
 */
- (void)playPrepareComplete:(EVPlayerCompleteBlock)complete;

/**
 *  开始播放(在 playPrepareComplete: 成功（收到 EVPlayerResponse_Okay）后方可调用)
 */
- (void)play;

/**
 *  暂停播放
 */
- (void)pause;

/**
 *  停止播放
 */
- (void)shutDown;

/**
 当前时刻的视频截图
 
 @return 截图
 */
- (UIImage *)thumbnailImageAtCurrentTime;

/**
 重载
 
 @param aUrl 重载地址
 */
- (void)reload:(NSURL *)aUrl;

/**
 重载
 
 @param aUrl 重载地址
 @param flush 是否清空缓存（清空画面会跳跃）
 */
- (void)reload:(NSURL *)aUrl flush:(BOOL)flush;

/**
 设置手机竖屏模式下横屏播放
 */
- (void)setVideoPlayInHorizonMode;

/**
 是否显示横屏视频

 @param YorN 是否
 */
- (void)showHorizonVideo:(BOOL)YorN;

/**
 跳转到制定播放位置（精准定位，适用于媒体文件总时长较小且关键帧间隔较大时）

 @param pos 跳转到的位置，单位秒
 */
- (void)seekTo:(double)pos;

/**
 指定播放器输出音量

 @param volume scalar [0~2.0f] (输入参数超出范围将失效)
 */
- (void)setVolume:(float)volume;

/**
 获取 EVPlayer 版本号
 
 @return 版本号
 */
+ (NSString *)getVersion;

@end

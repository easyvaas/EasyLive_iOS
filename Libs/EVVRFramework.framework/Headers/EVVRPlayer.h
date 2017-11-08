//
//  EVVRPlayer.h
//  EVVR
//
//  Created by Lcrnice on 2017/7/18.
//  Copyright © 2017年 Easyvaas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EVVRPlayerMode) {
    EVVRPlayerModeDefualt = 0,
    EVVRPlayerModeGyroSingle = EVVRPlayerModeDefualt,   /**< 重力感应单画面 */
    EVVRPlayerModeGyroDuplicate,                        /**< 重力感应双画面 */
    EVVRPlayerModeFingerSingle,                         /**< 手动拖动单画面 */
    EVVRPlayerModeFingerDuplicate,                      /**< 手动拖动双画面 */
    EVVRPlayerModeGyroDuplicateHorizontal,              /**< 重力感应水平分割双画面 */
    EVVRPlayerModeFingerDuplicateHorizontal,            /**< 手动拖拽水平分割双画面 */
};

typedef NS_ENUM(NSUInteger, EVVRPlayerStatus) {
    EVVRPlayerStatusUnknown,
    EVVRPlayerStatusPrepared,
    EVVRPlayerStatusPlaying,
    EVVRPlayerStatusBuffering,
    EVVRPlayerStatusPaused,
    EVVRPlayerStatusStopped,
    EVVRPlayerStatusEnd,
    EVVRPlayerStatusFailed,
};

typedef NS_ENUM(NSUInteger, EVVRContentType) {
    EVVRContentTypeVideo,
    EVVRContentTypePicture
};

@protocol EVVRPlayerDelegate;


@interface EVVRPlayer : NSObject

@property (nonatomic, weak, readonly) UIView *renderView;       /**< 渲染视图 */
@property (nonatomic, readonly) double duration;                /**< 视频时长 */
@property (nonatomic, weak) id<EVVRPlayerDelegate> delegate;    /**< 代理 */
@property (nonatomic, readonly, strong) NSURL *playUrl;         /**< 视频播放地址 */
@property (nonatomic, assign) EVVRContentType contentType;      /**< 选择播放全景视频或图片  默认为“视频” */
@property (nonatomic, assign) EVVRPlayerMode mode;              /**< 视频播放的模式，默认为 EVVRPlayerModeGyroSingle */
@property (nonatomic, assign) BOOL isliving;                    /** 是否是直播 */

- (instancetype)init __attribute__((unavailable("call \"initVRPlayerWithURL:frame:\" instead")));
- (instancetype)initVRPlayerWithFrame:(CGRect)frame;

/**
 播放某个地址下的 VR 录播视频
 
 @param playUrl 视频地址
 */
- (void)playWithUrl:(NSString *)playUrl;

/**
 播放直播 VR 视频的方法， living = YES 时，会获取标定，没有获取到则不能正常播放

 @param playUrl 视频地址
 @param living 是否为直播
 */
- (void)playWithUrl:(NSString *)playUrl isliving:(BOOL)living;

/**
 暂停后调用
 */
- (void)play;

/**
 暂停
 */
- (void)pause;

/**
 停止播放
 */
- (void)stop;

/**
 关闭播放器
 */
- (void)shutdown;

/**
 跳到某处开始播放
 
 @param time 播放的时刻
 */
- (void)seekToTime:(double)time;

/**
 获取 EVVRPlayer 版本号

 @return 版本号
 */
+ (NSString *)getVersion;

@end


/**
 VR 播放器代理方法
 */
@protocol EVVRPlayerDelegate <NSObject>
@optional
- (void)evVRPlayer:(EVVRPlayer *)player updateCurrrentTime:(double)time;
- (void)evVRPlayer:(EVVRPlayer *)player status:(EVVRPlayerStatus)status;
- (void)evVRPlayerOnLoading:(EVVRPlayer *)player;
- (void)evVRPlayerOnloaded:(EVVRPlayer *)player;

@end

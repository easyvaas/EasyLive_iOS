//
//  EVStreamer.h
//  EVStreamer
//
//  Created by mashuaiwei on 16/7/27.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EVStreamerConfig.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^EVStreamerCompleteBlock)(EVStreamerResponseCode responseCode, NSDictionary *result, NSError *err);

@protocol EVStreamerDelegate <NSObject>

@optional
/**
 流状态变化

 @param state 变化后的状态值
 */
- (void)EVStreamerStreamStateChanged:(EVVideoStreamerState)state;

/**
 缓存区状态变化（反映出当前的网络情况）

 @param state 变化后的状态值
 */
- (void)EVStreamerBufferStateChanged:(EVVideoStreamerStreamBufferState)state;

/**
 连麦状态

 @param chatState 变化后的状态值
 */
- (void)EVStreamerUpdateVideoChatState:(EVVideoChatState)chatState;

/**
 背景音乐播放器状态

 @param state 变化后的状态值
 */
- (void)EVStreamerBGMPlayState:(EVAudioPlayerState)state;

@end

@interface EVStreamer : NSObject

@property (nonatomic, weak) id<EVStreamerDelegate> delegate;     /**< 代理 */
@property (nonatomic, assign) BOOL mute;                /**< 是否静音, 默认为 NO, 在此也可设置静音 */
@property (nonatomic, assign) BOOL frontCamera;         /**< 是否使用前置摄像头, 默认为 NO，闪光灯状态下切换前置摄像头不起作用 */
@property (nonatomic, assign) BOOL flashOn;             /**< 是否使用闪光灯, 默认为 NO，前置摄像头状态下设置闪关灯不起作用 */
@property (nonatomic, readonly, assign) EVVideoStreamerState state; /**< 推流状态 */
@property (nonatomic, readonly, assign) EVVideoStreamerStreamBufferState bufferState; /**< 视频发送缓冲区状态 */
@property (nonatomic, readonly, assign) NSInteger audioLength;  /**< 音频时长（单位：s） */
@property (nonatomic, readonly, assign) NSInteger videoLength;  /**< 视频时长 （单位：s）*/
@property (nonatomic, assign) BOOL previewMirrored;             /**< 预览设置成镜像模式，默认为NO */
@property (nonatomic, assign) BOOL streamerMirrored;            /**< 推流设置成镜像模式, 默认为NO */
@property (nonatomic, assign) EVAudioEffectType effectType;     /**< 音效类型 default = EVAudioEffectType_NONE */

#pragma mark - 直播

////////////////////// 以下参数要在 livePrepareComplete: 之前完成 ///////////////////

@property (nonatomic, weak) UIView *presentView;        /**< 画面渲染的 view，必填 (deprecated)*/
@property (nonatomic, readonly, weak) UIView *preview;  /**< 预览视图 view，必需添加到父视图中 */
@property (nonatomic, assign, readonly) NSUInteger fps; /**< 视频采集帧率:25 (deprecated)*/
@property (nonatomic, assign) NSUInteger captureFps;    /**< 视频采集帧率，默认为25，暂时不建议修改 */
@property (nonatomic, assign) EVStreamerVideoFrameSize captureFrameSize;    /**< 摄像头采集输出的分辨率 默认为 CCRecoderVideoFrameSize_1280x720 */
@property (nonatomic, assign) EVStreamFrameSize streamFrameSize;            /**< 上传到服务器的视频流，每帧的大小（宽高），默认为 CCRecorderStreamFrameSize_360x640 */
@property (nonatomic, assign) EVVideoCodec videoCodec;      /**< 视频编码器类型, default = EVVideoCodec_AUTO */
@property (nonatomic, assign) EVLiveScene liveScene;        /**< 本次直播的目标场景 default = EVLiveScene_Default */
@property (nonatomic, assign) NSUInteger videoBitrate;      /**< 视频初始化码率默认为 700 kbps, 然后会根据网络情况动态调整 */
@property (nonatomic, assign) NSUInteger maxVideoBitrate;   /**< 视频最大码率, 默认 800 kbps */
@property (nonatomic, assign) NSUInteger minVideoBitrate;   /**< 视频最小码率，默认 200 kbps */
@property (nonatomic, assign) EVStreamerAudioBitrate audioBitrate;          /**< 音频编码码率(单位：kbps), 默认为48 kpbs */
@property (nonatomic, assign) BOOL useHEAAC;            /**< 使用高质量 aac 编码 (deprecated) */
@property (nonatomic, assign) BOOL useHorizonMode;      /**< 是否开启横屏直播，如开启，则必须让屏幕处于 UIInterfaceOrientationLandscapeRight 状态 */
@property (nonatomic, assign) BOOL bStereoAudioStream;  /**< 立体声推流，目前只针对双声道的背景音乐有效 default = NO */


//////////////////////////////////////////////////////////////////////////////////

/**
 *  直播准备：初始化取景器,推流器
 *
 *  @param complete 准备完成的回调(只包含错误：sdk初始化、硬件初始化)
 */
- (void)livePrepareComplete:(EVStreamerCompleteBlock)complete;
/**
 开启预览
 */
- (void)startPreview;

/**
 关闭预览
 */
- (void)stopPreview;

//////////////////////// 以下参数要在 liveStartComplete: 之前完成 ////////////////////

@property (nonatomic, copy) NSString *URI;                  /**< 进行推流请求拼接的字符串（必填）(deprecated, 更改为只需要传 lid 与 key 两个参数) */
@property (nonatomic, copy) NSString *lid;                  /**< 视频 id (必填) */
@property (strong, nonatomic) UIImage *watermakLogoImage;   /**< 水印logo */
/**
 *  水印logo的相关信息
 *  @prama  key             value                       notation
 *          relativeFrame   CGRect(NSString)            图片相对于预览画面的frame
                            @discussion 水印logo的图片的位置和大小
                            @discussion 位置和大小的单位为预览视图的百分比, 左上角为(0,0), 右下角为(1.0, 1.0)
                            @discussion 如果宽为0, 则根据图像的宽高比, 和设置的高度比例, 计算得到宽度的比例
                            @discussion 如果高为0, 方法同上
 *          alpha           NSNumber                    透明度，0-1.0, 0为完全透明，1完全不透明 不设置的话默认使用 1
 *  example:
     NSDictionary *watermarkInfo = @{@"alpha": @(1),
                                     @"relativeFrame": NSStringFromCGRect(frame)};
 */
@property (strong, nonatomic) NSDictionary *watermakLogoInfo;


//////////////////////////////////////////////////////////////////////////////////

/**
 *  直播开始的请求
 *
 *  @param complete 请求完成的回调
 */
- (void)liveStartComplete:(EVStreamerCompleteBlock)complete;

/**
 *  开始推流(必须在 liveStartComplete: 回调的状态为 EVStreamerResponse_Okay 时调用才有作用)
    推流状态的回调 EVStreamerUpdateState:error:
    (deprecated)
 */
- (void)start;

/**
 开始推流(必须在 liveStartComplete: 回调的状态为 EVStreamerResponse_Okay 时调用才有作用)
 推流状态的回调 EVStreamerUpdateState:error:
 */
- (void)startStream;

/**
 *  暂停推流(deprecated)
 */
- (void)pause;

/**
 停止推流
 */
- (void)stopStream;

/**
 *  恢复推流(deprecated)
 */
- (void)resume;
/**
 重连
 */
- (void)retryConnect;

/**
 *  关闭推流
 */
- (void)shutDown;


#pragma mark - 辅助操作 以下操作必须在prepare之后才能生效

/**
 静音
 
 @param mute YES:静音 NO:非静音
 */
- (void)muteStream:(BOOL)mute;

/**
 *  当前摄像头最大的放大倍数(deprecated)
 *     4s 最大放大倍数是 1
 */
@property (nonatomic, assign, readonly) CGFloat maxZoomFactor;

/**
 *  当前摄像头最小的放大倍数(deprecated)
 *      通常从 1 开始, 4s 以下的从 0 开始
 */
@property (nonatomic, assign, readonly) CGFloat minZoomFactor;

/**
 *  缩放(deprecated, please change to cameraZoomWithFactor:)
 *      部分 4s 手机放大会失效
 *  @param zoomFactor 放大的倍数
 */
- (void)cameraZoomWithFactor:(CGFloat)zoomFactor
                        fail:(void(^)(NSError *error))failBlock;
- (void)cameraZoomWithFactor:(CGFloat)zoomFactor;

/**
 *  切换前后摄像头(deprecated, please change to swithCamera)
 *
 *  @param front YES,使用前置摄像头, NO 使用后置摄像头
 *  @param complete 切换完毕的回调, success == NO 可能是改设备只有一个摄像头可用
 */
- (void)switchCamera:(BOOL)front
            complete:(void(^)(BOOL success , NSError *error))complete;
- (BOOL)swithCamera;

/**
 *  定点对焦(deprecated, please change to focusAtPoint:)
 *
 *  @param location  焦点
 *  @param failBlock 对焦失败
 */
- (void)cameraWithLocation:(CGPoint)location
                      fail:(void(^)(NSError *focusError))failBlock;
- (BOOL)focusAtPoint:(CGPoint)point;

/**
 *  闪光灯开关
 *
 *  @param on YES 打开, NO,关闭
 */
- (void)turnOnFlashLight:(BOOL)on;

/**
 *  控制水印显示开关
 *
 *  @param on YES:开 NO:关
 */
- (void)enableWatermark:(BOOL)on;

/**
 *  获取当前是否开启了水印
 *
 *  @return YES:开 NO:关
 */
- (BOOL)isWatermakOn;

/**
 *  开启/关闭美颜
 *  注：美颜功能仅限 iPhone5s 以后的机型，并且 iOS8 以后系统使用
 *
 *  @param enabled YES:开启 / NO:关闭
 */
- (void)enableFaceBeauty:(BOOL)enabled;

/**
 设置美颜级别（只在开启美颜状态下有效）

 @param level 美颜级别 level [1, 5]，逐级增强, 默认为3
 */
- (void)configBeautyLevel:(NSInteger)level;

/**
 *  是否开启了美颜
 *
 *  @return YES:开启 / NO:关闭
 */
- (BOOL)isFaceBeautyEnabled;

/**
 *  截取画面
 */
- (void)getCapture:(void(^)(UIImage *image))imageBlock;

#pragma mark - raw data
/**
 @abstract      视频处理回调接口
 @discussion    sampleBuffer 原始采集到的视频数据
 */
@property(nonatomic, copy) void(^videoProcessingCallback)(CMSampleBufferRef sampleBuffer);

/**
 @abstract   音频处理回调接口
 @discussion sampleBuffer 原始采集到的音频数据
 */
@property(nonatomic, copy) void(^audioProcessingCallback)(CMSampleBufferRef sampleBuffer);

/**
 获取 EVStreamer 版本号
 
 @return 版本号
 */
+ (NSString *)getVersion;

///---------------------------
/// @name 连麦
///---------------------------
#pragma mark - 连麦
@property (nonatomic, copy) NSString *agoraAppid;  /**< 连麦的 appid, 一定要在调用 livePrepareComplete: 前设置 */

/**
 开始连麦(目前只支持iPhone6及iPhoneSE以上机型)(deprecated)
 
 @param isAnchor  是否是主播(YES:主播，NO:辅播)
 @param channelId 频道 id
 */
- (void)startInteractiveLiveAsAnchor:(BOOL)isAnchor channel:(NSString *)channelId;

/**
 结束连麦(deprecated)
 */
- (void)endInteractiveLive;

@property (nonatomic, assign) BOOL selfInFront;     /**< 主窗口小窗口切换 */
@property (nonatomic, readonly, assign) EVVideoChatState chatState; /**< 聊天状态 */
@property (nonatomic, readwrite) CGRect winRect;    /**< 连麦小后窗口图层的大小 ( 注:取值区间为[0,1] eg:CGRectMake(0, 0.7, 0.3, 0.3) ) */

/**
 连麦
 
 @param channel 房间号
 */
- (void)joinChannel:(NSString *)channel;

/**
 断开连麦
 */
- (void)leaveChannel;


///---------------------------
/// @name 背景音乐
///---------------------------
#pragma mark - BGM
@property (nonatomic, readonly, assign) EVAudioPlayerState BGMState;    /**< 是否正在播放 */
@property (nonatomic, assign) BOOL BGMSupportLoop;                      /**< 是否支持单曲循环 */
@property (nonatomic, assign) float BGMVolume;                          /**< 本地音乐的音量大小:0 - 1.0，不会印象观看端音量*/
@property (nonatomic, assign) double BGMPitch;                          /**< 音乐的音调，调整范围 [-24.0 ~ 24.0], 默认为0.01, 单位为半音。  0.01 为1度, 1.0为一个半音, 12个半音为1个八度 */
@property (nonatomic, readonly ,assign) CGFloat BGMCurrentPlayTime;     /**< 当前播放进度 */
@property (nonatomic, readonly, assign) CGFloat BGMDuration;            /**< 音频时长 */

/**
 开始播放本地音乐作为推流背景音乐

 @param filePath 本地音乐文件路径
 */
- (void)BGMPlayWithPath:(NSString *)filePath;

/**
 暂停播放
 */
- (void)BGMPause;

/**
 恢复播放
 */
- (void)BGMResume;

/**
 停止播放
 */
- (void)BGMStop;

/**
 背景音乐“混音”和“耳返”的开关
 @discribe 默认为混音状态，如果未插入耳机外放音乐时，观看端有声音重叠的感觉，可以通过关闭混音解决
 @warning  未插入耳机时，开启耳返会有很大噪音
 
 @param YorN 开关
 */
- (void)BGMTrackAndPlayCapturedAudioSwitch:(BOOL)YorN;

@end

//
//  EVRTCKit.h
//  EVRTC
//
//  Created by Lcrnice on 2017/7/5.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EVRTCConfig.h"

NS_ASSUME_NONNULL_BEGIN

@class EVRTCVideoRegion;
@protocol EVRTCDelegate;

typedef void(^EVRTCCallback)(EVRtcResponseCode code,  NSDictionary * _Nullable info, NSError * _Nullable error);


/**
 多人连麦类
 */
@interface EVRTCKit : NSObject

@property (nonatomic, weak) id<EVRTCDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isMaster;          /**< 获取是否为 Master */
@property (nonatomic, assign, readonly) NSUInteger masterUid;   /**< 当前频道主播 uid（默认 masterUid=9999999999，加入连麦成功后获取正确的频道主播 uid） */
@property (nonatomic, assign) EVRtcVideoProfile profile;        /**< 设置分辨率(需要在加入频道前设置) */

/**
 初始化方法

 @param rtcId 连麦 ID
 */
- (instancetype)initWithRTCID:(NSString *)rtcId;


#pragma mark - 频道操作

/**
 创建一个频道并加入（以 Master 身份加入）

 @param channel 频道（传入 nil 则自动生成）
 @param uid 自定义的唯一标示（传入 0 则自动生成）
 @param hasPublisher 是否进行旁路推流
 @param record 是否保存视频
 @param callback 处理事件回调
 */
- (void)createAndJoinChannel:(nullable NSString *)channel uid:(NSUInteger)uid hasPublisher:(BOOL)hasPublisher record:(BOOL)record callback:(EVRTCCallback)callback;

/**
 加入一个已创建的频道

 @param channel 频道（必传参数）
 @param uid 自定义的唯一标示（传入 0 则自动生成）
 @param callback 处理事件回调
 */
- (void)joinChannel:(NSString *)channel uid:(NSUInteger)uid callback:(EVRTCCallback)callback;

/**
 离开当前频道

 @return 返回 0 则成功，返回负数则表明出现异常
 */
- (int)leaveChannel;


#pragma mark - 连麦画面操作

/**
 配置本地画布

 @param view 显示画布所用的视图
 @param uid 当前操作用户的 uid
 @param mode 画布适配模式
 */
- (void)configCanvasWithView:(UIView *)view uid:(NSUInteger)uid mode:(EVRtcRenderMode)mode;

/**
 配置旁路推流画面中，各个画面的位置信息 （只有频道 Master 才有权限调用此方法）
 
 notice: 主播可以不调用此方法，SDK会使用默认的旁路推流布局，其中数字代表连麦观众显示的顺序，最外层为屏幕边缘，具体效果详见 Demo 运行效果
 --------------------------------
 |       |     4    |     1     |
 |       -----------------------|
 |       |     5    |     2     |
 |       -----------------------|
 |       |     6    |     3     |
 --------------------------------

 @param regions 位置信息数组
 */
- (void)configVideoRegion:(NSArray <EVRTCVideoRegion*> *)regions;

/**
 设置远端视频的清晰度

 @param uid 当前操作用户的 uid
 @param streamType 视频流清晰度
 */
- (void)configRemoteVideoStream:(NSUInteger)uid type:(EVRtcVideoStreamType)streamType;


#pragma mark - 获取观看多人连麦的视频流地址

/**
 获取直播中某频道的旁路推流地址

 @param channel 频道
 @param callback 处理事件回调
 */
- (void)watchLiveWithChannel:(NSString *)channel callback:(EVRTCCallback)callback;

/**
 获取录播中某频道的旁路推流地址（如果频道 Master 未保存视频流，则无法获取）

 @param channel 频道
 @param callback 处理事件回调
 */
- (void)watchRecordWithChannel:(NSString *)channel callback:(EVRTCCallback)callback;

/**
 获取特定频道分享地址，分享地址为H5，可播放直播视频

 @param channel 频道
 @param callback 处理事件回调
 */
- (void)fetchShareURLWithChannel:(NSString *)channel callback:(EVRTCCallback)callback;


#pragma mark - 连麦中操作

/**
 本地音频推流开关

 @param mute 是否关闭
 @return 返回 0 则成功，返回负数则表明出现异常
 */
- (int)muteLocalAudioStream:(BOOL)mute;

/**
 本地视频推流开关

 @param mute 是否关闭
 @return 返回 0 则成功，返回负数则表明出现异常
 */
- (int)muteLocalVideoStream:(BOOL)mute;

/**
 切换本地摄像头方向

 @return 返回 0 则成功，返回负数则表明出现异常
 */
- (int)switchCamera;

/**
 获取 EVRTC 版本号
 
 @return 版本号
 */
+ (NSString *)getVersion;

@end


#pragma mark - 多人连麦代理
@protocol EVRTCDelegate <NSObject>

@optional
- (void)evRTCKit:(EVRTCKit *)kit didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed;
- (void)evRTCKit:(EVRTCKit *)kit firstRemoteVideoDecodedOfUid:(NSUInteger)uid size:(CGSize)size elapsed:(NSInteger)elapsed;
- (void)evRTCKit:(EVRTCKit *)kit firstLocalVideoFrameWithSize:(CGSize)size elapsed:(NSInteger)elapsed;
- (void)evRTCKit:(EVRTCKit *)kit didAudioMuted:(BOOL)muted byUid:(NSUInteger)uid;
- (void)evRTCKit:(EVRTCKit *)kit didVideoMuted:(BOOL)muted byUid:(NSUInteger)uid;
- (void)evRTCKitConnectionDidInterrupted:(EVRTCKit *)kit;
- (void)evRTCKitConnectionDidLost:(EVRTCKit *)kit;
- (void)evRTCKit:(EVRTCKit *)kit didOfflineOfUid:(NSUInteger)uid reason:(EVRtcOfflineReason)reason;
- (void)evRTCKit:(EVRTCKit *)kit didOccurErrorWithCode:(NSInteger)errorCode;

@end
NS_ASSUME_NONNULL_END

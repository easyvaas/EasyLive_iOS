//
//  PanoPlayer.h
//  PanoPlayer
//
//  Created by qiruisun on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PanoPlayerUrl.h"
#import "GLPlayerView.h"
#import "PanoramaData.h"
#import "Hotspot.h"
#import "ManagerData.h"
#import "PanoPlayerOption.h"

#import "GLPlayerCore.h"

@class VrEventObjectManager;
@class HotpotManager;

typedef NS_ENUM(NSUInteger, PanoPlayerErrorCode) {
    PANO_PLAY_SUCCESS,
    PANO_SETTING_DATA_IS_EMPTY, //Settings为空
    PANO_PANORAMALIST_IS_EMPTY, //全景节点为空
    PANO_PLAY_PARSERERROR
};
typedef enum {
    STATUS_PLAYING,
    STATUS_PAUSE,
    STATUS_STOP,
    STATUS_FINISH,
    STATUS_BUFFER_EMPTY
}PanoVideoPluginStatus;

@protocol PanoPlayDelegate <NSObject>
-(void)PanoPlayOnLoading;
-(void)PanoPlayOnLoaded;
-(void)PanoPlayOnEnter:(PanoramaData*)curpanodata;//进入场景
-(void)PanoPlayonLeave:(PanoramaData*)prepanodata;//离开场景
@optional
-(void)PanoPlayOnError:(PanoPlayerErrorCode)e;
-(void)PanoPlayOnTapBeforeHotpot:(Hotspot*)hotspot;//点击热点响应前
-(void)PanoPlayOnTapAfterHotpot:(Hotspot*)hotspot;//点击热点后
@optional
-(void)PluginVideoOnStatusChanged:(PanoVideoPluginStatus)s;
-(void)PluginVideoOnProgessChanged;
-(void)PluginVideoOnSeekFinished;
-(void)PluginVideoOnPlayerError:(NSError *)e;
//统计数据
//key: "detu_video_bitrate" value:NSInteger类型，每秒图像的码率
//key: "detu_gop_size"      value:NSInteger类型，每秒B和P帧的总数量
-(void)PluginVideoOnStatisticsUpdated:(NSDictionary*)dic;
@end
@interface PanoPlayer : GLPlayerView
@property (nonatomic,weak)   id<PanoPlayDelegate> delegate;
@property (nonatomic,strong) NSArray <PanoPlayerOption*>*options;
@property  float speedYaw;

-(PanoramaData*) getCurrentPanoramaData;
-(id)GetCurrentPluginObject;
-(void)Play:(PanoPlayerUrl*)playerurl;
-(void)play:(PanoPlayerUrl *)playerurl options:(NSArray*)dict;
-(void)rePlay;
-(ManagerData*) getManagerData;
-(void)loadPano:(NSString*)name;
-(void)pauseBackgroundMusic;
-(void)resumeBackgroundMusic;
-(void)onTapBeforeHotpot:(Hotspot*)hotspot;
-(void)onTapAfterHotpot:(Hotspot*)hotspot;
-(UIImage*)getScreenShot;
- (GLubyte*)getScreenShot2:(Boolean)is2to1;

-(nullable VrEventObjectManager*)getVrEventManager;
-(nullable HotpotManager*)getHotManager;


-(void)refresh;
@end
@interface PanoPlayer (panoPlayer)
-(void)cleargc  __attribute__((deprecated("已过期 prepareToRelease 替换")));
@end


//
//  Plugin.h
//  PanoPlayer
//
//  Created by qiruisun on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "PanoPlayer.h"
//#import "PanoPlayerOption.h"
@class PanoPlayer;
@class PanoPlayerOption;
@class PanoramaData;
typedef struct SDL_VoutOverlay SDL_VoutOverlay;


typedef NS_ENUM(NSUInteger, PluginType) {
    /*
     没有类型
     */
    PluginTypeNone,
    /*
     sphere 类型
     */
    PluginTypeSphere,
    /*
     f4image 类型
     */
    PluginTypeimageF4,

    /*
     cube 类型
     */
    PluginTypeCube,
    
    /**
     视频类型
     */
    PluginTypeVideo,
    
    /* 
    F4Video
     */
    PluginTypeVideoF4
    
    
};


@interface Plugin : NSObject
/* 
  定时器 用户渲染页面 
*/
@property(nonatomic, weak)PanoPlayer* panoplayer;
@property(nonatomic, weak)PanoramaData* panoramaData;

/**
 返回当前加载的类型
 */
@property (assign , nonatomic , readonly) PluginType imageType;
/** 
 返回F4地址 
*/
@property (strong , nonatomic , readonly) NSArray *f4URLs;

/*
  设置渲染间隔时间 
*/
@property (assign , nonatomic) NSInteger interval;


//初始化插件
-(void) InitPlugin:(PanoPlayer*)player;
/*  
  当传入 PanoramaData 这个对象的时候 已经做好 初始化 model的操作 根据数据找到对应的 model
  @param  PanoramaData 数据对象
*/
-(void) SetPanoData:(PanoramaData*)panoData;
/* 
   禁用插件 
*/
-(void) DisablePlugin;
/* 
  清理资源
*/
-(void) clear;

/* 
  退出后台的时候调用  方法在 子类也会使用到 在父类写一遍就可以了 
  子类可以从写此方法  但是要使用这个方法的功能必须先调用父类 
  该方法内包含了 开启定时器
*/
- (void)willResignActiveNotification;
/** 
 进入前台  方法在 子类也会使用到 在父类写一遍就可以了
 子类可以从写此方法  但是要使用这个方法的功能必须先调用父类
 该方法内包含了 开启定时器 关闭定时器 
*/
- (void)didBecomeActiveNotification;


/* 
  准备创建定时器都前后台通知监听 
  在调用此方法之前  在设置  
*/
- (void)prepareToDisplayLinkAndObserver;

/* 
  定时器渲染方法
*/
- (void)prepareToRender;
- (void)setFrameData:(SDL_VoutOverlay*)frame index:(int)index;

@end

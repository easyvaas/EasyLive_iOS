//
//  VideoPlugin.h
//  PanoPlayer
//
//  Created by qiruisun on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Plugin.h"
//#import "BasePlayerMovieDecoder.h"

@interface VideoPlugin : Plugin
/* 
 总时间
*/
@property (nonatomic,readonly) float duration;
/* 
  seek 播放时间
*/
@property (nonatomic,assign)   float currentTime;

/* 
  开始加载
*/
-(void)start;
/* 
  暂停播放
*/
-(void)pause;
/* 
  停止播放
*/
-(void)stop;

//刷新重连
-(void)refresh;

@end

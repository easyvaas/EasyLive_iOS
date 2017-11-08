//
//  GLView.h
//  PanoPlayer
//
//  Created by apple on 15/7/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKMath.h>
#import <GLKit/GLKit.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class GLModel;

@interface GLPlayerView : UIView
/*
 GLModel 绘制模式
 */
@property (nonatomic,strong , nullable)GLModel * model;
/*
 设置模式
*/
@property (nonatomic,assign) int viewMode;
/* 
  是否要缩放   默认是YES
*/
@property (nonatomic,assign) bool zoomEnable;
/* 
 是否开启陀螺仪 
*/
@property (nonatomic,assign) bool gyroEnable;
/* 
   /陀螺仪模式是否可以滑动 默认是不可以滑动 NO
*/
@property (nonatomic,assign) BOOL isGyroModeShouldMove;


-(CGPoint)getCenterYawAndPitchPoint:(int)modeltype;
-(float)getHLookAt;
-(float)getVLookAt;
-(float)getFov;
-(void)setHLookAt:(float)ath;
-(void)setVLookAt:(float)atv;
-(void)setFov:(float)fov;
-(void)animationChangeMode:(int)mode hlook:(float)hlook vlook:(float)vlook fov:(float)fov;
-(void)resetRender;
-(void)prepareToRelease;


@end
NS_ASSUME_NONNULL_END

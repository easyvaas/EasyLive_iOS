//
//  CameraLen.h
//  PanoPlayer
//
//  Created by shenxing on 16/8/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CameraLen : NSObject
@property (nonatomic , assign)float a;
@property (nonatomic , assign)float b;
@property (nonatomic , assign)float c;
@property (nonatomic , assign)float d;
@property (nonatomic , assign)float e;
@property (nonatomic , assign)float dr;//半径
@property (nonatomic , assign)float centerx; //中心点x
@property (nonatomic , assign)float centery;//中心点y
@property (nonatomic , assign)float yaw;
@property (nonatomic , assign)float pitch;
@property (nonatomic , assign)float roll;
@property (nonatomic , assign)float hd;// 水平平移参数
@property (nonatomic , assign)float ve;// 垂直平移参数
@property (nonatomic , assign)float sg;// 水平裁剪参数
@property (nonatomic , assign)float st;// 垂直裁剪参数
@end

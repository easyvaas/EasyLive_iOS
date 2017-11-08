//
//  Image.h
//  PanoPlayer
//
//  Created by qiruisun on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#import "CameraLen.h" 
typedef struct SDL_VoutOverlay SDL_VoutOverlay;


#define DEVICE_SPHERE800 1
#define DEVICE_SPHERES 11
#define DEVICE_482 101
#define DEVICE_TWOSPHERE 2000
#define DEVICE_SPHEREDETUTWINS 2002
#define DEVICE_SPHERETHETAS 2003
#define DEVICE_SPHEREINSTA360 2004
#define DEVICE_SPHEREREAL3D 2005
#define DEVICE_360 360
#define DEVICE_SPHEREF4 4001
@interface Image : NSObject
@property (nonatomic , copy)NSString* type;// cube sphere video
@property (nonatomic , copy)NSString* url; //地址 -
@property (nonatomic , assign)Boolean is_hardware;
@property (nonatomic , assign)int device;//设备
@property (nonatomic , copy)NSString* devicename;//每个硬件设备名字
@property (nonatomic , assign)float degree;//度数 如果是240的，则设置成240
@property (nonatomic , assign)float maskdegree;//mask
@property (nonatomic , assign)float gamma;//gamma
@property (nonatomic , assign)float vignette;
@property (nonatomic ,assign)int width; //宽度
@property (nonatomic ,assign)int height;//高度
@property (nonatomic ,assign)int originwidth;//原
@property (nonatomic ,assign)int originheight;//
@property (nonatomic ,assign)int panow;
@property (nonatomic ,assign)int panoh;
@property (nonatomic,assign)bool ismanual_cut_3d;//3d模型人工切割开关
@property (nonatomic ,assign)int manual_cutline_3d ;//3d模型人工切割线，=0横切，=1 竖切
//旋转量
@property (nonatomic , assign)float rx;
@property (nonatomic , assign)float ry;
@property (nonatomic , assign)float rz;

@property (nonatomic,strong)CameraLen *cameralen1;//镜头参数1
@property (nonatomic,strong)CameraLen *cameralen2;//镜头参数2
@property (nonatomic,strong)CameraLen *cameralen3;//镜头参数1
@property (nonatomic,strong)CameraLen *cameralen4;//镜头参数2
@property (nonatomic,assign)int channel;//图像通道
@property (nonatomic,assign)float public_errand;//公差
@property (nonatomic,assign)bool isfixed;//是否已修正中心点
@property (nonatomic,copy) NSString* biaoding; //标定值
@property (nonatomic,copy)NSString* outputPath;//record写地址
@property (nonatomic,assign)int label;//标定编号
-(void)deviceFilter;
-(void)deviceFilterWithVoid:(void *)data;
-(void)deviceFilterWithSDL:(SDL_VoutOverlay*)frame;
-(void)deviceFilterWithUIImage:(UIImage*)img;
-(void)deviceFilterWithBuffer:(CVPixelBufferRef)buffer;
-(void)Parser:(NSString*)desc;
@end


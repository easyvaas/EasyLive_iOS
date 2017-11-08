//
//  PanoramaData.h
//  PanoPlayer
//
//  Created by qiruisun on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
@class ImageViewData , Preview;
@interface PanoramaData : NSObject
@property  (nonatomic , copy)NSString* name;
@property  (nonatomic , copy)NSString* title;
@property  (nonatomic , copy)NSString* thumbUrl;
@property (nonatomic , strong)Preview* preview;
@property (nonatomic , strong)ImageViewData* imageviewdata;
@property (nonatomic , strong)Image* image;
@property (nonatomic , strong)NSArray* hotspotList;
@end
@interface ImageViewData : NSObject
@property (nonatomic , assign)float hlookat;
@property (nonatomic , assign)float vlookat;
@property (nonatomic , assign)float fov;
@property (nonatomic , assign)float vrfov;
@property (nonatomic , assign)float vrz;
@property (nonatomic , assign)float fovmin;
@property (nonatomic , assign)float fovmax;
@property (nonatomic , assign)float defovmax;

@property (nonatomic , assign)float hlookatmin;
@property (nonatomic , assign)float hlookatmax;
@property (nonatomic , assign)float vlookatmin;
@property (nonatomic , assign)float vlookatmax;
@property (nonatomic , assign)int gyroenable;
@property (nonatomic , copy)NSString* viewmodel;
@end
@interface Preview : NSObject
@property (nonatomic , copy)NSString* url;
@property (nonatomic , copy)NSString* type;
@end




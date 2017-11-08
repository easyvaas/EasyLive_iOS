//
//  ManagerData.h
//  PanoPlayer
//
//  Created by qiruisun on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Settings , BackgoundMusic;
@interface ManagerData : NSObject
@property (nonatomic ,assign)bool debugModel;
@property (nonatomic ,strong)Settings* settings;
@property (nonatomic ,strong)NSArray* panoramaList;
@property (nonatomic ,strong)BackgoundMusic* backgroundMusic;//背景音乐
@end
@interface Settings : NSObject
@property (nonatomic , copy) NSString* panoinit;
@property (nonatomic , copy)NSString* initmode;
@property (nonatomic , assign)bool enablevr;
@property (nonatomic , copy)NSString* title;
@end
@interface BackgoundMusic : NSObject
@property (nonatomic , copy)NSString* url;
@property (nonatomic , assign)float volume;
@property (nonatomic , assign)BOOL isautoplay;
@end



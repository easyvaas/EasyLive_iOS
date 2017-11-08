//
//  Hotspot.h
//  PanoPlayer
//
//  Created by qiruisun on 15/7/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Hotspot : NSObject
@property (nonatomic , copy)NSString* name;
@property (nonatomic , assign)float ath;
@property (nonatomic , assign)float atv;
@property (nonatomic , copy)NSString* eventtype;
@property (nonatomic , copy)NSString* eventarg;
@property (nonatomic , copy)NSString* style;
@property (nonatomic , copy)NSString* stylearg;
@property (nonatomic , copy)NSString* locdata;//坐标
@property (nonatomic , assign)float nextath;
@property (nonatomic , assign)float nextatv;
@property (nonatomic , assign)float nextfov;
@property (nonatomic , assign)float alpha;
@property (nonatomic , assign)float scale;
@property (nonatomic,assign) BOOL checkrange;//检测区域是否加大
@property (nonatomic,assign) BOOL hidden;//是否显示 配置里的值
@property (nonatomic,assign) BOOL copyhidden;//是否显示 实际的值，控制热点显示和隐藏
@end

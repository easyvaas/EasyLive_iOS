//
//  GLPlayerCore.h
//  ios_player_lib
//
//  Created by jacky ni on 2017/7/21.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>


#define VIEWMODE_FISHEYE        2
#define VIEWMODE_LITTLEPLANET   3
#define VIEWMODE_DEF            1
#define VIEWMODE_VR_HORIZONTAL  4
#define VIEWMODE_FLAT           5
#define VIEWMODE_SPHERE         6
#define VIEWMODE_LINEFLAT       7
#define VIEWMODE_VR_VERTICAL    8
#define VIEWMODE_VR             4


//视角
#define GLPLAYERRENDERMODELTYPE_DEFAULTEYE 0
#define GLPLAYERRENDERMODELTYPE_LEFTEYE 1
#define GLPLAYERRENDERMODELTYPE_RIGHTEYE 2


#define VERSION    1.3.1
#define OPENGLES2
#define OPENGL_SCALE    [[UIScreen mainScreen] scale]
#define FRAME_SPEED 30


@interface GLPlayerCore : NSObject

@end

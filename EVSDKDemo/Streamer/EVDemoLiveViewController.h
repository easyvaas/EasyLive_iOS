//
//  EVDemoLiveViewController.h
//  EVSDKDemo
//
//  Created by mashuaiwei on 16/7/28.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kStreamFrameSizeKey             @"streamFrameSize"
#define kInitialFPSKey                  @"initialFPS"
#define kInitialBitrateKey              @"initialBitrate"
#define kMaxBitrateKey                  @"maxBitrate"
#define kMinBitrateKey                  @"minBitrate"
#define kKeyFrameIntervalKey            @"keyFrameInterval"
#define kAudioBitrateKey                @"audioBitrate"
#define kUseHighAACKey                  @"useHAAC"
#define kMuteKey                        @"mute"
#define kFrontCameraKey                 @"frontCamera"
#define kFlashlightKey                  @"flashlight"
#define kBeautyKey                      @"beauty"


@interface EVDemoLiveViewController : UIViewController

@property (nonatomic, strong) NSDictionary *streamerParams; /**< 推流器参数 */
@property (nonatomic, copy) NSString *lid;  /**< 直播id */

@end

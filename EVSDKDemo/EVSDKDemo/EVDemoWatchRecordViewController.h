//
//  EVDemoWatchRecordViewController.h
//  EVSDKDemo
//
//  Created by Lcrnice on 17/5/12.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EVDemoWatchRecordViewController : UIViewController

@property (nonatomic, copy) NSString *vid;                  /**< 视频 id */
@property (nonatomic, assign) NSInteger watchStartPosition; /**< 起始播放位置 */

@end

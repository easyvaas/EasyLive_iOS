//
//  EVWatchVRViewController.h
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/7/18.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EVVRFramework/EVVRPlayer.h>

@interface EVWatchVRViewController : UIViewController

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, assign) EVVRContentType contentType;
@property (nonatomic, assign) BOOL living;

@end

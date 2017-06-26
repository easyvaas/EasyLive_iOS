//
//  EVMessageModel.h
//  EVMessage
//
//  Created by Lcrnice on 2017/6/14.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EVMessageConfig.h"

@interface EVMessageModel : NSObject

@property (nonatomic, copy) NSString *context;          /**< 消息内容 */
@property (nonatomic, copy) NSDictionary *userData;     /**< 透传消息 */
@property (nonatomic, copy) NSString *userID;           /**< 用户标识 */
@property (nonatomic, assign) EVMessageType type;       /**< 消息类型 */

@end

//
//  PlayerOption.h
//  ios_player_lib
//
//  Created by chao on 2017/5/26.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

//是否使用硬解，value:[true|false]
#define DICT_KEY_HW_DECODER @"hw_decoder"

//一个option: Category:[key:value]
typedef NS_ENUM(NSInteger, PanoPlayerOptionType) {
    PanoPlayerOptionCategoryFormat = 1,
    PanoPlayerOptionCategoryCodec  = 2,
    PanoPlayerOptionCategorySws    = 3,
    PanoPlayerOptionCategoryPlayer = 4,
    PanoPlayerOptionCategorySwr    = 5,
};

typedef NS_ENUM(NSInteger, PanoPlayerOptionValueType) {
    PanoPlayerOptionValueInt = 1,
    PanoPlayerOptionValueString = 2
};

@interface PanoPlayerOption : NSObject
@property(nonatomic, assign)PanoPlayerOptionType playerOptionType;
@property(nonatomic, strong)NSString* key;
@property(nonatomic, strong)NSString* value;
@property(nonatomic, assign)PanoPlayerOptionValueType playerOptionValueType;
@end

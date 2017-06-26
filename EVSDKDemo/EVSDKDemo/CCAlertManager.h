/**************************************************************
 * 版权所有 : (C) 2015 易直播
 * 文件名称 : NSString+Emoji.h
 * 文件标识 : b004-001
 * 内容摘要 : block回调的alertView
 * 其它说明 :
 * 当前版本 : b004-001_1
 * 文件作者 : 施治昂
 * 创建时间 : 15/07/17
 *
 *
 * 修改记录
 *  修改日期 :
 *  修改人员 :
 *  修改内容 :
 ***************************************************************/

#import <UIKit/UIKit.h>

@interface CCAlertManager : NSObject

/**
 *  初始化
 *
 *  @return 单例的alertView
 */
+ (instancetype)shareInstance;

/**
 *  使用取消、确定按钮初始化alertView
 *
 *  @param title        按钮
 *  @param message      具体内容
 *  @param cancelTitle  取消按钮
 *  @param comfirmTitle 确定按钮
 *  @param comfirmBlock 确定回调
 *  @param cancelBlock  取消回调
 *
 */
- (UIAlertView *)performComfirmTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle comfirmTitle:(NSString *)comfirmTitle WithComfirm:(void(^)())comfirmBlock cancel:(void(^)())cancelBlock;

- (UIAlertView *)performComfirmTitle:(NSString *)title message:(NSString *)message comfirmTitle:(NSString *)comfirmTitle WithComfirm:(void(^)())comfirmBlock;

//- (UIAlertView *)performComfirmTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle WithComfirm:(void(^)())comfirmBlock;

- (UIAlertView *)performEditComfirmTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle comfirmTitle:(NSString *)comfirmTitle WithComfirm:(void(^)(NSString *editMessage))comfirmBlock cancel:(void(^)())cancelBlock;

@end

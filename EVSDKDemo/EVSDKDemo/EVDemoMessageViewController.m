//
//  EVDemoMessageViewController.m
//  EVSDKDemo
//
//  Created by mashuaiwei on 16/7/25.
//  Copyright © 2016年 cloudfocous. All rights reserved.
//

#import "EVDemoMessageViewController.h"
#import "EVMessage.h"
#import "EVSDKManager.h"
#import "CCAlertManager.h"

@interface EVDemoMessageViewController ()<EVMessageProtocol, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *topicTextField;
@property (weak, nonatomic) IBOutlet UITextField *messageTestField;
@property (weak, nonatomic) IBOutlet UITextView *messageShowStage;
@property (nonatomic, strong) NSMutableString *showText; /**< 展示区显示的文字 */

@end

@implementation EVDemoMessageViewController {
    BOOL _isConnected;
}

#pragma mark - life circle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"message demo";
    self.showText = [@"" mutableCopy];
    self.messageTestField.delegate = self;
    
    [EVMessageManager shareManager].delegate = self;
    
    [self refreshPage];
}

- (void)dealloc{
    [[EVMessageManager shareManager] closeConnect];
    _showText = nil;
}


#pragma mark - action

- (IBAction)joinInTopic:(UIButton *)sender {
    NSString *topic = self.topicTextField.text;
    if (!topic) {
        return;
    }
    [self appendUser:[EVSDKManager userID] string:[NSString stringWithFormat:@"connecting in topic:%@", topic]];
    
    [[EVMessageManager shareManager] connect:topic];
}
- (IBAction)leaveTopic:(UIButton *)sender {
    if (_isConnected == false) {
        [[CCAlertManager shareInstance] performComfirmTitle:@"提示" message:@"请先点击‘join’加入该聊天服务器！" comfirmTitle:@"确定" WithComfirm:nil];
        return;
    }
    NSString *topic = self.topicTextField.text;
    if (!topic) {
        return;
    }
    [self appendUser:[EVSDKManager userID] string:[NSString stringWithFormat:@"Leaving topic:%@", topic]];
    __weak typeof(self) wSelf = self;
    
    [[EVMessageManager shareManager] leaveWithTopic:topic result:^(NSDictionary *response, NSError *error) {
        __strong typeof(self) sSelf = wSelf;
        if (error == nil) {
            [sSelf appendUser:[EVSDKManager userID] string:[NSString stringWithFormat:@"Success leave topic:%@", topic]];
        }
    }];
}
- (IBAction)sendMessage:(UIButton *)sender {
    if (_isConnected == false) {
        [[CCAlertManager shareInstance] performComfirmTitle:@"提示" message:@"请先点击‘join’加入该聊天服务器！" comfirmTitle:@"确定" WithComfirm:nil];
        return;
    }
    NSString *topic = self.topicTextField.text;
    if (!topic) {
        return;
    }
    NSString *message = [self.messageTestField.text mutableCopy];
    if ([self isNullString:message]) {
        return;
    }
    [self appendUser:[EVSDKManager userID] string:[NSString stringWithFormat:@">%@", message]];
    NSDictionary *extension = @{
                                @"exct": @{
                                        @"nk": @"布拉德皮蛋!@#$%"
                                        }
                                };
    __weak typeof(self) wSelf = self;
    [[EVMessageManager shareManager] sendWithTopic:topic message:message userData:extension type:EVMessageTypeMsg result:^(NSDictionary *response, NSError *error) {
        __strong typeof(self) sSelf = wSelf;
        if (error) {
            [sSelf appendUser:[EVSDKManager userID] string:[NSString stringWithFormat:@"Failed send message with error :%@", error]];
        }
    }];
    
    self.messageTestField.text = nil;
}
- (IBAction)like:(UIButton *)sender {
    if (_isConnected == false) {
        [[CCAlertManager shareInstance] performComfirmTitle:@"提示" message:@"请先点击‘join’加入该聊天服务器！" comfirmTitle:@"确定" WithComfirm:nil];
        return;
    }
    NSString *topic = self.topicTextField.text;
    if (!topic)
        return;
    
    [self appendUser:[EVSDKManager userID] string:[NSString stringWithFormat:@">add like:%@", @"10"]];
    // 测试点赞
    __weak typeof(self) wSelf = self;
    [[EVMessageManager shareManager] addLikeCountWithTopic:topic count:10 result:^(NSDictionary *response, NSError *error) {
        __strong typeof(self) sSelf = wSelf;
        if (error) {
            [sSelf appendUser:[EVSDKManager userID] string:[NSString stringWithFormat:@"Failed add like count with error :%@", error]];
        }
    }];
}
- (IBAction)getRecentHIstory:(id)sender {
    if (_isConnected == false) {
        [[CCAlertManager shareInstance] performComfirmTitle:@"提示" message:@"请先点击‘join’加入该聊天服务器！" comfirmTitle:@"确定" WithComfirm:nil];
        return;
    }
    
    __weak typeof(self) wSelf = self;
    [[EVMessageManager shareManager] getLastHistoryMessageWithTopic:self.topicTextField.text count:20 type:EVMessageTypeMsg result:^(NSDictionary *response, NSError *error) {
        __strong typeof(self) sSelf = wSelf;
        
        if (error == nil) {
            NSArray *list = response[@"content"];
            [list enumerateObjectsUsingBlock:^(EVMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [sSelf appendUser:[EVSDKManager userID] string:[NSString stringWithFormat:@"\nuserid: %@\ncontext: %@\nmessageType: %ld\nuserData: %@", obj.userID, obj.context, obj.type, obj.userData]];
            }];
            [sSelf appendUser:[EVSDKManager userID] string:@"以下为最近的历史消息"];
        } else {
            [sSelf appendUser:[EVSDKManager userID] string:[NSString stringWithFormat:@" history error:%@", error]];
        }
    }];
}
- (IBAction)clearTextView:(id)sender {
    self.showText = [NSMutableString new];
}


#pragma mark - EVMessageProtocol
- (void)EVMessageConnected {
    _isConnected = YES;
    [self appendUser:[EVSDKManager userID] string:@"connected!"];
}

- (void)EVMessageConnectError:(NSError *)error {
    [self appendUser:[EVSDKManager userID] string:@"connect failed!"];
    if (error) {
        [self appendUser:[EVSDKManager userID] string:error.description];
    }
}

- (void)EVMessageDidCloseWithCode:(EVMessageErrorCode)code reason:(NSString *)reason {
    _isConnected = NO;
    if (code != EVMessageErrorNone) {
        [self appendUser:[EVSDKManager userID] string:[NSString stringWithFormat:@"connect closed with code:%zd reason:%@", code, reason]];
    }
}

- (void)EVMessageRecievedNewMessageInTopic:(NSString *)topic sendedFrom:(NSString *)userid message:(NSString *)message userData:(NSDictionary *)userData {
    [self appendUser:userid string:[NSString stringWithFormat:@"<-topic:%@ \ruserid:%@ \rmessage:%@ \ruserdata:%@", topic, userid, message, userData]];
}

- (void)EVMessageUsers:(NSArray<NSString *> *)userids joinedTopic:(NSString *)topic {
    [self handleJoinOrLeaveWithType:YES users:userids topic:topic from:@"admin"];
}

- (void)EVMessageUsers:(NSArray<NSString *> *)userids leftTopic:(NSString *)topic {
    [self handleJoinOrLeaveWithType:NO users:userids topic:topic from:@"admin"];
}

- (void)EVMessageDidUpdateLikeCount:(long long)likeCount inTopic:(NSString *)topic {
    [self appendUser:[EVSDKManager userID] string:[NSString stringWithFormat:@"<-topic:%@ \rlike count:%zd", topic, likeCount]];
}

- (void)EVMessageDidUpdateWatchingCount:(NSInteger)watchingCount inTopic:(NSString *)topic {
    [self appendUser:[EVSDKManager userID] string:[NSString stringWithFormat:@"<-topic:%@ \rwatching count:%zd", topic, watchingCount]];
}

- (void)EVMessageDidUpdateWatchedCount:(NSInteger)watchedCount inTopic:(NSString *)topic {
    [self appendUser:[EVSDKManager userID] string:[NSString stringWithFormat:@"<-topic:%@ \rwatched count:%zd", topic, watchedCount]];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMessage:nil];
    [self.view endEditing:YES];
    return YES;
}


#pragma mark - private methods

- (void)refreshPage{
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            __strong typeof(wSelf) sSelf = wSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                sSelf.messageShowStage.text = sSelf.showText;
            });
            [NSThread sleepForTimeInterval:1];
        }
    });
}

- (void)appendUser:(NSString *)user string:(NSString *)string{
    [self.showText insertString:[NSString stringWithFormat:@"%@:%@\r%@\r\r\n", user, [self getCurrentTime], string] atIndex:0];
}

- (NSString *)getCurrentTime{
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    fomatter.dateFormat = @"yyyyMMdd HH:mm:ss";
    NSDate *date = [NSDate date];
    NSString *dateString = [fomatter stringFromDate:date];
    
    return dateString;
}

- (void)handleJoinOrLeaveWithType:(BOOL)join users:(NSArray *)users topic:(NSString *)topic from:(NSString *)sender{
    NSMutableString *usersStr = [@"" mutableCopy];
    for (NSString *userid in users) {
        [usersStr appendFormat:@"%@,", userid];
    }
    usersStr = [[usersStr substringToIndex:usersStr.length -2] mutableCopy];
    if (join) {
        [usersStr appendString:@"  来了！"];
    } else {
        [usersStr appendString:@"  离开了！"];
    }
    [self appendUser:sender string:usersStr];
}

- (BOOL)isNullString:(NSString *)string{
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (!string) {
        return YES;
    }
    if ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0 ) {
        return YES;
    }
    return NO;
}

@end

//
//  BCModule.m
//  PrivatePhotos
//
//  Created by 王琴 on 2023/6/20.
//
#import "BCModule.h"
#import <React/RCTLog.h>//调用输出的方法
#import <React/RCTConvert.h>
#import <Dcapi/Dcapi.h>
#import "DcapiModules.h"


@interface BCModule ()
@end


@implementation BCModule
/**
 *为了实现RCTBridgeModule协议，你的类需要包含RCT_EXPORT_MODULE()宏。这个宏也可以添加一个参数用来指定在 JavaScript 中访问这个模块的名字。如果你不指定，默认就会使用这个 Objective-C 类的名字。如果类名以 RCT 开头，则 JavaScript 端引入的模块名会自动移除这个前缀。
 */
RCT_EXPORT_MODULE()




#pragma mark - 注册方法addEvent
/**
 *你必须明确的声明要给 JavaScript 导出的方法，否则 React Native 不会导出任何方法。声明通过RCT_EXPORT_METHOD()宏来实现：
 *导出到 JavaScript 的方法名是 Objective-C 的方法名的第一个部分。React Native 还定义了一个RCT_REMAP_METHOD()宏，它可以指定 JavaScript 方法名。因为 JavaScript 端不能有同名不同参的方法存在，所以当原生端存在重载方法时，可以使用这个宏来避免在 JavaScript 端的名字冲突。
 *我们需要把事件的时间交给原生方法。我们不能在桥接通道里传递 Date 对象，所以需要把日期转化成字符串或数字来传递
 */

//获取当前区块高度
RCT_EXPORT_METHOD(bc_GetBlockHeight:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    //RCTLogInfo(@"bc_GetBlockHeight");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        long blockHeight = [dcapi bc_GetBlockHeight];
        if(blockHeight > 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[@true]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

//获取节点的可用状态
RCT_EXPORT_METHOD(bc_PeerState:(NSString*)peerid successCallback:(RCTResponseSenderBlock)successCallback) {
    //RCTLogInfo(@"bc_PeerState");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *state = [dcapi bc_PeerState:peerid];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[state]);
        });
    });
}

// 随机生成区块链账号信息（返回mnemonic）
RCT_EXPORT_METHOD(bc_GenerateBCAccount:(int)val  successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    //RCTLogInfo(@"bc_GenerateBCAccount");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mnemonic = [dcapi bc_GenerateBCAccount:val];
        if(mnemonic.length > 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[mnemonic]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

// 查询当前链上存储价格列表{data:[StroragePrice]}
RCT_EXPORT_METHOD(bc_GetStoragePrices:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    //RCTLogInfo(@"bc_GetStoragePrices");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *jsonStroragePrices = [dcapi bc_GetStoragePrices];
        if(jsonStroragePrices.length > 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[jsonStroragePrices]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

// 订阅存储
RCT_EXPORT_METHOD(bc_SubscribeStorage:(int)pricetype successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    //RCTLogInfo(@"bc_SubscribeStorage");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [dcapi bc_SubscribeStorage:pricetype];
        if(success){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[@true]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

#pragma mark - 向react-natvie 传递消息
- (NSArray<NSString *> *)supportedEvents
{
  return @[@"EventReminder"];
}
- (void)calendarEventReminderReceived:(NSNotification *)notification
{
  NSString *eventName = notification.userInfo[@"name"];
  [self sendEventWithName:@"EventReminder" body:@{@"name": eventName}];
}
- (dispatch_queue_t)methodQueue
{
  return dispatch_queue_create("com.facebook.React.AsyncLocalStorageQueue", DISPATCH_QUEUE_SERIAL);
}
-(id) init
{
    self = [super init];
    if(self)
    {
        if(dcapi == nil){
            [[DcapiModules alloc] init];
            NSLog(@"BCModule---------init---------========");
        }
    }
    return self;
}
@end

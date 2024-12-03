//
//  AccountModule.m
//  PrivatePhotos
//
//  Created by 王琴 on 2023/6/20.
//
#import "AccountModule.h"
#import <React/RCTLog.h>//调用输出的方法
#import <React/RCTConvert.h>
#import <Dcapi/Dcapi.h>
#import "DcapiModules.h"


@interface AccountModule ()
@end


@implementation AccountModule
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

//退出登录
RCT_EXPORT_METHOD(account_Logout) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //RCTLogInfo(@"account_Logout");
        [dcapi account_Logout];
    });
}

// 将私钥绑定NFT账号(NFT账号+密码) //0:绑定成功 1:用户已绑定其他nft账号 2:nft账号已经被其他用户绑定 3:区块链账号不存在
// 99:其他异常
// 4:还没有建立到存储节点的连接 5:加密数据过程出错 6:区块链相关错误 7:签名错误 8:用户有效期已过
RCT_EXPORT_METHOD(account_BindNFTAccount:(NSString*)account password:(NSString*)password seccode:(NSString*)seccode  successCallback:(RCTResponseSenderBlock)successCallback) {
    //RCTLogInfo(@"account_BindNFTAccount");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        long sdkStatus = [dcapi account_BindNFTAccount:account password:password seccode:seccode];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[@(sdkStatus)]);
        });
    });
}

// 将私钥绑定NFT账号(NFT账号+密码) //0:绑定成功 1:用户已绑定其他nft账号 2:nft账号已经被其他用户绑定 3:区块链账号不存在
// 99:其他异常
// 4:还没有建立到存储节点的连接 5:加密数据过程出错 6:区块链相关错误 7:签名错误 8:用户有效期已过
RCT_EXPORT_METHOD(account_BindNFTAccountWithAppBcAccount:(NSString*)account password:(NSString*)password  seccode:(NSString*)seccode vaccount:(NSString*)vaccount  successCallback:(RCTResponseSenderBlock)successCallback) {
    //RCTLogInfo(@"account_BindNFTAccountWithAppBcAccount");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        long sdkStatus = [dcapi account_BindNFTAccountWithAppBcAccount:account password:password seccode:seccode vaccount:vaccount];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[@(sdkStatus)]);
        });
    });
}

//账号是否与用户公钥绑定成功
RCT_EXPORT_METHOD(account_IfNftAccountBindSuccess:(NSString*)account  successCallback:(RCTResponseSenderBlock)successCallback) {
    //RCTLogInfo(@"account_IfNftAccountBindSuccess");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL bindFlag = [dcapi ifNftAccountBindSuccess:account];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[@(bindFlag)]);
        });
    });
}

//应用账号是否与用户公钥绑定成功
RCT_EXPORT_METHOD(account_IfAppNftAccountBindSuccess:(NSString*)account  successCallback:(RCTResponseSenderBlock)successCallback) {
    //RCTLogInfo(@"account_IfAppNftAccountBindSuccess");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL bindFlag = [dcapi ifAppNftAccountBindSuccess:account];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[@(bindFlag)]);
        });
    });
}

//获取当前账号的nft账号
RCT_EXPORT_METHOD(account_GetNFTAccount:(RCTResponseSenderBlock)successCallback) {
    //RCTLogInfo(@"account_GetNFTAccount");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *nftAccount = [dcapi account_GetNFTAccount];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[nftAccount]);
        });
    });
}

//NFT账号登录
RCT_EXPORT_METHOD(account_NFTAccountLogin:(NSString*)account password:(NSString*)password seccode:(NSString*)seccode  successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    //RCTLogInfo(@"account_NFTAccountLogin");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        long login = [dcapi account_NFTAccountLogin:account password:password seccode:seccode];
        if(login == 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[@(login)]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(lastError.length > 0){
                    errorCallback(@[lastError]);
                }else {
                    successCallback(@[@(login)]);
                }
            });
        }
    });
}

//NFT账号密码修改
RCT_EXPORT_METHOD(account_NFTAccountPasswordModify:(NSString*)account password:(NSString*)password  seccode:(NSString*)seccode  successCallback:(RCTResponseSenderBlock)successCallback) {
    //RCTLogInfo(@"account_NFTAccountPasswordModify");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        long sdkStatus = [dcapi account_NFTAccountPasswordModify:account password:password seccode:seccode];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[@(sdkStatus)]);
        });
    });
}

//子账号NFT账号密码修改
RCT_EXPORT_METHOD(account_AppNFTAccountPasswordModify:(NSString*)account password:(NSString*)password  seccode:(NSString*)seccode  successCallback:(RCTResponseSenderBlock)successCallback) {
    //RCTLogInfo(@"account_AppNFTAccountPasswordModify");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        long sdkStatus = [dcapi account_AppNFTAccountPasswordModify:account password:password seccode:seccode];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[@(sdkStatus)]);
        });
    });
}

//NFT账号转让
RCT_EXPORT_METHOD(account_NFTAccountTransfer:(NSString*)tpubkey   successCallback:(RCTResponseSenderBlock)successCallback) {
    //RCTLogInfo(@"account_NFTAccountTransfer");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        long transfer = [dcapi account_NFTAccountTransfer:tpubkey];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[@(transfer)]);
        });
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
            NSLog(@"AccountModule---------init---------========");
        }
    }
    return self;
}
@end

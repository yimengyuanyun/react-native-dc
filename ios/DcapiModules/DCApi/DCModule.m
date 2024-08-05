//
//  DCModule.m
//  PrivatePhotos
//
//  Created by 王琴 on 2023/6/20.
//
#import "DCModule.h"
#import <React/RCTLog.h>//调用输出的方法
#import <React/RCTConvert.h>
#import <Dcapi/Dcapi.h>
#import "DcapiModules.h"
#import "Net.pbobjc.h"


@interface DCModule ()
@end


@implementation DCModule


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

// 获取密钥
RCT_EXPORT_METHOD(dc_GenerateSymmetricKey:(RCTResponseSenderBlock)successCallback) {
    RCTLogInfo(@"dc_GenerateSymmetricKey");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *key = [dcapi dc_GenerateSymmetricKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[key]);
        });
    });
}

//密钥加密
RCT_EXPORT_METHOD(dc_EncryptData:(NSString*)data pin:(NSString*)pin successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"dc_EncryptData");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *byteData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSData *bytePin = [pin dataUsingEncoding:NSUTF8StringEncoding];
        NSData *key = [dcapi dc_EncryptData:byteData key:bytePin];
        if(key == nil){
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }else {
            NSData *base64Data = [key base64EncodedDataWithOptions:0];
            NSString * str  =[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[str]);
            });
        }
    });
}

//密钥解密
RCT_EXPORT_METHOD(dc_DecryptData:(NSString*)baseData pin:(NSString*)pin successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"dc_DecryptData");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *byteData = [[NSData alloc]initWithBase64EncodedString:baseData options:NSDataBase64DecodingIgnoreUnknownCharacters];
        NSData *bytePin = [pin dataUsingEncoding:NSUTF8StringEncoding];
        NSData *key = [dcapi dc_DecryptData:byteData key:bytePin];
        if(key == nil){
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }else {
            NSString * str  =[[NSString alloc] initWithData:key encoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[str]);
            });
        }
    });
}

// 初始化
RCT_EXPORT_METHOD(dc_ApiInit:(NSString*)DCAPPName dir:(NSString*)dir region:(NSString*)region  key:(NSString*)key successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *apppath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        RCTLogInfo(@"apppath: %d", apppath);
        NSString *userpath = [apppath stringByAppendingPathComponent:dir];
        RCTLogInfo(@"userpath: %d", userpath);
        NSError *error = nil;
        BOOL success = YES;
        if (![[NSFileManager defaultManager] fileExistsAtPath:userpath]){
          //withIntermediateDirectories  YES代表覆盖原文件，NO表示不覆盖
          success = [[NSFileManager defaultManager] createDirectoryAtPath:userpath withIntermediateDirectories:(YES) attributes:nil error:&error];
        }
        RCTLogInfo(@"是否创建成功: %d，%@", success, error);
        if(success){
            NSString *webport = [dcapi dc_ApiInit:DCAPPName region:region encryptkey:key apppath:apppath userdir:dir webflag:true debugflag:true];
            RCTLogInfo(@"返回webport: %@", webport);
            if(webport.length > 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    successCallback(@[webport]);
                });
            }else{
                NSString *lastError = [dcapi dc_GetLastErr];
                RCTLogInfo(@"返回lastError: %@", lastError);
                dispatch_async(dispatch_get_main_queue(), ^{
                    errorCallback(@[lastError]);
                });
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[]);
            });
        }
    });
}

//加载默认用户信息
RCT_EXPORT_METHOD(dc_LoadDefaultUserInfo:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"dc_LoadDefaultUserInfo");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL load = [dcapi dc_LoadDefaultUserInfo];
        if(load){
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

//设置用户默认数据库上链
RCT_EXPORT_METHOD(dc_SetUserDefaultDB:(NSString*)threadid rk:(NSString*)rk sk:(NSString*)sk successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"dc_SetUserDefaultDB");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL load = [dcapi dc_SetUserDefaultDB:threadid b32Rk:rk b32Sk:sk];
        if(load){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[threadid]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

//获取当前接入的webport
RCT_EXPORT_METHOD(dc_GetLocalWebports:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"dc_SetUserDefaultDB");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *localWebports = [dcapi dc_GetLocalWebports];
        if(localWebports.length > 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[localWebports]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

//设置默认区块链代理节点
RCT_EXPORT_METHOD(dc_SetDefaultChainProxy:(NSString*)chainProxyUrl  successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"dc_SetDefaultChainProxy");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL load = [dcapi dc_SetDefaultChainProxy:chainProxyUrl];
        if(load){
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

//获取默认区块链代理节点
RCT_EXPORT_METHOD(dc_GetDefaultChainProxy:(RCTResponseSenderBlock)successCallback) {
    RCTLogInfo(@"dc_GetDefaultChainProxy");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *defaultChainProxy = [dcapi dc_GetDefaultChainProxy];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[defaultChainProxy]);
        });
    });
}

//获取区块链代理节点列表
RCT_EXPORT_METHOD(dc_GetChainProxys:(RCTResponseSenderBlock)successCallback) {
    RCTLogInfo(@"dc_GetChainProxys");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *chainProxys = [dcapi dc_GetChainProxys];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[chainProxys]);
        });
    });
}

//获取在线的存储节点接入地址列表
RCT_EXPORT_METHOD(dc_GetOnlinePeers:(RCTResponseSenderBlock)successCallback) {
    RCTLogInfo(@"dc_GetOnlinePeers");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *onlinePeers = [dcapi dc_GetOnlinePeers];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[onlinePeers]);
        });
    });
}

//获取当前存储节点接入地址列表
RCT_EXPORT_METHOD(dc_GetBootPeers:(RCTResponseSenderBlock)successCallback) {
    RCTLogInfo(@"dc_GetBootPeers");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *multiaddrs = [dcapi dc_GetBootPeers];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[multiaddrs]);
        });
    });
}

//增加接入存储节点记录
RCT_EXPORT_METHOD(dc_AddBootAddrs:(NSString*)multiaddr  successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"dc_AddBootAddrs");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL load = [dcapi dc_AddBootAddrs:multiaddr];
        if(load){
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

//删除指定的接入存储节点记录
RCT_EXPORT_METHOD(dc_DeleteBootAddrs:(NSString*)multiaddr successCallback:(RCTResponseSenderBlock)successCallback) {
    RCTLogInfo(@"dc_DeleteBootAddrs");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [dcapi dc_DeleteBootAddrs:multiaddr];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[@(success)]);
        });
    });
}

//切换接入的DC服务节点
RCT_EXPORT_METHOD(dc_SwitchDcServer:(NSString*)multiaddr  successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"dc_SwitchDcServer");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL load = [dcapi dc_SwitchDcServer:multiaddr];
        if(load){
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

//获取当前接入的DC服务节点
RCT_EXPORT_METHOD(dc_GetConnectedDcNetInfo:(RCTResponseSenderBlock)successCallback) {
    RCTLogInfo(@"dc_GetConnectedDcNetInfo");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dcNetInfo = [dcapi dc_GetConnectedDcNetInfo];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[dcNetInfo]);
        });
    });
}

//获取当前生效的私钥（返回16进制字符串）
RCT_EXPORT_METHOD(dc_GetEd25519AppPrivateKey:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"dc_GetEd25519AppPrivateKey");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *privateKey = [dcapi dc_GetEd25519AppPrivateKey];
        if(privateKey.length > 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[privateKey]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

//获取当前生效key关联的助记词
RCT_EXPORT_METHOD(dc_GetMnemonic:(RCTResponseSenderBlock)successCallback) {
    RCTLogInfo(@"dc_GetMnemonic");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *mnemonic = [dcapi dc_GetMnemonic];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[mnemonic]);
        });
    });
}

//导入私钥，privatekey 16进制字符串
RCT_EXPORT_METHOD(dc_ImportEd25519PrivateKey:(NSString*)privateKey successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"dc_ImportEd25519PrivateKey");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [dcapi dc_ImportEd25519PrivateKey:privateKey];
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

//导入助记词
RCT_EXPORT_METHOD(dc_ImportMnemonic:(NSString*)mnemonic successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"dc_ImportMnemonic");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [dcapi dc_ImportMnemonic:mnemonic];
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

//获取用户信息
RCT_EXPORT_METHOD(dc_GetUserInfo:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"dc_GetUserInfo");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *jsonUserInfo = [dcapi dc_GetUserInfo];
        if(jsonUserInfo.length > 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[jsonUserInfo]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

//应用账号是否已经创建
RCT_EXPORT_METHOD(dc_IfAppAcountExist:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"dc_IfAppAcountExist");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [dcapi dc_IfAppAcountExist];
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

//释放资源
RCT_EXPORT_METHOD(dc_ReleaseDc:(RCTResponseSenderBlock)successCallback) {
    RCTLogInfo(@"dc_ReleaseDc");
    [dcapi dc_ReleaseDc];
    successCallback(@[]);
}

//删除文件夹
RCT_EXPORT_METHOD(deleteDir:(NSString*)dir successCallback:(RCTResponseSenderBlock)successCallback) {
    RCTLogInfo(@"deleteDir");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *apppath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *userpath = [apppath stringByAppendingPathComponent:dir];
        NSError *error = nil;
        BOOL success = YES;
        if (![[NSFileManager defaultManager] fileExistsAtPath:userpath]){
          success = [[NSFileManager defaultManager] removeItemAtPath:userpath error:&error];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[@(success)]);
        });
    });
}

//添加/生成应用账号
RCT_EXPORT_METHOD(dc_GenerateAppAccount:(NSString*)appId successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"dc_GenerateAppAccount");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *basePrivKey = [dcapi dc_GenerateAppAccount:appId];
        if(basePrivKey.length > 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[basePrivKey]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

//account转address
RCT_EXPORT_METHOD(dc_GetEthAddress:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"dc_GetEthAddress");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *address = [dcapi dc_GetEthAddress];
        if(address.length > 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[address]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

//todo 重启本地文件网络访问服务
RCT_EXPORT_METHOD(dc_RestartLocalWebServer:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
   RCTLogInfo(@"dc_RestartLocalWebServer");
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       BOOL success = [dcapi dc_RestartLocalWebServer];
       if(success){
           dispatch_async(dispatch_get_main_queue(), ^{
               successCallback(@true);
           });
       }else {
           NSString *lastError = [dcapi dc_GetLastErr];
           dispatch_async(dispatch_get_main_queue(), ^{
               errorCallback(@[lastError]);
           });
       }
   });
}

//16进制区块链账号转换为base32公钥
RCT_EXPORT_METHOD(dc_AccountToPubkey:(NSString*)account successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
   RCTLogInfo(@"dc_AccountToPubkey");
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       NSString *basePubkey = [dcapi dc_AccountToPubkey:account];
       if(basePubkey.length > 0){
           dispatch_async(dispatch_get_main_queue(), ^{
               successCallback(@[basePubkey]);
           });
       }else {
           NSString *lastError = [dcapi dc_GetLastErr];
           dispatch_async(dispatch_get_main_queue(), ^{
               errorCallback(@[lastError]);
           });
       }
   });
}

//base32公钥转换为16进制Account
RCT_EXPORT_METHOD(dc_PubkeyToHexAccount:(NSString*)basePubkey successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
   RCTLogInfo(@"dc_PubkeyToHexAccount");
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       NSString *account = [dcapi dc_PubkeyToHexAccount:basePubkey];
       if(account.length > 0){
           dispatch_async(dispatch_get_main_queue(), ^{
               successCallback(@[account]);
           });
       }else {
           NSString *lastError = [dcapi dc_GetLastErr];
           dispatch_async(dispatch_get_main_queue(), ^{
               errorCallback(@[lastError]);
           });
       }
   });
}

// 启动p2p通信服务
RCT_EXPORT_METHOD(dc_EnableMessage:(NSString*)model
            successCallback:(RCTResponseSenderBlock)successCallback
            errorCallback:(RCTResponseSenderBlock)errorCallback) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RCTLogInfo(@"dc_EnableMessage");
        P2PHandlerModule *p2pHandler = [P2PHandlerModule alloc] ;
        BOOL success = [dcapi dc_EnableMessage:[model longLongValue] msgHandler:p2pHandler streamHandler:NULL connectOptions:NULL];
        if(success){
            RCTLogInfo(@"success");
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

//导出json格式的钱包私钥信息,返回json格式的钱包私钥信息,如果主账号存在，返回主账号的私钥信息，password 导出密码
RCT_EXPORT_METHOD(dc_EncryptEthPrivKeyToJson:(NSString*)password successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
   RCTLogInfo(@"dc_EncryptEthPrivKeyToJson");
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       NSString *info = [dcapi dc_EncryptEthPrivKeyToJson:password];
       if(info.length > 0){
           dispatch_async(dispatch_get_main_queue(), ^{
               successCallback(@[info]);
           });
       }else {
           NSString *lastError = [dcapi dc_GetLastErr];
           dispatch_async(dispatch_get_main_queue(), ^{
               errorCallback(@[lastError]);
           });
       }
   });
}

//刷新网络
//ipAddr表示wifi局域网ip地址,如果是移动网络,传空就好,netChangeFlag 在启动时传入false,网络切换时传true
RCT_EXPORT_METHOD(dc_RefreshNet:(NSString*)ipAddr netChangeFlag:(NSString*)netChangeFlag successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
   RCTLogInfo(@"dc_RefreshNet");
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       BOOL success = [dcapi dc_RefreshNet:ipAddr netChangeFlag:[netChangeFlag isEqualToString:@"true"]];
       if(success){
           dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[@(success)]);
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
            NSLog(@"DCModule---------init---------========");
        }
    }
    return self;
}
@end



@implementation P2PHandlerModule
/**
 *为了实现RCTBridgeModule协议，你的类需要包含RCT_EXPORT_MODULE()宏。这个宏也可以添加一个参数用来指定在 JavaScript 中访问这个模块的名字。如果你不指定，默认就会使用这个 Objective-C 类的名字。如果类名以 RCT 开头，则 JavaScript 端引入的模块名会自动移除这个前缀。
 */
RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"receiveP2PMsg"];
}


//If_P2pMsgHandler
/**
 * 订阅消息
 */
- (void)pubSubEventHandler:(NSString * _Nullable)fromPeerId topic:(NSString * _Nullable)topic msg:(NSData * _Nullable)msg {
}

- (NSData * _Nullable)pubSubMsgHandler:(NSString * _Nullable)fromPeerId topic:(NSString * _Nullable)topic msg:(NSData * _Nullable)msg {
    return msg;
}

- (void)pubSubMsgResponseHandler:(NSString * _Nullable)msgId fromPeerId:(NSString * _Nullable)fromPeerId topic:(NSString * _Nullable)topic msg:(NSData * _Nullable)msg err:(NSString * _Nullable)err {
}

- (void)receiveMsg:(NSString * _Nullable)fromPeerId plaintextMsg:(NSData * _Nullable)plaintextMsg msg:(NSData * _Nullable)msg {
    NSLog(@"-------ReceiveMsg");
    SendMsgRequest *msgRequest = [SendMsgRequest parseFromData:msg error:NULL];
    
//    SendMsgRequest *msgRequest = [NSKeyedUnarchiver unarchiveObjectWithData:msg];
    NSLog(@"-------msgRequest");
    NSString *senderPubkey = [[NSString alloc] initWithData:msgRequest.senderPubkey encoding:NSUTF8StringEncoding];
    NSLog(@"-------senderPubkey: %@", senderPubkey);
    NSString *msgStr = [[NSString alloc] initWithData:plaintextMsg encoding:NSUTF8StringEncoding];
    NSLog(@"-------msgStr: %@", msgStr);
    // 创建一个JSON对象
    NSDictionary *jsonObject = @{
        @"sender": senderPubkey,
        @"msg": msgStr,
    };
    // 将JSON对象转换为NSData
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!jsonData) {
        NSLog(@"Error creating JSON: %@", error);
    } else {
        // 将NSData转换为字符串
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"JSON String: %@", jsonString);
        [customEventsEmitter sendEventName:@"receiveP2PMsg" body:jsonString];
    }
    
}




// If_P2pStreamHandler
//- (void)OnStreamConncetRequest:(NSString*)fromPeerId handle:(P2PHandlerModule*)handle {
//    NSLog(@"-------OnStreamConncetRequest");
//}
//- (void)OnDataRecv:(NSArray*)msg {
//    NSLog(@"-------OnDataRecv");
//}
//- (void)OnStreamClose:(NSString*)err {
//    NSLog(@"-------OnStreamClose");
//}
//- (void)updateTransmitSize:(long)status size:(int64_t)size { 
//    NSLog(@"-------updateTransmitSize");
//}


@end

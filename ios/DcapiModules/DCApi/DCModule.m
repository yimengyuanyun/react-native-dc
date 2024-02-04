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
 NSString *key = [dcapi dc_GenerateSymmetricKey];
 RCTLogInfo(@"dc_GenerateSymmetricKey %@", key);
 successCallback(@[key]);
}

//密钥加密
RCT_EXPORT_METHOD(dc_EncryptData:(NSString*)data pin:(NSString*)pin successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
 RCTLogInfo(@"dc_EncryptData");
  NSData *byteData = [data dataUsingEncoding:NSUTF8StringEncoding];
  NSData *bytePin = [pin dataUsingEncoding:NSUTF8StringEncoding];
  NSData *key = [dcapi dc_EncryptData:byteData key:bytePin];
  if(key == nil){
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }else {
    NSData *base64Data = [key base64EncodedDataWithOptions:0];
    NSString * str  =[[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    successCallback(@[str]);
  }
}

//密钥解密
RCT_EXPORT_METHOD(dc_DecryptData:(NSString*)baseData pin:(NSString*)pin successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
 RCTLogInfo(@"dc_DecryptData");
  NSData *byteData = [[NSData alloc]initWithBase64EncodedString:baseData options:NSDataBase64DecodingIgnoreUnknownCharacters];
  NSData *bytePin = [pin dataUsingEncoding:NSUTF8StringEncoding];
  NSData *key = [dcapi dc_DecryptData:byteData key:bytePin];
  if(key == nil){
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }else {
    NSString * str  =[[NSString alloc] initWithData:key encoding:NSUTF8StringEncoding];
    successCallback(@[str]);
  }
}

// 初始化
RCT_EXPORT_METHOD(dc_ApiInit:(NSString*)DCAPPName dir:(NSString*)dir region:(NSString*)region  key:(NSString*)key successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback){
  NSString *apppath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
  NSString *userpath = [apppath stringByAppendingPathComponent:dir];
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
      successCallback(@[webport]);
    }else{
      NSString *lastError = [dcapi dc_GetLastErr];
      RCTLogInfo(@"返回lastError: %@", lastError);
      errorCallback(@[lastError]);
    }
  }else{
      errorCallback(@[]);
  }
}

//加载默认用户信息
RCT_EXPORT_METHOD(dc_LoadDefaultUserInfo:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
 RCTLogInfo(@"dc_LoadDefaultUserInfo");
  BOOL load = [dcapi dc_LoadDefaultUserInfo];
  if(load){
    successCallback(@[@true]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
}

//设置用户默认数据库上链
RCT_EXPORT_METHOD(dc_SetUserDefaultDB:(NSString*)threadid rk:(NSString*)rk sk:(NSString*)sk successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
 RCTLogInfo(@"dc_SetUserDefaultDB");
  BOOL load = [dcapi dc_SetUserDefaultDB:threadid b32Rk:rk b32Sk:sk];
  if(load){
    successCallback(@[threadid]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
}

//获取当前接入的webport
RCT_EXPORT_METHOD(dc_GetLocalWebports:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
 RCTLogInfo(@"dc_SetUserDefaultDB");
  NSString *localWebports = [dcapi dc_GetLocalWebports];
  if(localWebports.length > 0){
    successCallback(@[localWebports]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
}

//设置默认区块链代理节点
RCT_EXPORT_METHOD(dc_SetDefaultChainProxy:(NSString*)chainProxyUrl  successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
  RCTLogInfo(@"dc_SetDefaultChainProxy");
  BOOL load = [dcapi dc_SetDefaultChainProxy:chainProxyUrl];
  if(load){
    successCallback(@[@true]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
}

//获取默认区块链代理节点
RCT_EXPORT_METHOD(dc_GetDefaultChainProxy:(RCTResponseSenderBlock)successCallback) {
  RCTLogInfo(@"dc_GetDefaultChainProxy");
  NSString *defaultChainProxy = [dcapi dc_GetDefaultChainProxy];
  successCallback(@[defaultChainProxy]);
}

//获取区块链代理节点列表
RCT_EXPORT_METHOD(dc_GetChainProxys:(RCTResponseSenderBlock)successCallback) {
  RCTLogInfo(@"dc_GetChainProxys");
  NSString *chainProxys = [dcapi dc_GetChainProxys];
  successCallback(@[chainProxys]);
}

//获取在线的存储节点接入地址列表
RCT_EXPORT_METHOD(dc_GetOnlinePeers:(RCTResponseSenderBlock)successCallback) {
  RCTLogInfo(@"dc_GetOnlinePeers");
  NSString *onlinePeers = [dcapi dc_GetOnlinePeers];
  successCallback(@[onlinePeers]);
}

//获取当前存储节点接入地址列表
RCT_EXPORT_METHOD(dc_GetBootPeers:(RCTResponseSenderBlock)successCallback) {
  RCTLogInfo(@"dc_GetBootPeers");
  NSString *multiaddrs = [dcapi dc_GetBootPeers];
  successCallback(@[multiaddrs]);
}

//增加接入存储节点记录
RCT_EXPORT_METHOD(dc_AddBootAddrs:(NSString*)multiaddr  successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
  RCTLogInfo(@"dc_AddBootAddrs");
  BOOL load = [dcapi dc_AddBootAddrs:multiaddr];
  if(load){
    successCallback(@[@true]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
}

//删除指定的接入存储节点记录
RCT_EXPORT_METHOD(dc_DeleteBootAddrs:(NSString*)multiaddr successCallback:(RCTResponseSenderBlock)successCallback) {
  RCTLogInfo(@"dc_DeleteBootAddrs");
  BOOL success = [dcapi dc_DeleteBootAddrs:multiaddr];
  successCallback(@[@(success)]);
}

//切换接入的DC服务节点
RCT_EXPORT_METHOD(dc_SwitchDcServer:(NSString*)multiaddr  successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
  RCTLogInfo(@"dc_SwitchDcServer");
  BOOL load = [dcapi dc_SwitchDcServer:multiaddr];
  if(load){
    successCallback(@[@true]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
}

//获取当前接入的DC服务节点
RCT_EXPORT_METHOD(dc_GetConnectedDcNetInfo:(RCTResponseSenderBlock)successCallback) {
  RCTLogInfo(@"dc_GetConnectedDcNetInfo");
  NSString *dcNetInfo = [dcapi dc_GetConnectedDcNetInfo];
  successCallback(@[dcNetInfo]);
}

//获取当前生效的私钥（返回16进制字符串）
RCT_EXPORT_METHOD(dc_GetEd25519AppPrivateKey:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
  RCTLogInfo(@"dc_GetEd25519AppPrivateKey");
  NSString *privateKey = [dcapi dc_GetEd25519AppPrivateKey];
  if(privateKey.length > 0){
    successCallback(@[privateKey]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
}

//获取当前生效key关联的助记词
RCT_EXPORT_METHOD(dc_GetMnemonic:(RCTResponseSenderBlock)successCallback) {
  RCTLogInfo(@"dc_GetMnemonic");
  NSString *mnemonic = [dcapi dc_GetMnemonic];
  successCallback(@[mnemonic]);
}

//导入私钥，privatekey 16进制字符串
RCT_EXPORT_METHOD(dc_ImportEd25519PrivateKey:(NSString*)privateKey successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
  RCTLogInfo(@"dc_ImportEd25519PrivateKey");
  BOOL success = [dcapi dc_ImportEd25519PrivateKey:privateKey];
  if(success){
    successCallback(@[@true]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
}

//导入助记词
RCT_EXPORT_METHOD(dc_ImportMnemonic:(NSString*)mnemonic successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
  RCTLogInfo(@"dc_ImportMnemonic");
  BOOL success = [dcapi dc_ImportMnemonic:mnemonic];
  if(success){
    successCallback(@[@true]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
}

//给账户添加余额
RCT_EXPORT_METHOD(dc_AddBalanceForTest:(NSString*)balance successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
  RCTLogInfo(@"dc_AddBalanceForTest");
  BOOL success = [dcapi dc_AddBalanceForTest:[balance longLongValue]];
  if(success){
    successCallback(@[@true]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
}

//获取用户信息
RCT_EXPORT_METHOD(dc_GetUserInfo:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
  RCTLogInfo(@"dc_GetUserInfo");
  NSString *jsonUserInfo = [dcapi dc_GetUserInfo];
  if(jsonUserInfo.length > 0){
    successCallback(@[jsonUserInfo]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
}

//应用账号是否已经创建
RCT_EXPORT_METHOD(dc_IfAppAcountExist:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
  RCTLogInfo(@"dc_IfAppAcountExist");
  BOOL success = [dcapi dc_IfAppAcountExist];
  if(success){
    successCallback(@[@true]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
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
  NSString *apppath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
  NSString *userpath = [apppath stringByAppendingPathComponent:dir];
  NSError *error = nil;
  BOOL success = YES;
  if (![[NSFileManager defaultManager] fileExistsAtPath:userpath]){
    success = [[NSFileManager defaultManager] removeItemAtPath:userpath error:&error];
  }
  successCallback(@[@(success)]);
}

//添加/生成应用账号
RCT_EXPORT_METHOD(dc_GenerateAppAccount:(NSString*)appId successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
  RCTLogInfo(@"dc_GenerateAppAccount");
  NSString *basePrivKey = [dcapi dc_GenerateAppAccount:appId];
  if(basePrivKey.length > 0){
    successCallback(@[basePrivKey]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
}

//account转address
RCT_EXPORT_METHOD(dc_GetSS58AddressForAccount:(NSString*)account successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
 RCTLogInfo(@"dc_GetSS58AddressForAccount");
 NSString *address = [dcapi dc_GetSS58AddressForAccount:account];
 if(address.length > 0){
   successCallback(@[address]);
 }else {
   NSString *lastError = [dcapi dc_GetLastErr];
   errorCallback(@[lastError]);
 }
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

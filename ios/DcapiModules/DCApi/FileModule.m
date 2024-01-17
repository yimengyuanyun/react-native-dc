//
//  FileModule.m
//  PrivatePhotos
//
//  Created by 王琴 on 2023/6/20.
//
#import "FileModule.h"
#import <React/RCTLog.h>//调用输出的方法
#import <React/RCTConvert.h>
#import "DcapiModules.h"



//@interface FileModule ()
//@end


@implementation FileModule

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

// 添加文件
//添加文件AddParams 应该包含是否加密选项，以及密钥
RCT_EXPORT_METHOD(file_AddFile:(NSString*)readPath enkey:(NSString*)enkey successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
  RCTLogInfo(@"file_AddFile");
  FileModuleFile *addfile = [[FileModuleFile alloc] initWithInfo:@"addFile" url:readPath];
  NSString *cid = [dcapi file_AddFile:readPath enkey:enkey fileTransmit:addfile];
  if(cid.length > 0){
    successCallback(@[cid]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
}

//获取文件应该指定获取文件存放目录，以及密钥（如果密钥是空，就表示不用解密）
// GetFile returns a reader to a file as identified by its root CID. The file
// must have been added as a UnixFS DAG (default for IPFS).
RCT_EXPORT_METHOD(file_GetFile:(NSString*)fid savePath:(NSString*)savePath dkey:(NSString*)dkey successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
  RCTLogInfo(@"file_GetFile");
    FileModuleFile *getfile = [[FileModuleFile alloc] initWithInfo:@"getFile" url:fid];
  BOOL success = [dcapi file_GetFile:fid savePath:savePath dkey:dkey fileTransmit:getfile];
  if(success > 0){
    successCallback(@[]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
}

// 删除文件
RCT_EXPORT_METHOD(file_CleanFile:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
  RCTLogInfo(@"file_CleanFile");
  BOOL success = [dcapi file_CleanFile];
  if(success){
    successCallback(@[@true]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
}
// 获取文件信息
RCT_EXPORT_METHOD(file_GetFileInfo:(NSString)fid successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
  RCTLogInfo(@"file_GetFileInfo");
  String fileInfo = [dcapi file_GetFileInfo:fid];
  if(fileInfo.length > 0){
    successCallback(@[fileInfo]);
  }else {
    NSString *lastError = [dcapi dc_GetLastErr];
    errorCallback(@[lastError]);
  }
}

// 删除文件
RCT_EXPORT_METHOD(file_DeleteFile:(NSString)fid successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
  RCTLogInfo(@"file_DeleteFile");
  BOOL success = [dcapi file_DeleteFile:fid];
  if(success){
    successCallback(@[]);
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
//- (void)sendEventWithName:(NSString *)name body:(id)body
//{
//  [self sendEventWithName:@"EventReminder" body:body];
//}
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
            NSLog(@"FileModule---------init---------========");
        }
    }
    return self;
}

@end




@implementation FileModuleFile
/**
 *为了实现RCTBridgeModule协议，你的类需要包含RCT_EXPORT_MODULE()宏。这个宏也可以添加一个参数用来指定在 JavaScript 中访问这个模块的名字。如果你不指定，默认就会使用这个 Objective-C 类的名字。如果类名以 RCT 开头，则 JavaScript 端引入的模块名会自动移除这个前缀。
 */
RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"EventReminder"];
}
-(id) initWithInfo:(NSString *)type url:(NSString *)url
{
    self = [super init];
    if(self)
    {
        self.filehandleType = type;
        self.fileUrl = url;
    }
    return self;
}
/**
 * 单个文件传输反馈 status 0:成功 1:转化为ipfs对象操作中 2:文件传输中 3:传输失败 4:异常
 */
- (void)updateTransmitSize:(long)status size:(int64_t)size {
    NSLog(@"-------updateTransmitSize11111");
    if(self.filehandleType != nil){
        NSLog(@"-------updateTransmitSize22222");
        [customEventsEmitter sendEventName:@"EventFile" body: [NSString stringWithFormat:@"{\"type\":\"%@\",\"url\": \"%@\",\"status\": \"%@\",\"size\": \"%@\"}", self.filehandleType, self.fileUrl, [NSString stringWithFormat: @"%ld", status], [NSString stringWithFormat: @"%lld", size]]];
    }
}
@end

//
//  DBModule.m
//  PrivatePhotos
//
//  Created by 王琴 on 2023/6/20.
//
#import "DBModule.h"
#import <React/RCTLog.h>//调用输出的方法
#import <React/RCTConvert.h>
#import <Dcapi/Dcapi.h>
#import "DcapiModules.h"


@interface DBModule ()
@end


@implementation DBModule
/**
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
// 创建数据库DB
RCT_EXPORT_METHOD(db_NewThreadDB:(NSString*)dbname rk:(NSString*)rk sk:(NSString*)sk jsonCollections:(NSString*)jsonCollections  successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RCTLogInfo(@"db_NewThreadDB");
        NSString *threadid = [dcapi db_NewThreadDB:dbname b32Rk:rk b32Sk:sk jsonCollections:jsonCollections];
        if(threadid.length > 0){
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

// syncDBFromDC 从DC网络中同步数据库信息到本地（一般发生在新设备首次登录时同步已经创建的数据库）,jsonCollections 是一个map结构的json字符串，格式[{"name":"name1","schema":"schema1"},indexs:[{"path":"path1","unique":true},{"path":"path2","unique":false}],{"name":"name2","schema":"schema2"},...]
RCT_EXPORT_METHOD(db_SyncDBFromDC:(NSString*)threadid dbname:(NSString*)dbname dbAddr:(NSString*)dbAddr rk:(NSString*)rk sk:(NSString*)sk block:(BOOL)block jsonCollections:(NSString*)jsonCollections  successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"db_SyncDBFromDC");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [dcapi db_SyncDBFromDC:threadid dbname:dbname dbAddr:dbAddr b32Rk:rk b32Sk:sk block:block jsonCollections:jsonCollections];
        if(success){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

// 同步数据库数据到本地
RCT_EXPORT_METHOD(db_RefreshDBFromDC:(NSString*)threadid successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
  RCTLogInfo(@"db_RefreshDBFromDC");
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      BOOL success = [dcapi db_RefreshDBFromDC:threadid];
      if(success){
          dispatch_async(dispatch_get_main_queue(), ^{
              successCallback(@[]);
           });
      }else {
          NSString *lastError = [dcapi dc_GetLastErr];
          dispatch_async(dispatch_get_main_queue(), ^{
              errorCallback(@[lastError]);
           });
      }
  });
}

// 是否成功同步上传数据库DB
RCT_EXPORT_METHOD(db_IfSyncDBToDCSuccess:(NSString*)threadid successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"db_IfSyncDBToDCSuccess");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [dcapi db_IfSyncDBToDCSuccess:threadid];
        if(success){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

// 同步上传数据库DB
RCT_EXPORT_METHOD(db_SyncDBToDC:(NSString*)threadid successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"db_SyncDBToDC");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [dcapi db_SyncDBToDC:threadid];
        if(success){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

// 通过threadid获取db
RCT_EXPORT_METHOD(db_GetDBInfo:(NSString*)threadid successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"db_GetDBInfo");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *jsonDBInfo = [dcapi db_GetDBInfo:threadid];
        if(jsonDBInfo.length > 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[jsonDBInfo]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

// 创建数据表记录
RCT_EXPORT_METHOD(db_Create:(NSString*)threadid collectionName:(NSString*)collectionName jsonInstances:(NSString*)jsonInstances successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"db_Create");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *jsonInstanceids = [dcapi db_Create:threadid collectionName:collectionName jsonInstance:jsonInstances];
        if(jsonInstanceids.length > 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[jsonInstanceids]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

// 删除数据表记录
RCT_EXPORT_METHOD(db_Delete:(NSString*)threadid collectionName:(NSString*)collectionName instanceID:(NSString*)instanceID successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"db_Delete");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [dcapi db_Delete:threadid collectionName:collectionName instanceID:instanceID];
        if(success){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

// 更新数据表记录
RCT_EXPORT_METHOD(db_Save:(NSString*)threadid collectionName:(NSString*)collectionName instance:(NSString*)instance successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"db_Save");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [dcapi db_Save:threadid collectionName:collectionName instance:instance];
        if(success){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

// 删除多条记录
RCT_EXPORT_METHOD(db_DeleteMany:(NSString*)threadid collectionName:(NSString*)collectionName instanceIDs:(NSString*)instanceIDs successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"db_DeleteMany");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [dcapi db_DeleteMany:threadid collectionName:collectionName instanceIDs:instanceIDs];
        if(success){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

// 找到指定条件的数据表记录
RCT_EXPORT_METHOD(db_Find:(NSString*)threadid collectionName:(NSString*)collectionName queryString:(NSString*)queryString successCallback:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    RCTLogInfo(@"db_Find");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *jsonInstances = [dcapi db_Find:threadid collectionName:collectionName queryString:queryString];
        if(jsonInstances.length > 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[jsonInstances]);
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
            NSLog(@"DBModule---------init---------========");
        }
    }
    return self;
}
@end


#import "CommentModule.h"
#import <React/RCTLog.h>//调用输出的方法
#import <React/RCTConvert.h>
#import <Dcapi/Dcapi.h>
#import "DcapiModules.h"


@interface CommentModule ()
@end


@implementation CommentModule
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
 

// 配置或增加用户自身的评论空间 0:成功 1:失败
RCT_EXPORT_METHOD(comment_AddUserCommentSpace:(RCTResponseSenderBlock)successCallback errorCallback:(RCTResponseSenderBlock)errorCallback) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RCTLogInfo(@"comment_AddUserCommentSpace");
        BOOL success = [dcapi comment_AddUserCommentSpace];
        if(success){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[success]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

// 为指定对象开通评论功能，返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
RCT_EXPORT_METHOD(comment_AddCommentableObj:(NSString*)objCid openFlag:(long*)openFlag commentSpace:(long*)commentSpace successCallback:(RCTResponseSenderBlock)successCallback ) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RCTLogInfo(@"comment_AddCommentableObj");
        long res = [dcapi comment_AddCommentableObj:objCid openFlag:openFlag commentSpace:commentSpace];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[res]);
        });
    });
}

// 为开通评论的对象增加评论空间，返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
RCT_EXPORT_METHOD(comment_AddObjCommentSpace:(NSString*)objCid commentSpace:(long*)commentSpace successCallback:(RCTResponseSenderBlock)successCallback ) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RCTLogInfo(@"comment_AddObjCommentSpace");
        long res = [dcapi comment_AddObjCommentSpace:objCid commentSpace:commentSpace];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[res]);
        });
    });
}

// 关闭指定对象的评论功能（会删除所有针对该对象的评论），返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
RCT_EXPORT_METHOD(comment_DisableCommentObj:(NSString*)objCid successCallback:(RCTResponseSenderBlock)successCallback ) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RCTLogInfo(@"comment_DisableCommentObj");
        long res = [dcapi comment_DisableCommentObj:objCid];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[res]);
        });
    });
}

// 举报恶意评论（会删除所有针对该对象的评论），返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
RCT_EXPORT_METHOD(comment_ReportMaliciousComment:(NSString*)objCid commentBlockheight:(long)commentBlockheight commentCid:(NSString*)commentCid successCallback:(RCTResponseSenderBlock)successCallback ) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RCTLogInfo(@"comment_ReportMaliciousComment");
        long res = [dcapi comment_ReportMaliciousComment:objCid commentBlockheight:commentBlockheight, commentCid:commentCid];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[res]);
        });
    });
}

// 精选评论，让评论可见，返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
RCT_EXPORT_METHOD(comment_SetObjCommentPublic:(NSString*)objCid commentBlockheight:(long)commentBlockheight commentCid:(NSString*)commentCid successCallback:(RCTResponseSenderBlock)successCallback ) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RCTLogInfo(@"comment_SetObjCommentPublic");
        long res = [dcapi comment_SetObjCommentPublic:objCid commentBlockheight:commentBlockheight, commentCid:commentCid];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[res]);
        });
    });
}

// 发布对指定对象的评论，返回评论key,格式为:commentBlockHeight/commentCid
RCT_EXPORT_METHOD(comment_PublishCommentToObj:(NSString*)objCid objAuthor:(NSString*)objAuthor commentType:(long)commentType comment:(NSString)comment referCommentkey:(NSString*)referCommentkey openFlag:(long*)openFlag successCallback:(RCTResponseSenderBlock)successCallback ) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RCTLogInfo(@"comment_PublishCommentToObj");
        long res = [dcapi comment_PublishCommentToObj:objCid objAuthor:objAuthor commentType:commentType comment:comment referCommentkey:referCommentkey 
            openFlag:openFlag];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[res]);
        });
    });
}

// 删除已发布的评论，返回评论key,格式为:commentBlockHeight/commentCid
RCT_EXPORT_METHOD(comment_DeleteSelfComment:(NSString*)objCid objAuthor:(NSString*)objAuthor commentKey:(NSString*)commentKey successCallback:(RCTResponseSenderBlock)successCallback ) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RCTLogInfo(@"comment_DeleteSelfComment");
        BOOL success = [dcapi comment_DeleteSelfComment:objCid objAuthor:objAuthor commentKey:commentKey];
        if(success){
            dispatch_async(dispatch_get_main_queue(), ^{
                successCallback(@[success]);
            });
        }else {
            NSString *lastError = [dcapi dc_GetLastErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                errorCallback(@[lastError]);
            });
        }
    });
}

// 获取指定用户已开通评论的对象列表
// 返回已开通评论的对象列表,格式：[{"objCid":"YmF...bXk=","appId":"dGVzdGFwcA==","blockheight":2904,"commentSpace":1000,"userPubkey":"YmJh...vZGU=","signature":"oCY1...Y8sO/lkDac/nLu...Rm/xm...CQ=="}]
RCT_EXPORT_METHOD(comment_GetCommentableObj:(NSString*)objAuthor startBlockheight:(long)startBlockheight direction:(long)direction 
        offset:(long)offset seekKey:(NSString*)seekKey limit:(long)limit successCallback:(RCTResponseSenderBlock)successCallback ) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RCTLogInfo(@"comment_GetCommentableObj");
        long res = [dcapi comment_GetCommentableObj:objAuthor startBlockheight:startBlockheight direction:direction 
          offset:offset seekKey:seekKey limit:limit];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[res]);
        });
    });
}

// 取指定已开通对象的评论列表
// 返回已开通评论的对象列表,格式：[{"objCid":"YmF...bXk=","appId":"dGVzdGFwcA==","blockheight":2904,"commentSpace":1000,"userPubkey":"YmJh...vZGU=","signature":"oCY1...Y8sO/lkDac/nLu...Rm/xm...CQ=="}]
RCT_EXPORT_METHOD(comment_GetObjComments:objCid objAuthor:(NSString*)objAuthor startBlockheight:(long)startBlockheight direction:(long)direction 
        offset:(long)offset seekKey:(NSString*)seekKey limit:(long)limit successCallback:(RCTResponseSenderBlock)successCallback ) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RCTLogInfo(@"comment_GetObjComments");
        long res = [dcapi comment_GetObjComments:objCid objAuthor:objAuthor startBlockheight:startBlockheight direction:direction 
          offset:offset seekKey:seekKey limit:limit];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[res]);
        });
    });
}

// 获取指定用户发布过的评论，私密评论只有评论者和被评论者可见
// 返回用户评论列表，格式：[{"ObjCid":"bafk...fpy","AppId":"testapp","ObjAuthor":"bbaa...jkhmm","Blockheight":3209,"UserPubkey":"bba...2hzm","CommentCid":"baf...2aygu","Comment":"hello
// world","CommentSize":11,"Status":0,"Signature":"bkqy...b6dkda","Refercommentkey":"","CCount":0,"UpCount":0,"DownCount":0,"TCount":0}]
RCT_EXPORT_METHOD(comment_GetUserComments:userPubkey startBlockheight:(long)startBlockheight direction:(long)direction 
        offset:(long)offset seekKey:(NSString*)seekKey limit:(long)limit successCallback:(RCTResponseSenderBlock)successCallback ) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RCTLogInfo(@"comment_GetUserComments");
        long res = [dcapi comment_GetUserComments:userPubkey startBlockheight:startBlockheight direction:direction 
          offset:offset seekKey:seekKey limit:limit];
        dispatch_async(dispatch_get_main_queue(), ^{
            successCallback(@[res]);
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
            NSLog(@"CommentModule---------init---------========");
        }
    }
    return self;
}
@end

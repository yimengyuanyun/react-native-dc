package com.dcApi;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import dcapi.Dcapi_;

/**
 * 评论
 */
public class CommentModule extends ReactContextBaseJavaModule {

  private static ReactApplicationContext reactContext;
  public Dcapi_ dcClass;

  public CommentModule(ReactApplicationContext context, Dcapi_ dc) {
    super(context);
    reactContext = context;
    dcClass = dc;
  }

  @NonNull
  @Override
  public String getName() {
    return "CommentModule";
  }

  // 配置或增加用户自身的评论空间 0:成功 1:失败
  @ReactMethod
  public void comment_AddUserCommentSpace(
      Callback successCallback,
      Callback errorCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_AddUserCommentSpace");
        Boolean bool = dcClass.comment_AddUserCommentSpace();
        System.out.println("---------------------------------comment_AddUserCommentSpace");
        if (bool) {
          successCallback.invoke(bool);
        } else {
          String lastError = dcClass.dc_GetLastErr();
          System.out.println("---------------------------------comment_AddUserCommentSpace: err");
          System.out.println(lastError);
          errorCallback.invoke(lastError);
        }
      }
    }).start();
  }

  // 为指定对象开通评论功能，返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
  @ReactMethod
  public void comment_AddCommentableObj(
      String objCid, // 要开通评论对象的cid
      long openFlag, // 是否公开，0-公开，1-私密，2-可鉴权
      long commentSpace, // 评论空间大小
      Callback successCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_AddCommentableObj");
        long res = dcClass.comment_AddCommentableObj(objCid, openFlag, commentSpace);
        System.out.println("---------------------------------comment_AddCommentableObj", res);
        successCallback.invoke(Long.toString(res));
      }
    }).start();
  }

  // 为开通评论的对象增加评论空间，返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
  @ReactMethod
  public void comment_AddObjCommentSpace(
      String objCid, // 要开通评论对象的cid
      long commentSpace, // 评论空间大小
      Callback successCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_AddObjCommentSpace");
        long res = dcClass.comment_AddObjCommentSpace(objCid, commentSpace);
        System.out.println("---------------------------------comment_AddObjCommentSpace", res);
        successCallback.invoke(Long.toString(res));
      }
    }).start();
  }

  // 关闭指定对象的评论功能（会删除所有针对该对象的评论），返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
  @ReactMethod
  public void comment_DisableCommentObj(
      String objCid, // 要开通评论对象的cid
      Callback successCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_DisableCommentObj");
        long res = dcClass.comment_DisableCommentObj(objCid);
        System.out.println("---------------------------------comment_DisableCommentObj", res);
        successCallback.invoke(Long.toString(res));
      }
    }).start();
  }

  // 举报恶意评论（会删除所有针对该对象的评论），返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
  @ReactMethod
  public void comment_ReportMaliciousComment(
      String objCid, // 要开通评论对象的cid
      long commentBlockheight, // 评论所在区块高度
      String commentCid, // 评论id
      Callback successCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_ReportMaliciousComment");
        long res = dcClass.comment_ReportMaliciousComment(objCid, commentBlockheight, commentCid);
        System.out.println("---------------------------------comment_ReportMaliciousComment", res);
        successCallback.invoke(Long.toString(res));
      }
    }).start();
  }

  // 精选评论，让评论可见，返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
  @ReactMethod
  public void comment_SetObjCommentPublic(
      String objCid, // 要开通评论对象的cid
      long commentBlockheight, // 评论所在区块高度
      String commentCid, // 评论id
      Callback successCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_SetObjCommentPublic");
        long res = dcClass.comment_SetObjCommentPublic(objCid, commentBlockheight, commentCid);
        System.out.println("---------------------------------comment_SetObjCommentPublic", res);
        successCallback.invoke(Long.toString(res));
      }
    }).start();
  }

  // 发布对指定对象的评论，返回评论key,格式为:commentBlockHeight/commentCid
  @ReactMethod
  public void comment_PublishCommentToObj(
      String objCid, // 要开通评论对象的cid
      String objAuthor, // 被发布评论的对象的用户pubkey base32编码,或者pubkey经过libp2p-crypto protobuf编码后再base32编码
      long commentType, // 评论类型 0:普通评论 1:点赞 2:推荐 3:踩
      String comment, // 评论内容
      String referCommentkey, // 被引用的评论
      long openFlag, // 开放标志 0-开放 1-私密
      Callback successCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_PublishCommentToObj");
        String res = dcClass.comment_PublishCommentToObj(objCid, objAuthor, commentType, comment, referCommentkey,
            openFlag);
        System.out.println("---------------------------------comment_PublishCommentToObj");
        successCallback.invoke(res);
      }
    }).start();
  }

  // 删除已发布的评论，返回评论key,格式为:commentBlockHeight/commentCid
  @ReactMethod
  public void comment_DeleteSelfComment(
      String objCid, // 要开通评论对象的cid
      String objAuthor, // 被发布评论的对象的用户pubkey base32编码,或者pubkey经过libp2p-crypto protobuf编码后再base32编码
      long commentKey, // 要删除的评论key
      Callback successCallback,
      Callback errorCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_DeleteSelfComment");
        Boolean bool = dcClass.comment_DeleteSelfComment(objCid, objAuthor, commentKey);
        System.out.println("---------------------------------comment_DeleteSelfComment");
        if (bool) {
          successCallback.invoke(bool);
        } else {
          String lastError = dcClass.dc_GetLastErr();
          System.out.println("---------------------------------comment_DeleteSelfComment: err");
          System.out.println(lastError);
          errorCallback.invoke(lastError);
        }
      }
    }).start();
  }

  // 获取指定用户已开通评论的对象列表
  // 返回已开通评论的对象列表,格式：[{"objCid":"YmF...bXk=","appId":"dGVzdGFwcA==","blockheight":2904,"commentSpace":1000,"userPubkey":"YmJh...vZGU=","signature":"oCY1...Y8sO/lkDac/nLu...Rm/xm...CQ=="}]
  @ReactMethod
  public void comment_GetCommentableObj(
      String objAuthor, // 被发布评论的对象的用户pubkey base32编码,或者pubkey经过libp2p-crypto protobuf编码后再base32编码
      long startBlockheight, // 开始区块高度
      long direction, // 方向 0:向前 1:向后
      long offset, // 偏移量
      String seekKey, // 起始key
      long limit, // 限制条数
      Callback successCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_GetCommentableObj");
        String res = dcClass.comment_GetCommentableObj(objAuthor, startBlockheight, direction, offset,
            seekKey, limit);
        System.out.println("---------------------------------comment_GetCommentableObj");
        successCallback.invoke(res);
      }
    }).start();
  }

  // 取指定已开通对象的评论列表
  // 返回已开通评论的对象列表,格式：[{"objCid":"YmF...bXk=","appId":"dGVzdGFwcA==","blockheight":2904,"commentSpace":1000,"userPubkey":"YmJh...vZGU=","signature":"oCY1...Y8sO/lkDac/nLu...Rm/xm...CQ=="}]
  @ReactMethod
  public void comment_GetObjComments(
      String objCid, // 评论对象的cid
      String objAuthor, // 被发布评论的对象的用户pubkey base32编码,或者pubkey经过libp2p-crypto protobuf编码后再base32编码
      long startBlockheight, // 开始区块高度
      long direction, // 方向 0:向前 1:向后
      long offset, // 偏移量
      String seekKey, // 起始key
      long limit, // 限制条数
      Callback successCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_GetObjComments");
        String res = dcClass.comment_GetObjComments(objCid, objAuthor, startBlockheight, direction, offset,
            seekKey, limit);
        System.out.println("---------------------------------comment_GetObjComments");
        successCallback.invoke(res);
      }
    }).start();
  }

  // 获取指定用户发布过的评论，私密评论只有评论者和被评论者可见
  // 返回用户评论列表，格式：[{"ObjCid":"bafk...fpy","AppId":"testapp","ObjAuthor":"bbaa...jkhmm","Blockheight":3209,"UserPubkey":"bba...2hzm","CommentCid":"baf...2aygu","Comment":"hello
  // world","CommentSize":11,"Status":0,"Signature":"bkqy...b6dkda","Refercommentkey":"","CCount":0,"UpCount":0,"DownCount":0,"TCount":0}]
  @ReactMethod
  public void comment_GetUserComments(
      String userPubkey, // 用户pubkey base32编码,或者pubkey经过libp2p-crypto
                         // protobuf编码后再base32编码或者账号的16进制编码(0x开头)
      long startBlockheight, // 开始区块高度
      long direction, // 方向 0:向前 1:向后
      long offset, // 偏移量
      String seekKey, // 起始key
      long limit, // 限制条数
      Callback successCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_GetUserComments");
        String res = dcClass.comment_GetUserComments(userPubkey, startBlockheight, direction, offset,
            seekKey, limit);
        System.out.println("---------------------------------comment_GetUserComments");
        successCallback.invoke(res);
      }
    }).start();
  }
}

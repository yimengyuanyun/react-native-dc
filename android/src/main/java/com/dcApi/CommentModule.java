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

  // 配置或增加用户自身的评论空间
  @ReactMethod
  public void comment_AddUserOffChainSpace(
      Callback successCallback,
      Callback errorCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_AddUserOffChainSpace");
        Boolean bool = dcClass.comment_AddUserOffChainSpace();
        System.out.println("---------------------------------comment_AddUserOffChainSpace");
        if (bool) {
          successCallback.invoke(bool);
        } else {
          String lastError = dcClass.dc_GetLastErr();
          System.out.println("---------------------------------comment_AddUserOffChainSpace: err");
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
      String openFlag, // 是否公开，0-公开，1-私密，2-可鉴权
      String commentSpace, // 评论空间大小
      Callback successCallback,
      Callback errorCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_AddCommentableObj");
        long res = dcClass.comment_AddCommentableObj(objCid, Long.parseLong(openFlag), Long.parseLong(commentSpace));
        System.out.println("---------------------------------comment_AddCommentableObj");
        if (res > -1) {
          successCallback.invoke(Long.toString(res));
        } else {
          String lastError = dcClass.dc_GetLastErr();
          System.out.println("---------------------------------comment_AddUserOffChainSpace: err");
          System.out.println(lastError);
          errorCallback.invoke(lastError);
        }
      }
    }).start();
  }

  // 为开通评论的对象增加评论空间，返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
  @ReactMethod
  public void comment_AddObjCommentSpace(
      String objCid, // 要开通评论对象的cid
      String commentSpace, // 评论空间大小
      Callback successCallback,
      Callback errorCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_AddObjCommentSpace");
        long res = dcClass.comment_AddObjCommentSpace(objCid, Long.parseLong(commentSpace));
        System.out.println("---------------------------------comment_AddObjCommentSpace");
        if (res > -1) {
          successCallback.invoke(Long.toString(res));
        } else {
          String lastError = dcClass.dc_GetLastErr();
          System.out.println("---------------------------------comment_AddObjCommentSpace: err");
          System.out.println(lastError);
          errorCallback.invoke(lastError);
        }
      }
    }).start();
  }

  // 关闭指定对象的评论功能（会删除所有针对该对象的评论），返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
  @ReactMethod
  public void comment_DisableCommentObj(
      String objCid, // 要开通评论对象的cid
      Callback successCallback,
      Callback errorCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_DisableCommentObj");
        long res = dcClass.comment_DisableCommentObj(objCid);
        System.out.println("---------------------------------comment_DisableCommentObj");
        if (res > -1) {
          successCallback.invoke(Long.toString(res));
        } else {
          String lastError = dcClass.dc_GetLastErr();
          System.out.println("---------------------------------comment_DisableCommentObj: err");
          System.out.println(lastError);
          errorCallback.invoke(lastError);
        }
      }
    }).start();
  }

  // 举报恶意评论（会删除所有针对该对象的评论），返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
  @ReactMethod
  public void comment_ReportMaliciousComment(
      String objCid, // 要开通评论对象的cid
      String commentBlockheight, // 评论所在区块高度
      String commentCid, // 评论id
      Callback successCallback,
      Callback errorCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_ReportMaliciousComment");
        long res = dcClass.comment_ReportMaliciousComment(objCid, Long.parseLong(commentBlockheight), commentCid);
        System.out.println("---------------------------------comment_ReportMaliciousComment");
        if (res > -1) {
          successCallback.invoke(Long.toString(res));
        } else {
          String lastError = dcClass.dc_GetLastErr();
          System.out.println("---------------------------------comment_ReportMaliciousComment: err");
          System.out.println(lastError);
          errorCallback.invoke(lastError);
        }
      }
    }).start();
  }

  // 精选评论，让评论可见，返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
  @ReactMethod
  public void comment_SetObjCommentPublic(
      String objCid, // 要开通评论对象的cid
      String commentBlockheight, // 评论所在区块高度
      String commentCid, // 评论id
      Callback successCallback,
      Callback errorCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_SetObjCommentPublic");
        long res = dcClass.comment_SetObjCommentPublic(objCid, Long.parseLong(commentBlockheight), commentCid);
        System.out.println("---------------------------------comment_SetObjCommentPublic");
        if (res > -1) {
          successCallback.invoke(Long.toString(res));
        } else {
          String lastError = dcClass.dc_GetLastErr();
          System.out.println("---------------------------------comment_SetObjCommentPublic: err");
          System.out.println(lastError);
          errorCallback.invoke(lastError);
        }
      }
    }).start();
  }

  // 发布对指定对象的评论，返回评论key,格式为:commentBlockHeight/commentCid
  @ReactMethod
  public void comment_PublishCommentToObj(
      String objCid, // 要开通评论对象的cid
      String objAuthor, // 被发布评论的对象的用户pubkey base32编码,或者pubkey经过libp2p-crypto protobuf编码后再base32编码
      String commentType, // 评论类型 0:普通评论 1:点赞 2:推荐 3:踩
      String comment, // 评论内容
      String referCommentkey, // 被引用的评论
      String openFlag, // 开放标志 0-开放 1-私密
      Callback successCallback,
      Callback errorCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_PublishCommentToObj");
        String res = dcClass.comment_PublishCommentToObj(objCid, objAuthor, Long.parseLong(commentType), comment, referCommentkey,
          Long.parseLong(openFlag));
        System.out.println("---------------------------------comment_PublishCommentToObj");
        if (res.length() >0) {
          successCallback.invoke(res);
        } else {
          String lastError = dcClass.dc_GetLastErr();
          System.out.println("---------------------------------comment_PublishCommentToObj: err");
          System.out.println(lastError);
          errorCallback.invoke(lastError);
        }
      }
    }).start();
  }

  // 删除已发布的评论
  @ReactMethod
  public void comment_DeleteSelfComment(
      String objCid, // 要开通评论对象的cid
      String objAuthor, // 被发布评论的对象的用户pubkey base32编码,或者pubkey经过libp2p-crypto protobuf编码后再base32编码
      String commentKey, // 要删除的评论key
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
      String startBlockheight, // 开始区块高度
      String direction, // 方向 0:向前 1:向后
      String offset, // 偏移量
      String seekKey, // 起始key
      String limit, // 限制条数
      Callback successCallback,
      Callback errorCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_GetCommentableObj");
        String res = dcClass.comment_GetCommentableObj(objAuthor, Long.parseLong(startBlockheight), Long.parseLong(direction), Long.parseLong(offset),
            seekKey, Long.parseLong(limit));
        System.out.println("---------------------------------comment_GetCommentableObj");
        if (res.length() > 0) {
          successCallback.invoke(res);
        } else {
          String lastError = dcClass.dc_GetLastErr();
          System.out.println("---------------------------------comment_GetCommentableObj: err");
          System.out.println(lastError);
          if(lastError.length() > 0) {
            errorCallback.invoke(lastError);
          } else {
            successCallback.invoke("");
          }
        }
      }
    }).start();
  }

  // 取指定已开通对象的评论列表
  // 返回已开通评论的对象列表,格式：[{"objCid":"YmF...bXk=","appId":"dGVzdGFwcA==","blockheight":2904,"commentSpace":1000,"userPubkey":"YmJh...vZGU=","signature":"oCY1...Y8sO/lkDac/nLu...Rm/xm...CQ=="}]
  @ReactMethod
  public void comment_GetObjComments(
      String objCid, // 评论对象的cid
      String objAuthor, // 被发布评论的对象的用户pubkey base32编码,或者pubkey经过libp2p-crypto protobuf编码后再base32编码
      String startBlockheight, // 开始区块高度
      String direction, // 方向 0:向前 1:向后
      String offset, // 偏移量
      String seekKey, // 起始key
      String limit, // 限制条数
      Callback successCallback,
      Callback errorCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_GetObjComments");
        String res = dcClass.comment_GetObjComments(objCid, objAuthor, Long.parseLong(startBlockheight),  Long.parseLong(direction), Long.parseLong(offset),
            seekKey, Long.parseLong(limit));
        System.out.println("---------------------------------comment_GetObjComments");
        if (res.length() > 0) {
          successCallback.invoke(res);
        } else {
          String lastError = dcClass.dc_GetLastErr();
          System.out.println("---------------------------------comment_GetObjComments: err");
          System.out.println(lastError);
          if(lastError.length() > 0) {
            errorCallback.invoke(lastError);
          } else {
            successCallback.invoke("");
          }
        }
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
      String startBlockheight, // 开始区块高度
      String direction, // 方向 0:向前 1:向后
      String offset, // 偏移量
      String seekKey, // 起始key
      String limit, // 限制条数
      Callback successCallback,
      Callback errorCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_GetUserComments");
        String res = dcClass.comment_GetUserComments(userPubkey, Long.parseLong(startBlockheight),  Long.parseLong(direction), Long.parseLong(offset),
            seekKey, Long.parseLong(limit));
        System.out.println("---------------------------------comment_GetUserComments");
        if (res.length() > 0) {
          successCallback.invoke(res);
        } else {
          String lastError = dcClass.dc_GetLastErr();
          System.out.println("---------------------------------comment_GetUserComments: err");
          System.out.println(lastError);
          if(lastError.length() > 0) {
            errorCallback.invoke(lastError);
          } else {
            successCallback.invoke("");
          }
        }
      }
    }).start();
  }

  // 设置缓存key数据
  @ReactMethod
  public void comment_SetCacheKey(
      String value, // 缓存key对应的数据
      String expire, // 缓存key的过期时间，单位秒
      Callback successCallback,
      Callback errorCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_SetCacheKey");
        String res = dcClass.comment_SetCacheKey(value, Long.parseLong(expire));
        System.out.println("---------------------------------comment_SetCacheKey");
        if (res.length() > 0) {
          successCallback.invoke(res);
        } else {
          String lastError = dcClass.dc_GetLastErr();
          System.out.println("---------------------------------comment_SetCacheKey: err");
          System.out.println(lastError);
          errorCallback.invoke(lastError);
        }
      }
    }).start();
  }

  // 获取缓存数据
  @ReactMethod
  public void comment_GetCacheValue(
      String key, // 对应缓存key
      Callback successCallback,
      Callback errorCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start comment_GetCacheValue");
        String res = dcClass.comment_GetCacheValue(key);
        System.out.println("---------------------------------comment_GetCacheValue");
        if (res.length() > 0) {
          successCallback.invoke(res);
        } else {
          String lastError = dcClass.dc_GetLastErr();
          System.out.println("---------------------------------comment_GetCacheValue: err");
          System.out.println(lastError);
          if(lastError.length() > 0) {
            errorCallback.invoke(lastError);
          } else {
            successCallback.invoke("");
          }
        }
      }
    }).start();
  }
}

package com.dcApi;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import dcapi.Dcapi_;

/**
 * 消息
 */
public class MsgModule extends ReactContextBaseJavaModule {

  private static ReactApplicationContext reactContext;
  public Dcapi_ dcClass;

  public MsgModule(ReactApplicationContext context, Dcapi_ dc) {
    super(context);
    reactContext = context;
    dcClass = dc;
  }

  @NonNull
  @Override
  public String getName() {
    return "MsgModule";
  }

  // 向指定用户发送消息 res 0:在线消息发送成功，1:离线消息发送成功（应用根据需要自行接推送服务）2:消息发送失败）
  @ReactMethod
  public void msg_SendMsg(
      String receiver, // 接收者16进制的账号或base32编码的pubkey  
      String msg, // 要发送的消息
      Callback successCallback,
      Callback errorCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start msg_SendMsg");
        long res = dcClass.msg_SendMsg(receiver, msg);
        System.out.println("---------------------------------msg_SendMsg");
        if (res > -1) {
          successCallback.invoke(Long.toString(res));
        } else {
          String lastError = dcClass.dc_GetLastErr();
          System.out.println("---------------------------------msg_SendMsg: err");
          System.out.println(lastError);
          errorCallback.invoke(lastError);
        }
      }
    }).start();
  }

  // 从用户收件箱收取离线消息 
  @ReactMethod
  public void msg_GetMsgFromUserBox(
      String limit,  // 一次最多提取多少条离线消息，最多500条每次
      Callback successCallback,
      Callback errorCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start msg_GetMsgFromUserBox");
        String res = dcClass.msg_GetMsgFromUserBox(Long.parseLong(limit));
        System.out.println("---------------------------------msg_GetMsgFromUserBox");
        if (res.length() > 0) {
          successCallback.invoke(res);
        } else {
          String lastError = dcClass.dc_GetLastErr();
          System.out.println("---------------------------------msg_GetMsgFromUserBox: err");
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

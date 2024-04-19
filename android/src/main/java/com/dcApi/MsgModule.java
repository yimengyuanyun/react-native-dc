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

  // 向指定用户发送消息 res 0:在线消息发送成功，2:离线消息发送成功（应用根据需要自行接推送服务）3:消息发送失败）
  @ReactMethod
  public void Msg_SendMsg(
      String receiver, // 接收者16进制的账号或base32编码的pubkey  
      String msg, // 要发送的消息
      Callback successCallback) {
    new Thread(new Runnable() {
      @Override
      public void run() {
        System.out.println("---------------------------------start Msg_SendMsg");
        long res = dcClass.Msg_SendMsg(receiver, msg);
        successCallback.invoke(res);
        System.out.println("---------------------------------Msg_SendMsg");
      }
    }).start();
  }

}

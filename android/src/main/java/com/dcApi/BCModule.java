package com.dcApi;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import dcapi.Dcapi_;

/**
 * 区块链相关
 */
public class BCModule extends ReactContextBaseJavaModule {

    private static ReactApplicationContext reactContext;
    public Dcapi_ dcClass;

    public BCModule(ReactApplicationContext context, Dcapi_ dc) {
        super(context);
        reactContext = context;
        dcClass = dc;
    }


    @NonNull
    @Override
    public String getName() {
        return "BCModule";
    }


    // 获取当前区块高度
    @ReactMethod
    public void bc_GetBlockHeight(
            Callback successCallback,
            Callback errorCallback){
        new Thread(new Runnable() {
            @Override
            public void run() {
                long blockHeight = dcClass.bc_GetBlockHeight();
                System.out.println("---------------------------------getBlockHeight: " + blockHeight);
                if(blockHeight <= 0){
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------getBlockHeight: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                }else {
                    successCallback.invoke(Long.toString(blockHeight));
                }
            }
        }).start();
    }

    // 获取节点的可用状态
    @ReactMethod
    public void bc_PeerState(
            String peer,
            Callback successCallback){
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("---------------------------------peerState" + peer);
                String state = dcClass.bc_PeerState(peer);
                System.out.println("---------------------------------peerState" + state);
                successCallback.invoke(state);
            }
        }).start();
    }


    // 随机生成区块链账号信息（返回mnemonic）
    @ReactMethod
    public void bc_GenerateBCAccount(
            int val,
            Callback successCallback,
            Callback errorCallback){
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("---------------------------------generateBCAccount: start");
                String mnemonic = dcClass.bc_GenerateBCAccount(val);
                System.out.println("---------------------------------generateBCAccount: " + mnemonic);
                if(mnemonic.equals("")){
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------generateBCAccount: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                }else {
                    successCallback.invoke(mnemonic);
                }
            }
        }).start();
    }

    // 查询当前链上存储价格列表{data:[StroragePrice]}
    @ReactMethod
    public void bc_GetStoragePrices (
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                String jsonStroragePrices = dcClass.bc_GetStoragePrices();
                System.out.println("--------------------------------getStroagePrices：" + jsonStroragePrices);
                if (jsonStroragePrices.equals("")) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------getStroagePrices: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(jsonStroragePrices);
                }
            }
        }).start();
    }

    // 订阅存储
    @ReactMethod
    public void bc_SubscribeStorage (
            int pricetype,
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.bc_SubscribeStorage(pricetype);
                System.out.println("--------------------------------subscribeStorage success：" + pricetype);
                if (!bool) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------subscribeStorage: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke();
                }
            }
        }).start();
    }
}

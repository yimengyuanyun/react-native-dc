package com.dcApi;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import dcapi.Dcapi_;

/**
 * 账号相关
 */
public class AccountModule extends ReactContextBaseJavaModule {

    private static ReactApplicationContext reactContext;
    private Dcapi_ dcClass;

    public AccountModule(ReactApplicationContext context, Dcapi_ dc) {
        super(context);
        reactContext = context;
        dcClass = dc;
    }

    @NonNull
    @Override
    public String getName() {
        return "AccountModule";
    }

    // 退出登录
    @ReactMethod
    public void account_Logout() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                dcClass.account_Logout();
                //System.out.println("---------------------------------loginOut");
            }
        }).start();
    }

    // 将私钥绑定NFT账号(NFT账号+密码) //0:绑定成功 1:用户已绑定其他nft账号 2:nft账号已经被其他用户绑定 3:区块链账号不存在
    // 99:其他异常
    // 4:还没有建立到存储节点的连接 5:加密数据过程出错 6:区块链相关错误 7:签名错误 8:用户有效期已过
    @ReactMethod
    public void account_BindNFTAccount(
            String account,
            String password,
            String code,
            Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                //System.out.println("--------------------------------bindNFTAccount：" + account + "，" + password);
                long sdkStatus = dcClass.account_BindNFTAccount(account, password, code);
                //System.out.println("--------------------------------bindNFTAccount：" + sdkStatus);
                successCallback.invoke(Long.toString(sdkStatus));
            }
        }).start();
    }

    // 将私钥绑定NFT账号(NFT账号+密码) //0:绑定成功 1:用户已绑定其他nft账号 2:nft账号已经被其他用户绑定 3:区块链账号不存在
    // 99:其他异常
    // 4:还没有建立到存储节点的连接 5:加密数据过程出错 6:区块链相关错误 7:签名错误 8:用户有效期已过
    @ReactMethod
    public void account_BindNFTAccountWithAppBcAccount(
            String account,
            String password,
            String code,
            Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                //System.out.println("--------------------------------account_BindNFTAccountWithAppBcAccount" + account + "，" + password);
                long sdkStatus = dcClass.account_BindNFTAccountWithAppBcAccount(account, password, code);
                //System.out.println("--------------------------------account_BindNFTAccountWithAppBcAccount" + sdkStatus);
                successCallback.invoke(Long.toString(sdkStatus));
            }
        }).start();
    }
    // 账号是否与用户公钥绑定成功
    @ReactMethod
    public void account_IfNftAccountBindSuccess(
            String account,
            Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bindFlag = dcClass.ifNftAccountBindSuccess(account);
                //System.out.println("--------------------------------ifNftAccountBindSuccess：" + bindFlag);
                successCallback.invoke(bindFlag);
            }
        }).start();
    }
    // 应用账号是否与用户公钥绑定成功
    @ReactMethod
    public void account_IfAppNftAccountBindSuccess(
            String account,
            Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bindFlag = dcClass.ifAppNftAccountBindSuccess(account);
                //System.out.println("--------------------------------ifAppNftAccountBindSuccess" + bindFlag);
                successCallback.invoke(bindFlag);
            }
        }).start();
    }
    
    // 获取当前账号的nft账号
    @ReactMethod
    public void account_GetNFTAccount(
            Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                String nftAccount = dcClass.account_GetNFTAccount();
                //System.out.println("--------------------------------account_GetNFTAccount" + nftAccount);
                successCallback.invoke(nftAccount);
            }
        }).start();
    }

    // NFT账号登录
    @ReactMethod
    public void account_NFTAccountLogin(
            String account,
            String password,
            String code,
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                //System.out.println("--------------------------------nftAccountLogin：" + account + "， " + password);
                long login = dcClass.account_NFTAccountLogin(account, password, code);
                //System.out.println("---------------------------------nftAccountLogin:  " + login);
                if (login != 0) {
                    String lastError = dcClass.dc_GetLastErr();
                    //System.out.println("---------------------------------nftAccountLogin: err " + login);
                    //System.out.println(lastError);
                    if (lastError.equals("")) {
                        successCallback.invoke(Long.toString(login));
                    } else {
                        errorCallback.invoke(lastError);
                    }
                } else {
                    successCallback.invoke(Long.toString(login));
                }
            }
        }).start();
    }

    // NFT账号密码修改
    @ReactMethod
    public void account_NFTAccountPasswordModify(
            String account,
            String password,
            String code,
            Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                long sdkStatus = dcClass.account_NFTAccountPasswordModify(account, password, code);
                successCallback.invoke(Long.toString(sdkStatus));
                //System.out.println("--------------------------------nftAcountPasswordModify：" + sdkStatus);
            };
        }).start();
    }

    // 子账号NFT账号密码修改
    @ReactMethod
    public void account_AppNFTAccountPasswordModify(
            String account,
            String password,
            String code,
            Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                long sdkStatus = dcClass.account_AppNFTAccountPasswordModify(account, password, code);
                successCallback.invoke(Long.toString(sdkStatus));
                //System.out.println("--------------------------------Account_AppNFTAccountPasswordModify" + sdkStatus);
            };
        }).start();
    }

    // NFT账号转让
    @ReactMethod
    public void account_NFTAccountTransfer(
            String tpubkey,
            Callback successCallback) {
        Runnable mt = new Runnable() {
            @Override
            public void run() {
                long transfer = dcClass.account_NFTAccountTransfer(tpubkey);
                successCallback.invoke(Long.toString(transfer));
                //System.out.println("--------------------------------nftAcountTransfer：" + transfer);
            };
        };
        Thread mt1 = new Thread(mt, "nftAcountTransfer");
        mt1.start();
    }
}

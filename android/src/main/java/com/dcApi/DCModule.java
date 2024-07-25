package com.dcApi;

import androidx.annotation.NonNull;

import com.alibaba.fastjson.JSONObject;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.common.StandardCharsets;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.protobuf.ByteString;
import com.google.protobuf.InvalidProtocolBufferException;


import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;

import dcapi.Dcapi_;

import dcapi.If_P2pMsgHandler;
import dcapi.If_P2pStreamHandler;
import dcapi.If_StreamHandle;
import dcapi.Dc_P2pConnectOptions;

/**
 * 节点相关
 */
public class DCModule extends ReactContextBaseJavaModule {
    private static ReactApplicationContext reactContext;
    public Dcapi_ dcClass;

    public DCModule(ReactApplicationContext context, Dcapi_ dc) {
        super(context);
        reactContext = context;
        dcClass = dc;
    }

    @NonNull
    @Override
    public String getName() {
        return "DCModule";
    }

    public static boolean mkUserDir(String path) {
        File file = new File(path);
        // 判断文件夹是否存在,如果不存在则创建文件夹
        if (!file.exists()) {
            Boolean mkSuccess = new File(path).mkdirs();
            System.out.println("---------------------------------不存在路径" + path);
            if (!file.exists()) {
                System.out.println("---------------------------------不存在路径2" + path);
            } else {
                System.out.println("---------------------------------存在路径2" + path);
            }
            return mkSuccess;
        } else {
            System.out.println("---------------------------------存在路径" + path);
            return true;
        }
    }

    // 获取密钥
    @ReactMethod
    public void dc_GenerateSymmetricKey(Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                String key = dcClass.dc_GenerateSymmetricKey();
                successCallback.invoke(key);
            }
        }).start();
    }

    // 密钥加密
    @ReactMethod
    public void dc_EncryptData(String data, String pin, Callback successCallback, Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                byte[] key = dcClass.dc_EncryptData(data.getBytes(StandardCharsets.UTF_8),
                        pin.getBytes(StandardCharsets.UTF_8));
                if (key == null) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------encryptData: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(Base64.getEncoder().encodeToString(key));
                }
            }
        }).start();
    }

    // 密钥解密
    @ReactMethod
    public void dc_DecryptData(String data, String pin, Callback successCallback, Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                byte[] key = dcClass.dc_DecryptData(Base64.getDecoder().decode(data),
                        pin.getBytes(StandardCharsets.UTF_8));
                if (key == null) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------decryptData: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(new String(key, StandardCharsets.UTF_8));
                }
            }
        }).start();
    }

    // 初始化
    @ReactMethod
    public void dc_ApiInit(String DCAPPName, String dir, String region, String key, Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                // sdk初始化 region：区域编码（中国086） encryptkey:私钥文件加密密码 apppath:app dc文件目录 webflag
                // 表示是否启用http访问文件模式 debugflag：是否打印调试信息 flag: 是否开启web监听
                // Init(region string, encryptkey string, apppath string, listenport int,
                // webflag bool, debugflag bool, flag bool) error
                String apppath = reactContext.getFilesDir().getAbsolutePath();
                String userpath = apppath + "/" + dir;
                Boolean mkSuccess = mkUserDir(userpath);
                if (mkSuccess) {
                    System.out.println("---------------------------------apppath : " + apppath);
                    System.out.println("---------------------------------userpath : " + userpath);
                    System.out.println("---------------------------------region : " + region);
                    System.out.println("---------------------------------key : " + key);
                    String webport = dcClass.dc_ApiInit(DCAPPName, region, key, apppath, dir, true, true);
                    System.out.println("---------------------------------init: " + webport);
                    if (webport.equals("")) {
                        String lastError = dcClass.dc_GetLastErr();
                        System.out.println("---------------------------------init: err");
                        System.out.println(lastError);
                        errorCallback.invoke(lastError);
                    } else {
                        successCallback.invoke(webport);
                    }
                } else {
                    errorCallback.invoke("");
                }
            }
        }).start();
    }

    // 加载默认用户信息
    @ReactMethod
    public void dc_LoadDefaultUserInfo(
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean load = dcClass.dc_LoadDefaultUserInfo();
                System.out.println("---------------------------------loadDefaultUserInfo" + load);
                if (!load) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------loadDefaultUserInfo: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(true);
                }
            }
        }).start();
    }

    // 设置用户默认数据库上链
    @ReactMethod
    public void dc_SetUserDefaultDB(
            String threadid,
            String rk,
            String sk,
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.dc_SetUserDefaultDB(threadid, rk, sk);
                System.out.println("---------------------------------setUserDefaultDB: " + bool + "...." + threadid
                        + ", " + rk + ", " + sk);
                if (!bool) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------setUserDefaultDB: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(threadid);
                }
            }
        }).start();
    }

    // 获取当前接入的webport
    @ReactMethod
    public void dc_GetLocalWebports(
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                String localWebports = dcClass.dc_GetLocalWebports();
                System.out.println("---------------------------------getLocalWebports" + localWebports);
                if (localWebports.equals("")) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------localWebports: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(localWebports);
                }
            }
        }).start();
    }

    // 设置默认区块链代理节点
    @ReactMethod
    public void dc_SetDefaultChainProxy(
            String chainProxyUrl,
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.dc_SetDefaultChainProxy(chainProxyUrl);
                String apppath = reactContext.getFilesDir().getAbsolutePath();
                System.out.println("---------------------------------setDefaultChainProxy: " + chainProxyUrl);
                if (!bool) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------setDefaultChainProxy: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(true);
                }
            }
        }).start();
    }

    // 获取默认区块链代理节点
    @ReactMethod
    public void dc_GetDefaultChainProxy(Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                String defaultChainProxy = dcClass.dc_GetDefaultChainProxy();
                successCallback.invoke(defaultChainProxy);
                System.out.println("---------------------------------defaultChainProxy: " + defaultChainProxy);
            }
        }).start();
    }

    // 获取区块链代理节点列表
    @ReactMethod
    public void dc_GetChainProxys(Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                String chainProxys = dcClass.dc_GetChainProxys();
                successCallback.invoke(chainProxys);
                System.out.println("---------------------------------getChainProxys: " + chainProxys);
            }
        }).start();
    }

    // 获取在线的存储节点接入地址列表
    @ReactMethod
    public void dc_GetOnlinePeers(Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                String onlinePeers = dcClass.dc_GetOnlinePeers();
                successCallback.invoke(onlinePeers);
                System.out.println("---------------------------------getOnlinePeers: " + onlinePeers);
            }
        }).start();
    }

    // 获取当前存储节点接入地址列表
    @ReactMethod
    public void dc_GetBootPeers(Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                String multiaddrs = dcClass.dc_GetBootPeers();
                successCallback.invoke(multiaddrs);
                System.out.println("---------------------------------getBootPeers: " + multiaddrs);
            }
        }).start();
    }

    // 增加接入存储节点记录
    @ReactMethod
    public void dc_AddBootAddrs(
            String multiaddr,
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.dc_AddBootAddrs(multiaddr);
                System.out.println("---------------------------------addBootAddrs: " + bool);
                if (!bool) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------addBootAddrs: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(true);
                }
            }
        }).start();
    }

    // 删除指定的接入存储节点记录
    @ReactMethod
    public void dc_DeleteBootAddrs(String multiaddr,
            Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.dc_DeleteBootAddrs(multiaddr);
                successCallback.invoke(bool);
            }
        }).start();
    }

    // 切换接入的DC服务节点
    @ReactMethod
    public void dc_SwitchDcServer(
            String multiaddr,
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.dc_SwitchDcServer(multiaddr);
                System.out.println("---------------------------------switchDcServer: " + multiaddr + ", " + bool);
                if (!bool) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------switchDcServer: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(true);
                }
            }
        }).start();
    }

    // 获取当前接入的DC服务节点
    @ReactMethod
    public void dc_GetConnectedDcNetInfo(
            Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                String dcNetInfo = dcClass.dc_GetConnectedDcNetInfo();
                System.out.println("---------------------------------getConnectedDcNetInfo" + dcNetInfo);
                successCallback.invoke(dcNetInfo);
            }
        }).start();
    }

    // 获取当前生效的私钥（返回16进制字符串）
    @ReactMethod
    public void dc_GetEd25519AppPrivateKey(
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                String privateKey = dcClass.dc_GetEd25519AppPrivateKey();
                System.out.println("---------------------------------getEd25519AppPrivateKey: " + privateKey);
                if (privateKey.equals("")) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------getEd25519AppPrivateKey: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(privateKey);
                }
            }
        }).start();
    }

    // 获取当前生效key关联的助记词
    @ReactMethod
    public void dc_GetMnemonic(
            Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                String mnemonic = dcClass.dc_GetMnemonic();
                successCallback.invoke(mnemonic);
                System.out.println("---------------------------------getMnemonic: " + mnemonic);
            }
        }).start();
    }

    // 导入私钥，privatekey 16进制字符串
    @ReactMethod
    public void dc_ImportEd25519PrivateKey(
            String privateKey,
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.dc_ImportEd25519PrivateKey(privateKey);
                System.out.println("--------------------------------importEd25519PrivateKey");
                if (bool) {
                    successCallback.invoke(true);
                } else {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------importEd25519PrivateKey: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                }
            }
        }).start();
    }

    // 导入助记词
    @ReactMethod
    public void dc_ImportMnemonic(
            String mnemonic,
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.dc_ImportMnemonic(mnemonic);
                System.out.println("--------------------------------importMnemonic");
                if (bool) {
                    successCallback.invoke(true);
                } else {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------importMnemonic: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                }
            }
        }).start();
    }

    // 获取用户信息
    @ReactMethod
    public void dc_GetUserInfo(
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                String jsonUserInfo = dcClass.dc_GetUserInfo();
                System.out.println("--------------------------------getUserInfo：" + jsonUserInfo);
                if (jsonUserInfo.equals("")) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------getUserInfo: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(jsonUserInfo);
                }
            }
        }).start();
    }

    // 应用账号是否已经创建
    @ReactMethod
    public void dc_IfAppAcountExist(
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.dc_IfAppAcountExist();
                System.out.println("--------------------------------ifAppAccountExist success：" + bool);
                if (!bool) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------ifAppAccountExist: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(true);
                }
            }
        }).start();
    }

    // 释放资源
    @ReactMethod
    public void dc_ReleaseDc(
            Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("---------------------------------dc_ReleaseDc: start");
                dcClass.dc_ReleaseDc();
                System.out.println("---------------------------------dc_ReleaseDc: end");
                successCallback.invoke();
            }
        }).start();
    }

    // 删除文件夹
    @ReactMethod
    public void deleteDir(
            String dir,
            Callback successCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                String apppath = reactContext.getFilesDir().getAbsolutePath();
                String userpath = apppath + "/" + dir;
                Boolean delete = new File(userpath).delete();
                successCallback.invoke(delete);
            }
        }).start();
    }

    // 添加/生成应用账号
    @ReactMethod
    public void dc_GenerateAppAccount(
            String appId,
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                String basePrivKey = dcClass.dc_GenerateAppAccount(appId);
                System.out.println("--------------------------------generateAppAccount success：" + basePrivKey);
                if (basePrivKey.equals("")) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------generateAppAccount: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(basePrivKey);
                }
            }
        }).start();
    }

    // 获取以太坊地址
    @ReactMethod
    public void dc_GetEthAddress(
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                String address = dcClass.dc_GetEthAddress();
                System.out.println("--------------------------------dc_GetEthAddress success：" + address);
                if (address.equals("")) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------dc_GetEthAddress: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(address);
                }
            }
        }).start();
    }

    // 重启本地文件网络访问服务
    @ReactMethod
    public void dc_RestartLocalWebServer(
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("---------------------------------start dc_RestartLocalWebServer");
                Boolean bool = dcClass.dc_RestartLocalWebServer();
                System.out.println("--------------------------------dc_RestartLocalWebServer success：" + bool);
                if (bool) {
                    successCallback.invoke(bool);
                } else {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------dc_RestartLocalWebServer: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                }
            }
        }).start();
    }

    // 16进制区块链账号转换为base32公钥
    @ReactMethod
    public void dc_AccountToPubkey(
            String account,
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("---------------------------------start dc_AccountToPubkey");
                String res = dcClass.dc_AccountToPubkey(account);
                System.out.println("--------------------------------dc_AccountToPubkey success：" + res);
                if (res.length() > 0) {
                    successCallback.invoke(res);
                } else {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------dc_AccountToPubkey: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                }
            }
        }).start();
    }

    // base32公钥转换为16进制Account
    @ReactMethod
    public void dc_PubkeyToHexAccount(
            String basePubkey,
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("---------------------------------start dc_PubkeyToHexAccount");
                String res = dcClass.dc_PubkeyToHexAccount(basePubkey);
                System.out.println("--------------------------------dc_PubkeyToHexAccount success：" + res);
                if (res.length() > 0) {
                    successCallback.invoke(res);
                } else {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------dc_PubkeyToHexAccount: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                }
            }
        }).start();
    }

    public If_P2pMsgHandler IfP2pMsgHandler(){
        return new If_P2pMsgHandler(){
            @Override
            public void pubSubMsgResponseHandler(String msgId, String fromPeerId, String topic, byte[] msg, String err) {
            }

            @Override
            public void receiveMsg(String fromPeerId, byte[] bytes, byte[] bytes1) {
                System.out.println("---------------------------------receiveMsg");
                try {
                    Net.SendMsgRequest msgRequest = Net.SendMsgRequest.parseFrom(bytes1);
                    System.out.println("---------------------------------msgRequest");
                    ByteString messageId = msgRequest.getMessageId();
                    System.out.println("---------------------------------messageId");
                    String messageIdStr = new String(messageId.toByteArray());
                    System.out.println("---------------------------------messageIdStr : " + messageIdStr);
                    ByteString senderPubkey = msgRequest.getSenderPubkey();
                    System.out.println("---------------------------------senderPubkey");
                    String senderPubkeyStr = new String(senderPubkey.toByteArray());
                    System.out.println("---------------------------------senderPubkeyStr : " + senderPubkeyStr);
                    String msgStr = new String(bytes);
                    System.out.println("---------------------------------msgStr : " + msgStr);
                    Map<String,Object> map=new HashMap<>();
                    map.put("messageId",messageIdStr);
                    map.put("sender",senderPubkeyStr);
                    map.put("msg",msgStr);
                    String jsonStr=  JSONObject.toJSONString(map);

                    // 也可以
//                    JSONObject jo= new JSONObject();
//                    jo.put("sender",senderPubkeyStr);
//                    jo.put("msg",msgStr);
//                    String jsonStr= jo.toString();

                    System.out.println("---------------------------------jsonStr : " + jsonStr);
                    reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit("receiveP2PMsg", jsonStr);
                } catch (InvalidProtocolBufferException e) {
                    throw new RuntimeException(e);
                }
            }

            @Override
            public void pubSubEventHandler(String fromPeerId, String topic, byte[] msg) {
            }

            @Override
            public byte[] pubSubMsgHandler(String s, String s1, byte[] bytes) {
                return new byte[0];
            }
        };
    }
    If_P2pMsgHandler msgHandler = IfP2pMsgHandler();
    // 启动p2p通信服务
    @ReactMethod
    public void dc_EnableMessage(
            String model, // 0:默认模式，接收除了黑名单外的任何有效来源信息， 1:白名单模式，只接收白名单里用户的信息
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("---------------------------------start dc_EnableMessage");
                Dc_P2pConnectOptions options = new Dc_P2pConnectOptions();
                Boolean bool = dcClass.dc_EnableMessage(Long.parseLong(model), msgHandler, new If_P2pStreamHandler() {
                    @Override
                    public void onDataRecv(byte[] bytes) {

                    }

                    @Override
                    public void onStreamClose(Exception e) {

                    }

                    @Override
                    public void onStreamConncetRequest(String s, If_StreamHandle ifStreamHandle) throws Exception {

                    }
                }, options);
                System.out.println("---------------------------------dc_EnableMessage");
                if (bool) {
                    successCallback.invoke(bool);
                } else {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------dc_EnableMessage: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                }
            }
        }).start();
    }
    
    // 导出json格式的钱包私钥信息,返回json格式的钱包私钥信息,如果主账号存在，返回主账号的私钥信息，password 导出密码
    @ReactMethod
    public void dc_EncryptEthPrivKeyToJson(
            String password,
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("---------------------------------start dc_EncryptEthPrivKeyToJson");
                String res = dcClass.dc_EncryptEthPrivKeyToJson(password);
                System.out.println("--------------------------------dc_EncryptEthPrivKeyToJson success：" + res);
                if (res.length() > 0) {
                    successCallback.invoke(res);
                } else {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------dc_EncryptEthPrivKeyToJson: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                }
            }
        }).start();
    }

    // 刷新网络
    @ReactMethod
    public void dc_RefreshNet(
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("---------------------------------start dc_RefreshNet");
                Boolean bool = dcClass.dc_RefreshNet();
                System.out.println("--------------------------------dc_RefreshNet success：" + bool);
                if (bool) {
                    successCallback.invoke(true);
                } else {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------dc_RefreshNet: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                }
            }
        }).start();
    }
}

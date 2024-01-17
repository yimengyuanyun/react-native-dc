package com.dcApi;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.bridge.ReactMethod;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import dcapi.Dcapi_;
import dcapi.If_FileTransmit;
/**
 * 文件相关接口
 */
public class FileModule extends ReactContextBaseJavaModule {

    private static ReactApplicationContext reactContext;
    public Dcapi_ dcClass;

    public FileModule(ReactApplicationContext context, Dcapi_ dc) {
        super(context);
        reactContext = context;
        dcClass = dc;
    }

    @NonNull
    @Override
    public String getName() {
        return "FileModule";
    }
    public static String encrypt(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] bytes = md.digest(input.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                String hex = Integer.toHexString(b & 0xFF);
                if (hex.length() == 1) {
                    sb.append("0");
                }
                sb.append(hex);
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 添加文件
    // 添加文件AddParams 应该包含是否加密选项，以及密钥
    @ReactMethod
    public void file_AddFile(
            String readPath,
            String enkey,
            //            Callback listenCallback,
            Callback successCallback,
            Callback errorCallback){
        new Thread(new Runnable() {
            @Override
            public void run() {
                // 获取md5加密
                // 此 MessageDigest 类为应用程序提供信息摘要算法的功能
                String str = readPath + "_" + enkey;
                String md5Str = encrypt(str);
                String cid = dcClass.file_AddFile(readPath, enkey, new If_FileTransmit() {
                    @Override
                    public void updateTransmitSize(long status, long size) {
                        //FileDealStatus 0:成功 1:转化为ipfs对象操作中 2:文件传输中 3:传输失败 4:异常
                        System.out.println("---------------------------------addFile inform: " + status + "; " + size);
                        //                    listenCallback.invoke();
                        if (reactContext == null){
                            return;
                        }
                        String jsonStr = "{\"type\":\"addFile\", \"md5Str\":\"" + md5Str + "\", \"status\":\""+ status +"\", \"size\":\""+ size + "\"}";
                        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                .emit("EventFile_" + md5Str, jsonStr);
                    }
                });
                System.out.println("---------------------------------addFile: " + cid);
                if (cid.equals("")) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------addFile: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(cid);
                }
            }
        }).start();

    }

    // 获取文件应该指定获取文件存放目录，以及密钥（如果密钥是空，就表示不用解密）
    // GetFile returns a reader to a file as identified by its root CID. The file
    // must have been added as a UnixFS DAG (default for IPFS).
    @ReactMethod
    public void file_GetFile(
            String fid,
            String savePath,
            String enkey,
            // Callback listenCallback,
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.file_GetFile(fid, savePath, enkey, new If_FileTransmit() {
                    @Override
                    public void updateTransmitSize(long status, long size) {
                        // FileDealStatus 0:成功 1:转化为ipfs对象操作中 2:文件传输中 3:传输失败 4:异常
                        System.out.println("---------------------------------getFile inform: " + status + "; " + size);
                        // listenCallback.invoke(Long.toString(status), Long.toString(size));
                        if (reactContext == null){
                            return;
                        }
                        String jsonStr = "{\"type\":\"getFile\", \"url\":\"" + fid + "\", \"status\":\""+ status +"\", \"size\":\""+ size + "\"}";
                        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                                .emit("EventFile_" + fid, jsonStr);
                    }
                });
                System.out.println("---------------------------------getFile: " + bool);
                if (!bool) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------getFile: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke();
                }
            }
        }).start();
    }

    // 删除文件
    @ReactMethod
    public void file_DeleteFile(
            String fid,
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.file_DeleteFile(fid);
                System.out.println("---------------------------------deleteFile: " + bool + "...." + fid);
                if (!bool) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------deleteFile: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke();
                }
            }
        }).start();
    }

    // 清除文件缓存
    @ReactMethod
    public void file_CleanFile(
            Callback successCallback,
            Callback errorCallback) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.file_CleanFile();
                System.out.println("---------------------------------cleanFile: " + bool);
                if (!bool) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------cleanFile: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(true);
                }
            }
        }).start();
    }
}

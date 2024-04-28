// 对原生接口的封装
import { NativeModules } from "react-native";
const { DCModule } = NativeModules;

// init
export const DCinit = (
  appName: string,
  dir: string,
  region: string,
  password: string
) => {
  return new Promise((resolve) => {
    const successCallback = (webport: string) => {
      console.log("start success", webport);
      resolve({ webport });
    };
    const errCallback = (error: any) => {
      console.log("-----------dc_ApiInit error", error);
      resolve({ error });
    };
    DCModule.dc_ApiInit(
      appName,
      dir,
      region,
      password,
      successCallback,
      errCallback
    );
  });
};

// 获取密钥
export const DCgenerateSymmetricKey = () => {
  return new Promise((resolve) => {
    const successCallback = (key: string) => {
      console.log("dc_GenerateSymmetricKey success", key);
      resolve({ key });
    };
    DCModule.dc_GenerateSymmetricKey(successCallback);
  });
};

// 密钥加密
export const DCencryptData = (data: string, pin: string) => {
  return new Promise((resolve) => {
    const successCallback = (key: string) => {
      console.log("dc_EncryptData success", key);
      resolve({ key });
    };
    const errCallback = (error: any) => {
      console.log("-----------dc_EncryptData error", error);
      resolve({ error });
    };
    DCModule.dc_EncryptData(data, pin, successCallback, errCallback);
  });
};

// 密钥解密
export const DCdecryptData = (data: string, pin: string) => {
  return new Promise((resolve) => {
    const successCallback = (key: string) => {
      console.log("dc_DecryptData success", key);
      resolve({ key });
    };
    const errCallback = (error: any) => {
      console.log("-----------dc_DecryptData error", error);
      resolve({ error });
    };
    DCModule.dc_DecryptData(data, pin, successCallback, errCallback);
  });
};

// 获取当前接入的webport
export const DCgetLocalWebports = () => {
  return new Promise((resolve, reject) => {
    const successCallback = (localWebports: string) => {
      // 解析保存到全局变量
      let webports = localWebports.split("-") || [];
      window.httpwebport = webports[0] || "";
      window.httpswebport = webports[1] || "";
      console.log("httpwebport", window.httpwebport);
      console.log("httpswebport", window.httpswebport);
      resolve({ localWebports });
    };
    const errCallback = (error: any) => {
      console.log("-----------dc_GetLocalWebports error", error);
      resolve({ error });
    };
    DCModule.dc_GetLocalWebports(successCallback, errCallback);
  });
};
// 加载默认的用户信息
export const DCloadDefaultUserInfo = () => {
  return new Promise((resolve) => {
    const successCallback = (load: boolean) => {
      console.log("dc_LoadDefaultUserInfo success");
      resolve({ load });
    };
    const errorCallback = (error: any) => {
      console.log("dc_LoadDefaultUserInfo error", error);
      resolve({ error });
    };
    // flag 表示是否需要通过https方式访问文件
    DCModule.dc_LoadDefaultUserInfo(successCallback, errorCallback);
  });
};

// 设置用户默认数据库上链
export const DCsetUserDefaultDB = (threadid, rk, sk) => {
  return new Promise((resolve) => {
    const successCallback = () => {
      console.log("dc_SetUserDefaultDB success");
      resolve({});
    };
    const errorCallback = (error: any) => {
      console.log("dc_SetUserDefaultDB error", error);
      resolve({ error });
    };
    DCModule.dc_SetUserDefaultDB(
      threadid,
      rk,
      sk,
      successCallback,
      errorCallback
    );
  });
};

// 获取用户信息
export const DCgetUserInfo = () => {
  return new Promise((resolve, reject) => {
    const successCallback = (jsonUserInfo: any) => {
      console.log("dc_GetUserInfo success", jsonUserInfo);
      const userInfo = jsonUserInfo ? JSON.parse(jsonUserInfo) : "";
      resolve({ userInfo: userInfo });
    };
    const errorCallback = (error: any) => {
      console.log("dc_GetUserInfo error", error);
      resolve({ error });
    };
    DCModule.dc_GetUserInfo(successCallback, errorCallback);
  });
};

// 获取在线的存储节点接入地址列表
export const DCgetOnlinePeers = () => {
  return new Promise((resolve) => {
    const successCallback = (onlinePeers: string) => {
      console.log("dc_GetOnlinePeers success", onlinePeers);
      const onlinePeersArr = onlinePeers.split(",") || [];
      resolve({ onlinePeers: onlinePeersArr });
    };
    DCModule.dc_GetOnlinePeers(successCallback);
  });
};

// 获取当前存储节点接入地址列表
export const DCgetBootPeers = () => {
  return new Promise((resolve) => {
    const successCallback = (multiaddrs: string) => {
      console.log("dc_GetBootPeers success", multiaddrs);
      const multiaddrsArr = multiaddrs.length > 0 ? multiaddrs.split(",") : [];
      resolve({ multiaddrs: multiaddrsArr });
    };
    DCModule.dc_GetBootPeers(successCallback);
  });
};

// 获取app私钥
export const DCgetEd25519AppPrivateKey = () => {
  return new Promise((resolve) => {
    const successCallback = (privateKey: string) => {
      console.log("dc_GetEd25519AppPrivateKey success", privateKey);
      resolve({ privateKey });
    };
    const errorCallback = (error: any) => {
      console.log("dc_GetEd25519AppPrivateKey error", error);
      resolve({ error });
    };
    DCModule.dc_GetEd25519AppPrivateKey(successCallback, errorCallback);
  });
};

// 增加接入存储节点记录
export const DCaddBootAddrs = (multiaddr: string) => {
  return new Promise((resolve, reject) => {
    const successCallback = (bool: boolean) => {
      console.log("dc_AddBootAddrs success");
      resolve({ bool });
    };
    const errorCallback = (error: any) => {
      console.log("dc_AddBootAddrs error", error);
      resolve({ error });
    };
    DCModule.dc_AddBootAddrs(multiaddr, successCallback, errorCallback);
  });
};
// 删除指定的接入存储节点记录
export const DCdeleteBootAddrs = (multiaddr: string) => {
  return new Promise((resolve, reject) => {
    const successCallback = (bool: boolean) => {
      console.log("dc_DeleteBootAddrs success");
      resolve({ bool });
    };
    DCModule.dc_DeleteBootAddrs(multiaddr, successCallback);
  });
};

// 切换接入的DC服务节点
export const DCswitchDcServer = (multiaddr: string) => {
  return new Promise((resolve, reject) => {
    const successCallback = (bool: boolean) => {
      console.log("dc_SwitchDcServer success");
      resolve({ bool });
    };
    const errorCallback = (error: any) => {
      console.log("dc_SwitchDcServer error", error);
      resolve({ error });
    };
    DCModule.dc_SwitchDcServer(multiaddr, successCallback, errorCallback);
  });
};

// 获取当前接入的DC服务节点
export const DCgetConnectedDcNetInfo = () => {
  return new Promise((resolve, reject) => {
    const successCallback = (dcNetInfo: string) => {
      console.log("dc_GetConnectedDcNetInfo success" + dcNetInfo);
      const dcNetInfoObj = JSON.parse(dcNetInfo);
      resolve({ dcNetInfo: dcNetInfoObj });
    };
    DCModule.dc_GetConnectedDcNetInfo(successCallback);
  });
};

// 设置默认区块链代理节点
export const DCsetDefaultChainProxy = (chainProxyUrl: string) => {
  return new Promise((resolve) => {
    const successCallback = (bool: string) => {
      console.log("dc_SetDefaultChainProxy success", bool);
      resolve({ bool });
    };
    const errCallback = (error: any) => {
      console.log("-----------dc_SetDefaultChainProxy error", error);
      resolve({ error });
    };
    // flag 表示是否需要通过https方式访问文件
    DCModule.dc_SetDefaultChainProxy(
      chainProxyUrl,
      successCallback,
      errCallback
    );
  });
};

// 获取默认区块链代理节点
export const DCgetDefaultChainProxy = () => {
  return new Promise((resolve) => {
    const successCallback = (defaultChainProxy: string) => {
      console.log("dc_GetDefaultChainProxy success", defaultChainProxy);
      resolve({ defaultChainProxy });
    };
    DCModule.dc_GetDefaultChainProxy(successCallback);
  });
};

// 获取区块链代理节点列表
export const DCgetChainProxys = () => {
  return new Promise((resolve) => {
    const successCallback = (chainProxys: string) => {
      console.log("dc_GetChainProxys success", chainProxys);
      const chainProxysArr = chainProxys ? chainProxys.split(",") : [];
      resolve({ chainProxys: chainProxysArr });
    };
    DCModule.dc_GetChainProxys(successCallback);
  });
};

// 获取当前生效key关联的助记词
export const DCgetMnemonic = () => {
  return new Promise((resolve) => {
    const successCallback = (mnemonic: string) => {
      resolve({ mnemonic });
    };
    DCModule.dc_GetMnemonic(successCallback);
  });
};

// 获取当前生效的钱包地址
export const DCgetEthAddress = () => {
  return new Promise((resolve, reject) => {
    const successCallback = (ss58address: string) => {
      console.log("dc_GetEthAddress success", ss58address);
      resolve({ ss58address });
    };
    const errorCallback = (error: any) => {
      console.log("dc_GetEthAddress error", error);
      resolve({ error });
    };
    DCModule.dc_GetEthAddress(successCallback, errorCallback);
  });
};

// 应用账号是否创建
export const DCifAppAccountExist = () => {
  return new Promise((resolve) => {
    const successCallback = (exist: Boolean) => {
      console.log("dc_IfAppAcountExist success", exist);
      resolve({ exist });
    };
    const errorCallback = (error: any) => {
      console.log("dc_IfAppAcountExist error", error);
      resolve({ error });
    };
    DCModule.dc_IfAppAcountExist(successCallback, errorCallback);
  });
};

// 导入私钥，privatekey 16进制字符串
export const DCimportEd25519PrivateKey = (privateKey: string) => {
  return new Promise((resolve) => {
    const successCallback = (bool: Boolean) => {
      console.log("dc_ImportEd25519PrivateKey success" + bool);
      resolve({ bool });
    };
    const errorCallback = (error: any) => {
      console.log("dc_ImportEd25519PrivateKey error", error);
      resolve({ error });
    };
    DCModule.dc_ImportEd25519PrivateKey(
      privateKey,
      successCallback,
      errorCallback
    );
  });
};

// 导入助记词
export const DCimportMnemonic = (mnemonic: string) => {
  return new Promise<void>((resolve) => {
    const successCallback = (bool: Boolean) => {
      console.log("dc_ImportMnemonic success" + bool);
      resolve({ bool });
    };
    const errorCallback = (error: any) => {
      console.log("dc_ImportMnemonic error", error);
      resolve({ error });
    };
    DCModule.dc_ImportMnemonic(mnemonic, successCallback, errorCallback);
  });
};

// 释放资源
export const DCreleaseDc = () => {
  return new Promise<void>((resolve) => {
    const successCallback = () => {
      resolve();
    };
    DCModule.dc_ReleaseDc(successCallback);
  });
};

// 释放资源
export const DCdeleteDir = (dir: string) => {
  return new Promise((resolve) => {
    const successCallback = (bool: boolean) => {
      console.log("dc_DeleteBootAddrs success");
      resolve({ bool });
    };
    DCModule.deleteDir(dir, successCallback);
  });
};

// 创建应用账号
export const DCgenerateAppAccount = (appName: string) => {
  return new Promise((resolve) => {
    const successCallback = (basePrivKey: String) => {
      console.log("dc_GenerateAppAccount success", basePrivKey);
      resolve({ basePrivKey });
    };
    const errorCallback = (error) => {
      console.log("dc_GenerateAppAccount error", error);
      resolve({ error });
    };
    DCModule.dc_GenerateAppAccount(appName, successCallback, errorCallback);
  });
};

// base32公钥转换为16进制Account
export const DCPubkeyToAccount = (basePubkey: string) => {
  return new Promise((resolve) => {
    const successCallback = (account: String) => {
      console.log("dc_PubkeyToAccount success", account);
      resolve({ account });
    };
    const errorCallback = (error) => {
      console.log("dc_PubkeyToAccount error", error);
      resolve({ error });
    };
    DCModule.dc_PubkeyToAccount(basePubkey, successCallback, errorCallback);
  });
};

// 重启本地文件网络访问服务
export const DCRestartLocalWebServer = () => {
  return new Promise((resolve) => {
    const successCallback = (bool: boolean) => {
      console.log("dc_RestartLocalWebServer success", bool);
      resolve({ bool });
    };
    const errorCallback = (error) => {
      console.log("dc_RestartLocalWebServer error", error);
      resolve({ error });
    };
    DCModule.dc_RestartLocalWebServer(successCallback, errorCallback);
  });
};

// 启动p2p通信服务
export const DCstartP2pServer = (receiver: string, model: number) => {
  return new Promise((resolve) => {
    const successCallback = (bool: boolean) => {
      console.log("dc_StartP2pServer success", bool);
      resolve({ bool });
    };
    const errorCallback = (error) => {
      console.log("dc_StartP2pServer error", error);
      resolve({ error });
    };
    DCModule.dc_StartP2pServer(receiver, model, successCallback, errorCallback);
  });
};
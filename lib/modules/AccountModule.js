// 对原生接口的封装
import {NativeModules} from 'react-native';
const {AccountModule} = NativeModules;

// 获取当前私钥绑定的NFT账号
export const DCgetNFTAccount = () => {
  return new Promise(resolve => {
    const successCallback = (nftAccount) => {
      //console.log('getNFTAccount success', nftAccount);
      resolve({nftAccount});
    };
    AccountModule.account_GetNFTAccount(successCallback);
  });
};

// 绑定当前私钥绑定的NFT账号
export const DCbindNFTAccount = (account, password, code) => {
  return new Promise(resolve => {
    const successCallback = (bind) => {
      //console.log('account_BindNFTAccount success', bind);
      resolve({bind});
    };
    AccountModule.account_BindNFTAccount(account, password, code, successCallback);
  });
};

// 绑定当前私钥绑定的NFT账号
export const DCbindAppNFTAccount = (account, password, code, vaccount = '') => {
  return new Promise(resolve => {
    const successCallback = (bind) => {
      //console.log('account_BindNFTAccountWithAppBcAccount success', bind);
      resolve({bind});
    };
    AccountModule.account_BindNFTAccountWithAppBcAccount(
      account,
      password,
      code,
      vaccount,
      successCallback,
    );
  });
};
// 账号是否与用户公钥绑定成功
export const DCifNftAccountBindSuccess = (account) => {
  return new Promise(resolve => {
    const successCallback = (bind) => {
      //console.log('account_IfNftAccountBindSuccess success', bind);
      resolve({bind});
    };
    AccountModule.account_IfNftAccountBindSuccess(account, successCallback);
  });
};

// 应用账号是否与用户公钥绑定成功
export const DCIfAppNftAccountBindSuccess = (account) => {
  return new Promise(resolve => {
    const successCallback = (bind) => {
      //console.log('account_IfAppNftAccountBindSuccess success', bind);
      resolve({bind});
    };
    AccountModule.account_IfAppNftAccountBindSuccess(account, successCallback);
  });
};

// NFT账号登录
export const DCnftAccountLogin = (account, password, code) => {
  return new Promise(resolve => {
    const successCallback = (login) => {
      //console.log('account_NFTAccountLogin success', login);
      resolve({login});
    };
    const errorCallback = (error) => {
      //console.log('account_NFTAccountLogin error', error);
      resolve({error});
    };
    AccountModule.account_NFTAccountLogin(
      account,
      password,
      code,
      successCallback,
      errorCallback,
    );
  });
};

// 退出登录
export const DCloginOut = () => {
  AccountModule.account_Logout();
};

// NFT账号密码修改
export const DCnftAcountPasswordModify = (
  account,
  password,
  code,
) => {
  return new Promise(resolve => {
    const successCallback = (modify) => {
      //console.log('account_NFTAccountPasswordModify success', modify);
      resolve({modify});
    };
    AccountModule.account_NFTAccountPasswordModify(
      account,
      password,
      code,
      successCallback,
    );
  });
};

// 子账号NFT账号密码修改
export const DCappNftAcountPasswordModify = (
  account,
  password,
  code,
) => {
  return new Promise(resolve => {
    const successCallback = (modify) => {
      //console.log('account_AppNFTAccountPasswordModify success', modify);
      resolve({modify});
    };
    AccountModule.account_AppNFTAccountPasswordModify(
      account,
      password,
      code,
      successCallback,
    );
  });
};

// todo NFT账号转让
// export const DCnftAcountTransfer = (tpubkey) => {
//   return new Promise(resolve => {
//     const successCallback = (transfer) => {
//       //console.log('account_NFTAccountTransfer success', transfer);
//       resolve({transfer});
//     };
//     AccountModule.account_NFTAccountTransfer(tpubkey, successCallback);
//   });
// };

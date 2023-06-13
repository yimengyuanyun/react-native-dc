// 对原生接口的封装
import {NativeModules} from 'react-native';
const {BCModule} = NativeModules;

// 获取当前区块高度
export const DCgetBlockHeight = () => {
  return new Promise((resolve, reject) => {
    const successCallback = (blockHeight) => {
      console.log('bc_GetBlockHeight success', blockHeight);
      resolve({blockHeight});
    };
    const errorCallback = (error) => {
      console.log('bc_GetBlockHeight error', error);
      resolve({error});
    };
    BCModule.bc_GetBlockHeight(successCallback, errorCallback);
  });
};

// 获取节点状态
export const DCpeerState = (multiaddr) => {
  return new Promise((resolve, reject) => {
    const successCallback = (state) => {
      const peerStadus = JSON.parse(state);
      resolve({state: peerStadus.Status || ''});
    };
    BCModule.bc_PeerState(multiaddr, successCallback);
  });
};

// 创建账号
export const DCgenerateBCAccount = val => {
  return new Promise((resolve, reject) => {
    const successCallback = (account) => {
      console.log('bc_GenerateBCAccount success', account);
      resolve({account});
    };
    const errorCallback = (error) => {
      console.log('bc_GenerateBCAccount error', error);
      resolve({error});
    };
    BCModule.bc_GenerateBCAccount(val, successCallback, errorCallback);
  });
};

// 查询当前链上存储价格列表{data:[StroragePrice]}
export const DCgetStroagePrices = () => {
  return new Promise(resolve => {
    const successCallback = (jsonStroragePrices) => {
      console.log('bc_GetStoragePrices success', jsonStroragePrices);
      // todo 空的话返回是null，还是空字符串？
      // 格式化处理
      jsonStroragePrices = jsonStroragePrices || '[]';
      const stroragePrices = JSON.parse(jsonStroragePrices);
      resolve({stroragePrices});
    };
    const errorCallback = (error) => {
      console.log('bc_GetStoragePrices error', error);
      resolve({error});
    };
    BCModule.bc_GetStoragePrices(successCallback, errorCallback);
  });
};

// 购买存储
export const DCsubscribeStorage = (pricetype) => {
  return new Promise(resolve => {
    const successCallback = () => {
      console.log('bc_SubscribeStorage success');
      resolve({});
    };
    const errorCallback = (error) => {
      console.log('bc_SubscribeStorage error', error);
      resolve({error});
    };
    BCModule.bc_SubscribeStorage(pricetype, successCallback, errorCallback);
  });
};

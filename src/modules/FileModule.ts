// 对原生接口的封装
import {NativeModules} from 'react-native';
const {FileModule} = NativeModules;
/**
 * 文件相关接口
 */
// 新增文件
export const DCaddFile = (readPath: string, enkey: string) => {
  return new Promise(resolve => {
    const listenCallback = (info: any) => {
      console.log('file_AddFile listenCallback1111', info);
    };
    const successCallback = (cid: any) => {
      console.log('file_AddFile success', cid);
      resolve({cid});
    };
    const errorCallback = (error: any) => {
      console.log('file_AddFile error', error);
      resolve({error});
    };
    FileModule.file_AddFile(
      readPath,
      enkey,
      successCallback,
      errorCallback,
      listenCallback,
    );
  });
};

// 获取文件
export const DCgetFile = (cid: string, savePath: string, enkey: string) => {
  return new Promise((resolve, reject) => {
    const listenCallback = (status: string) => {
      console.log('file_GetFile listenCallback22222', status);
    };
    const successCallback = () => {
      console.log('file_GetFile success');
      resolve({});
    };
    const errorCallback = (error: any) => {
      console.log('file_GetFile error', error);
      resolve({error});
    };
    FileModule.file_GetFile(
      cid,
      savePath,
      enkey,
      successCallback,
      errorCallback,
      listenCallback,
    );
  });
};

// 删除文件
export const DCdeleteFile = (cid: string) => {
  return new Promise((resolve, reject) => {
    const successCallback = () => {
      console.log('file_DeleteFile success');
      resolve({});
    };
    const errorCallback = (error: any) => {
      console.log('file_DeleteFile error', error);
      resolve({error});
    };
    FileModule.file_DeleteFile(cid, successCallback, errorCallback);
  });
};

//清理文件缓存文件
export const DCcleanFile = async () => {
  return new Promise((resolve, reject) => {
    const successCallback = (bool: Boolean) => {
      console.log('file_CleanFile success ' + bool);
      resolve({bool});
    };
    const errorCallback = (error: any) => {
      console.log('file_CleanFile error', error);
      resolve({error});
    };
    FileModule.file_CleanFile(successCallback, errorCallback);
  });
};

// 获取文件信息
export const DCgetFileInfo = (cid) => {
  return new Promise((resolve, reject) => {
    const successCallback = (fileInfo) => {
      console.log('GetFileInfo success');
      resolve({fileInfo});
    };
    const errorCallback = (error) => {
      console.log('GetFileInfo error', error);
      resolve({error});
    };
    FileModule.file_GetFileInfo(
      cid,
      successCallback,
      errorCallback,
    );
  });
};
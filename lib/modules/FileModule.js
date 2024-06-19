// 对原生接口的封装
import {NativeModules} from 'react-native';
const {FileModule} = NativeModules;
/**
 * 文件相关接口
 */
// 新增文件
export const DCaddFile = (readPath, enkey) => {
  return new Promise(resolve => {
    const listenCallback = (info) => {
      console.log('file_AddFile listenCallback', info);
    };
    const successCallback = (cid) => {
      console.log('file_AddFile success', cid);
      resolve({cid});
    };
    const errorCallback = (error) => {
      console.log('file_AddFile error', error);
      resolve({error});
    };
    FileModule.file_AddFile(
      readPath,
      enkey,
      // listenCallback,
      successCallback,
      errorCallback,
    );
  });
};

// 获取文件
export const DCgetFile = (cid, savePath, enkey) => {
  return new Promise((resolve, reject) => {
    // const listenCallback = (status, size) => {
    //   console.log('addFile listenCallback', status, size);
    // };
    const successCallback = () => {
      console.log('file_GetFile success');
      resolve({});
    };
    const errorCallback = (error) => {
      console.log('file_GetFile error', error);
      resolve({error});
    };
    FileModule.file_GetFile(
      cid,
      savePath,
      enkey,
      // listenCallback,
      successCallback,
      errorCallback,
    );
  });
};

// 删除文件
export const DCdeleteFile = (cid) => {
  return new Promise((resolve, reject) => {
    const successCallback = () => {
      console.log('file_DeleteFile success');
      resolve({});
    };
    const errorCallback = (error) => {
      console.log('file_DeleteFile error', error);
      resolve({error});
    };
    FileModule.file_DeleteFile(cid, successCallback, errorCallback);
  });
};

//清理文件缓存文件
export const DCcleanFile = async () => {
  return new Promise((resolve, reject) => {
    const successCallback = (bool) => {
      console.log('file_CleanFile success ' + bool);
      resolve({bool});
    };
    const errorCallback = (error) => {
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

// 将指定的文件添加到当前连接的存储节点上,一个文件最多在网络中备份10份 cid 文件的cid 该cid对应的文件,必须是当前用户已经存储在dc网络的文件
// 返回值：是否添加成功
export const fileAddFileBackUpToPeer = (cid) => {
  return new Promise((resolve, reject) => {
    const successCallback = () => {
      console.log('file_AddFileBackUpToPeer success');
      resolve({});
    };
    const errorCallback = (error) => {
      console.log('file_AddFileBackUpToPeer error', error);
      resolve({error});
    };
    FileModule.file_AddFileBackUpToPeer(
      cid,
      successCallback,
      errorCallback,
    );
  });
};
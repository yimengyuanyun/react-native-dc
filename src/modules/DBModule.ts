// 对原生接口的封装
import {NativeModules} from 'react-native';
const {DBModule} = NativeModules;

/**
 * DB相关接口
 * @returns
 */
// 创建数据库DB
export const DCnewDB = (
  dbname: string,
  rk: string,
  sk: string,
  jsonCollectionStr: string,
) => {
  return new Promise(resolve => {
    console.log(
      '------db_NewThreadDB start -----',
      dbname,
      rk,
      sk,
      jsonCollectionStr,
    );
    const successCallback = (threadid: any) => {
      console.log('db_NewThreadDB success', threadid);
      resolve({threadid});
    };
    const errorCallback = (error: any) => {
      console.log('db_NewThreadDB error', error);
      resolve({error});
    };
    DBModule.db_NewThreadDB(
      dbname,
      rk,
      sk,
      jsonCollectionStr,
      successCallback,
      errorCallback,
    );
  });
};

// 从DC网络中同步数据库信息到本地
export const DCsyncDBFromDC = (dbname, threadid, rk, sk, jsonCollectionStr) => {
  return new Promise(resolve => {
    const successCallback = () => {
      console.log('db_SyncDBFromDC success');
      resolve({});
    };
    const errorCallback = (error: any) => {
      console.log('db_SyncDBFromDC error', error);
      resolve({error});
    };
    const block = true; // 是否阻塞，等待同步完成
    const dbAddr = ''; //address + '/thread/' + threadid;
    DBModule.db_SyncDBFromDC(
      threadid,
      dbname,
      dbAddr,
      rk,
      sk,
      block,
      jsonCollectionStr,
      successCallback,
      errorCallback,
    );
  });
};

// 同步数据库到本地
export const DCrefreshDBFromDC = (threadid: string) => {
  return new Promise(resolve => {
    const successCallback = (bool: boolean) => {
      resolve({bool});
    };
    const errorCallback = (error: any) => {
      console.log('DCrefreshDBFromDC error', error);
      resolve({error});
    };
    DBModule.db_RefreshDBFromDC(threadid, successCallback, errorCallback);
  });
};
// 是否成功同步上传数据库DB
export const DCifSyncDBToDCSuccess = (threadid: string) => {
  return new Promise(resolve => {
    const successCallback = (bool: boolean) => {
      resolve({bool});
    };
    const errorCallback = (error: any) => {
      console.log('db_IfSyncDBToDCSuccess error', error);
      resolve({error});
    };
    DBModule.db_IfSyncDBToDCSuccess(threadid, successCallback, errorCallback);
  });
};

// 同步上传数据库DB
export const DCsyncDBToDC = (threadid: string) => {
  return new Promise(resolve => {
    const successCallback = (bool: boolean) => {
      resolve({bool});
    };
    const errorCallback = (error: any) => {
      console.log('db_SyncDBToDC error', error);
      resolve({error});
    };
    DBModule.db_SyncDBToDC(threadid, successCallback, errorCallback);
  });
};

// 返回该账号下的所有数据库
export const DClistDBs = () => {
  return new Promise(resolve => {
    const successCallback = (jsonDBInfos: string) => {
      console.log('listDBs success', jsonDBInfos);
      resolve({jsonDBInfos});
    };
    const errorCallback = (error: any) => {
      console.log('listDBs error', error);
      resolve({error});
    };
    DBModule.listDBs(successCallback, errorCallback);
  });
};

// 通过threadid获取db
export const DCgetDB = (threadid: string) => {
  return new Promise(resolve => {
    const successCallback = (jsonDBInfo: any) => {
      console.log('db_GetDBInfo success', jsonDBInfo);
      const dbInfo = JSON.parse(jsonDBInfo);
      resolve({dbInfo});
    };
    const errorCallback = (error: any) => {
      console.log('db_GetDBInfo error', error);
      resolve({error});
    };
    DBModule.db_GetDBInfo(threadid, successCallback, errorCallback);
  });
};

// 通过threadid删除db
export const DCdeleteDB = (threadid: string) => {
  return new Promise(resolve => {
    const successCallback = () => {
      console.log('deleteDB success');
      resolve({});
    };
    const errorCallback = (error: any) => {
      console.log('deleteDB error', error);
      resolve({error});
    };
    DBModule.deleteDB(threadid, successCallback, errorCallback);
  });
};

// 获取数据库的所有集合
export const DClistCollections = (threadid: string) => {
  return new Promise(resolve => {
    const successCallback = (jsonConfig: any) => {
      console.log('listCollections success', jsonConfig);
      const collections = JSON.parse(jsonConfig);
      resolve({collections});
    };
    const errorCallback = (error: any) => {
      console.log('listCollections error', error);
      resolve({error});
    };
    DBModule.listCollections(threadid, successCallback, errorCallback);
  });
};

// 获取数据表信息某个字段
export const DCgetCollectionInfo = (threadid: string, name: string) => {
  return new Promise(resolve => {
    const successCallback = (jsonConfig: any) => {
      console.log('getCollectionInfo success', jsonConfig);
      const collection = jsonConfig ? JSON.parse(jsonConfig) : '';
      resolve({collection});
    };
    const errorCallback = (error: any) => {
      console.log('getCollectionInfo error', error);
      resolve({error});
    };
    DBModule.getCollectionInfo(threadid, name, successCallback, errorCallback);
  });
};

// 创建数据表
export const DCnewCollection = (threadid: string, jsonconfig: string) => {
  return new Promise(resolve => {
    const successCallback = () => {
      console.log('newCollection success');
      resolve({});
    };
    const errorCallback = (error: any) => {
      console.log('newCollection error', error);
      resolve({error});
    };
    DBModule.newCollection(
      threadid,
      jsonconfig,
      successCallback,
      errorCallback,
    );
  });
};

// 修改数据表
export const DCupdateCollection = (threadid: string, jsonconfig: string) => {
  return new Promise(resolve => {
    const successCallback = () => {
      console.log('updateCollection success');
      resolve({});
    };
    const errorCallback = (error: any) => {
      console.log('updateCollection error', error);
      resolve({error});
    };
    DBModule.updateCollection(
      threadid,
      jsonconfig,
      successCallback,
      errorCallback,
    );
  });
};

// 删除数据表
export const DCdeleteCollection = (threadid: string, name: string) => {
  return new Promise(resolve => {
    const successCallback = () => {
      console.log('deleteCollection success');
      resolve({});
    };
    const errorCallback = (error: any) => {
      console.log('deleteCollection error', error);
      resolve({error});
    };
    DBModule.deleteCollection(threadid, name, successCallback, errorCallback);
  });
};

// 创建数据表记录
export const DCcreateInstance = (
  threadid: string,
  collectionName: string,
  jsonInstances: string,
) => {
  return new Promise(resolve => {
    const successCallback = (jsonInstanceids: any) => {
      console.log('db_Create success', jsonInstanceids);
      resolve({jsonInstanceids});
    };
    const errorCallback = (error: any) => {
      console.log('db_Create error', error);
      resolve({error});
    };
    DBModule.db_Create(
      threadid,
      collectionName,
      jsonInstances,
      successCallback,
      errorCallback,
    );
  });
};

// 保存数据表记录
export const DCsaveInstance = (
  threadid: string,
  collectionName: string,
  instance: string,
) => {
  return new Promise(resolve => {
    const successCallback = () => {
      console.log('db_Save success');
      resolve({});
    };
    const errorCallback = (error: any) => {
      console.log('db_Save error', error);
      resolve({error});
    };
    DBModule.db_Save(
      threadid,
      collectionName,
      instance,
      successCallback,
      errorCallback,
    );
  });
};

// 删除数据表记录
export const DCdeleteInstance = (
  threadid: string,
  collectionName: string,
  jsonInstances: string,
) => {
  return new Promise(resolve => {
    const successCallback = () => {
      console.log('db_Delete success');
      resolve({});
    };
    const errorCallback = (error: any) => {
      console.log('db_Delete error', error);
      resolve({error});
    };
    DBModule.db_Delete(
      threadid,
      collectionName,
      jsonInstances,
      successCallback,
      errorCallback,
    );
  });
};

// 删除数据表记录
export const DCdeleteManyInstance = (
  threadid: string,
  collectionName: string,
  jsonInstances: string,
) => {
  return new Promise(resolve => {
    const successCallback = () => {
      console.log('db_DeleteMany success');
      resolve({});
    };
    const errorCallback = (error: any) => {
      console.log('db_DeleteMany error', error);
      resolve({error});
    };
    DBModule.db_DeleteMany(
      threadid,
      collectionName,
      jsonInstances,
      successCallback,
      errorCallback,
    );
  });
};

// // 是否存在指定的数据表记录
// export const hasInstance = (
//   threadid: string,
//   collectionName: string,
//   instanceIDs: string,
// ) => {
//   return new Promise((resolve) => {
//     const successCallback = (has: any) => {
//       console.log('hasInstance success', has);
//       resolve({has});
//     };
//     DBModule.hasInstance(
//       threadid,
//       collectionName,
//       instanceIDs,
//       successCallback,
//     );
//   });
// }

// 找到指定的数据表记录
export const DCfindInstance = (
  threadid: string,
  collectionName: string,
  queryString: string,
) => {
  return new Promise(resolve => {
    const successCallback = (jsonInstances: any) => {
      resolve({jsonInstances});
    };
    const errorCallback = (error: any) => {
      console.log('db_Find error', error);
      resolve({error});
    };
    DBModule.db_Find(
      threadid,
      collectionName,
      queryString,
      successCallback,
      errorCallback,
    );
  });
};

// // 查询数据库
// export const DCfindByIDInstance = (
//   threadid: string,
//   collectionName: string,
//   instanceID: string,
// ) => {
//   return new Promise((resolve, reject) => {
//     const successCallback = (jsonInstances: any) => {
//       console.log('findByIDInstance success', jsonInstances);
//       resolve({jsonInstances});
//     };
//     const errorCallback = (error: any) => {
//       console.log('findByIDInstance error', error);
//       resolve({error});
//     };
//     DBModule.findByIDInstance(
//       threadid,
//       collectionName,
//       instanceID,
//       successCallback,
//       errorCallback,
//     );
//   });
// };

// 监听数据库数据变化
// export const listenInstance = (listenBack: Function) => {
//   return new Promise((resolve) => {
//     const successCallback = (handle: string) => {
//       console.log('listen成功', handle);
//       resolve(handle);
//     };
//     const listenCallback = (l: string, s: string, s1: string) => {
//       console.log('变化： ', l, s, s1);
//       listenBack(l, s, s1);
//     };
//     DBModule.listenInstance(
//       'threadid',
//       'collectionName',
//       '',
//       successCallback,
//       listenCallback,
//     );
//   });
// }

// // 取消监听变化
// export const cancelListenDB = (threadid: string, handle: string) => {
//   DBModule.cancelListenDB(threadid, handle);
// }

package com.dcApi;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import dcapi.Dcapi_;

/**
 * 数据库
 */
public class DBModule extends ReactContextBaseJavaModule {

    private static ReactApplicationContext reactContext;
    public Dcapi_ dcClass;

    public DBModule(ReactApplicationContext context, Dcapi_ dc) {
        super(context);
        reactContext = context;
        dcClass = dc;
    }

    @NonNull
    @Override
    public String getName() {
        return "DBModule";
    }



    // 创建数据库DB
    @ReactMethod
    public void db_NewThreadDB(
            String dbname,
            String rk,
            String sk,
            String jsonCollections,
            Callback successCallback,
            Callback errorCallback
    ){
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("---------------------------------start newDB: " + dbname);
                String threadid = dcClass.db_NewThreadDB(dbname, rk, sk, jsonCollections);
                System.out.println("---------------------------------newDB threadid: " + threadid);
                if (threadid.equals("")) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------newDB: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(threadid);
                }
            }
        }).start();
    }

    // syncDBFromDC 从DC网络中同步数据库信息到本地（一般发生在新设备首次登录时同步已经创建的数据库）,jsonCollections 是一个map结构的json字符串，格式[{"name":"name1","schema":"schema1"},indexs:[{"path":"path1","unique":true},{"path":"path2","unique":false}],{"name":"name2","schema":"schema2"},...]
    @ReactMethod
    public void db_SyncDBFromDC(
            String threadid,
            String dbname,
            String dbAddr,
            String rk,
            String sk,
            boolean block,
            String jsonCollections,
            Callback successCallback,
            Callback errorCallback
    ){
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("---------------------------------start syncDBFromDC: " + threadid);
                Boolean bool = dcClass.db_SyncDBFromDC(threadid, dbname, dbAddr, rk, sk, block, jsonCollections);
                if (!bool) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------syncDBFromDC: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke();
                }
            }
        }).start();
    }


    // 同步数据库数据到本地
    @ReactMethod
    public void db_RefreshDBFromDC(
            String threadid,
            Callback successCallback,
            Callback errorCallback
    ){
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.db_RefreshDBFromDC(threadid);
                System.out.println("---------------------------------Db_RefreshDBFromDC : " + bool);
                if (!bool) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------Db_RefreshDBFromDC: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(true);
                }
            }
        }).start();
    }

    // 是否成功同步上传数据库DB
    @ReactMethod
    public void db_IfSyncDBToDCSuccess(
            String threadid,
            Callback successCallback,
            Callback errorCallback
    ){
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.db_IfSyncDBToDCSuccess(threadid);
                System.out.println("---------------------------------ifSyncDBToDCSuccess : " + bool);
                if(!bool){
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------ifSyncDBToDCSuccess: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                }else {
                    successCallback.invoke(true);
                }
            }
        }).start();
    }

    // 同步上传数据库DB
    @ReactMethod
    public void db_SyncDBToDC(
            String threadid,
            Callback successCallback,
            Callback errorCallback
    ){
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.db_SyncDBToDC(threadid);
                System.out.println("---------------------------------syncDBToDC : " + bool);
                if (!bool) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------syncDBToDC: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(true);
                }
            }
        }).start();
    }

    // 通过threadid获取db
    @ReactMethod
    public void db_GetDBInfo(
            String threadid,
            Callback successCallback,
            Callback errorCallback
    ){
        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("---------------------------------start getDB: " + threadid);
                String jsonDBInfo = dcClass.db_GetDBInfo(threadid);
                if (jsonDBInfo.equals("")) {
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------getDB: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                } else {
                    successCallback.invoke(jsonDBInfo);
                }
            }
        }).start();
    }

    // 创建数据表记录
    @ReactMethod
    public void db_Create(
            String threadid,
            String collectionName,
            String jsonInstances,
            Callback successCallback,
            Callback errorCallback){
        new Thread(new Runnable() {
            @Override
            public void run() {
                String jsonInstanceids = dcClass.db_Create(threadid, collectionName, jsonInstances);
                System.out.println("---------------------------------create2: " + jsonInstanceids);
                if(jsonInstanceids.equals("")){
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------create: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                }else {
                    successCallback.invoke(jsonInstanceids);
                }
            }
        }).start();
    }

    // 删除数据表记录
    @ReactMethod
    public void db_Delete(
            String threadid,
            String collectionName,
            String instanceID,
            Callback successCallback,
            Callback errorCallback ){
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.db_Delete(threadid, collectionName, instanceID);
                System.out.println("---------------------------------delete: " + bool);
                if(!bool){
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------delete: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                }else {
                    successCallback.invoke();
                }
            }
        }).start();
    }

    // 更新数据表记录
    @ReactMethod
    public void db_Save(
            String threadid,
            String collectionName,
            String instance,
            Callback successCallback,
            Callback errorCallback ){
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.db_Save(threadid, collectionName, instance);
                System.out.println("---------------------------------saveInstance: " + threadid + "," + collectionName + "," + bool);
                if(!bool){
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------saveInstance: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                }else {
                    successCallback.invoke();
                }
            }
        }).start();
    }

    // 删除多条记录
    @ReactMethod
    public void db_DeleteMany(
            String threadid,
            String collectionName,
            String instanceIDs,
            Callback successCallback,
            Callback errorCallback ){
        new Thread(new Runnable() {
            @Override
            public void run() {
                Boolean bool = dcClass.db_DeleteMany(threadid, collectionName, instanceIDs);
                System.out.println("---------------------------------deleteManyInstance: " + bool);
                if(!bool){
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------deleteManyInstance: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                }else {
                    successCallback.invoke();
                }
            }
        }).start();
    }


    // 找到指定条件的数据表记录
    @ReactMethod
    public void db_Find(
            String threadid,
            String collectionName,
            String queryString,
            Callback successCallback,
            Callback errorCallback){
        new Thread(new Runnable() {
            @Override
            public void run() {
                String jsonInstances = dcClass.db_Find(threadid, collectionName, queryString);
                System.out.println("---------------------------------findInstance: " + jsonInstances);
                if(jsonInstances.equals("")){
                    String lastError = dcClass.dc_GetLastErr();
                    System.out.println("---------------------------------findInstance: err");
                    System.out.println(lastError);
                    errorCallback.invoke(lastError);
                }else {
                    successCallback.invoke(jsonInstances);
                }
            }
        }).start();
    }

//     // 查询某条数据记录
//     @ReactMethod
//     public void findByIDInstance(
//             String threadid,
//             String collectionName,
//             String instanceID,
//             Callback successCallback,
//             Callback errorCallback){
//         Runnable mt = new Runnable() {
//             @Override
//             public void run() {
//                 try {
//                     String jsonInstance = dcClass.findByID(threadid, collectionName, instanceID);
//                     successCallback.invoke(jsonInstance);
//                     System.out.println("---------------------------------findByID: " + jsonInstance);
//                 } catch (Exception e) {
//                     errorCallback.invoke(e.getMessage());
//                     e.printStackTrace();
//                 }
//             };
//         };
//         Thread mt1 = new Thread(mt, "findByIDInstance");
//         mt1.start();
//     }

// //    // 监听变化
// //    @ReactMethod
// //    public void listenInstance(
// //            String threadid,
// //            String collectionName,
// //            String listenOptions,
// //            Callback successCallback,
// //            Callback callback){
// //        Runnable mt = new Runnable() {
// //            @Override
// //            public void run() {
// //                String handle = dcClass.listen(threadid, collectionName, listenOptions, new dc.Callback() {
// //                    @Override
// //                    public void inform(long l, String s, String s1) {
// //                        System.out.println("---------------------------------inform: ");
// //                        callback.invoke(l, s, s1);
// //                    }
// //                });
// //                System.out.println("---------------------------------listen1: " + handle);
// //                successCallback.invoke(handle);
// //                System.out.println("---------------------------------listen2: " + handle);
// //            };
// //        };
// //        Thread mt1 = new Thread(mt, "listenInstance");
// //        mt1.start();
// //    }


//     // 取消监听
//     @ReactMethod
//     public void cancelDbListen(
//             String handle
//     ){
//         Runnable mt = new Runnable() {
//             @Override
//             public void run() {
//                 dcClass.cancelDbListen(handle);
//                 System.out.println("---------------------------------cancelDbListen: " + handle);
//             };
//         };
//         Thread mt1 = new Thread(mt, "cancelDbListen");
//         mt1.start();
//     }



// //    //将数据库内容添加到当前连接的dc peer（如果dc peer没有对当前用户授权，除非存储了该db内容的所有dc节点离线，否则将会添加失败）
// //    @ReactMethod
// //    public void addDbRecordToDcPeer(
// //            String threadid,
// //            String sk,
// //            Callback errorCallback
// //    ){
// //        try {
// //            dcClass.addDbRecordToDcPeer(threadid, sk);
// //            System.out.println("--------------------------------addDbRecordToDcPeer：");
// //        } catch (Exception e) {
// //            errorCallback.invoke(e.getMessage());
// //            e.printStackTrace();
// //        }
// //    }


//     // 返回该账号下的所有数据库
//     @ReactMethod
//     public void listDBs(
//             Callback successCallback,
//             Callback errorCallback
//     ){
//         Runnable mt = new Runnable() {
//             @Override
//             public void run() {
//                 try {
//                     String jsonDBInfos = dcClass.listDBs();
//                     successCallback.invoke(jsonDBInfos);
//                     System.out.println("---------------------------------listDBs : " + jsonDBInfos);
//                 } catch (Exception e) {
//                     errorCallback.invoke(e.getMessage());
//                     e.printStackTrace();
//                 }
//             };
//         };
//         Thread mt1 = new Thread(mt, "listDBs");
//         mt1.start();
//     }

//     // 通过threadid删除db
//     @ReactMethod
//     public void deleteDB(
//             String threadid,
//             Callback successCallback,
//             Callback errorCallback
//     ){
//         Runnable mt = new Runnable() {
//             @Override
//             public void run() {
//                 try {
//                     dcClass.deleteDB(threadid);
//                     System.out.println("---------------------------------deleteDB: ");
//                     successCallback.invoke();
//                 } catch (Exception e) {
//                     errorCallback.invoke(e.getMessage());
//                     e.printStackTrace();
//                 }
//             };
//         };
//         Thread mt1 = new Thread(mt, "deleteDB");
//         mt1.start();
//     }

//     // 创建数据表
//     // NewCollection creates a new collection.jsonconfig格式：{"name":"name1","schema":"schema1"},indexs:[{"path":"path1","unique":true},{"path":"path2","unique":false}]
//     @ReactMethod
//     public void newCollection(
//             String threadid,
//             String jsonconfig,
//             Callback successCallback,
//             Callback errorCallback ){
//         Runnable mt = new Runnable() {
//             @Override
//             public void run() {
//                 try {
//                     dcClass.newCollection(threadid, jsonconfig);
//                     System.out.println("---------------------------------newCollection: ");
//                     successCallback.invoke();
//                 } catch (Exception e) {
//                     errorCallback.invoke(e.getMessage());
//                     e.printStackTrace();
//                 }
//             };
//         };
//         Thread mt1 = new Thread(mt, "newCollection");
//         mt1.start();
//     }

//     // 修改数据表
//     // UpdateCollection updates an existing collection.
//     @ReactMethod
//     public void updateCollection(
//             String threadid,
//             String jsonconfig,
//             Callback successCallback,
//             Callback errorCallback ){
//         Runnable mt = new Runnable() {
//             @Override
//             public void run() {
//                 try {
//                     dcClass.updateCollection(threadid, jsonconfig);
//                     System.out.println("---------------------------------updateCollection: ");
//                     successCallback.invoke();
//                 } catch (Exception e) {
//                     errorCallback.invoke(e.getMessage());
//                     e.printStackTrace();
//                 }
//             };
//         };
//         Thread mt1 = new Thread(mt, "updateCollection");
//         mt1.start();
//     }

//     // 删除数据表
//     @ReactMethod
//     public void deleteCollection(
//             String threadid,
//             String name,
//             Callback successCallback,
//             Callback errorCallback ){
//         Runnable mt = new Runnable() {
//             @Override
//             public void run() {
//                 try {
//                     dcClass.deleteCollection(threadid, name);
//                     System.out.println("---------------------------------deleteCollection: ");
//                     successCallback.invoke();
//                 } catch (Exception e) {
//                     errorCallback.invoke(e.getMessage());
//                     e.printStackTrace();
//                 }
//             };
//         };
//         Thread mt1 = new Thread(mt, "deleteCollection");
//         mt1.start();
//     }


//     // 获取数据库的所有集合
//     // ListCollections returns information about all existing collections.
//     @ReactMethod
//     public void listCollections(
//             String threadid,
//             Callback successCallback,
//             Callback errorCallback){
//         Runnable mt = new Runnable() {
//             @Override
//             public void run() {
//                 try {
//                     String jsonConfig = dcClass.listCollections(threadid);
//                     successCallback.invoke(jsonConfig);
//                     System.out.println("---------------------------------listCollections: " + jsonConfig);
//                 } catch (Exception e) {
//                     errorCallback.invoke(e.getMessage());
//                     e.printStackTrace();
//                 }
//             };
//         };
//         Thread mt1 = new Thread(mt, "listCollections");
//         mt1.start();
//     }

//     // 获取数据表信息某个字段
//     @ReactMethod
//     public void getCollectionInfo(
//             String threadid,
//             String name,
//             Callback successCallback,
//             Callback errorCallback){
//         Runnable mt = new Runnable() {
//             @Override
//             public void run() {
//                 try {
//                     String jsonConfig = dcClass.getCollectionInfo(threadid, name);
//                     successCallback.invoke(jsonConfig);
//                     System.out.println("---------------------------------getCollectionInfo: " + jsonConfig);
//                 } catch (Exception e) {
//                     System.out.println("---------------------------------getCollectionInfo error: " + e.getMessage());
//                     errorCallback.invoke(e.getMessage());
//                     e.printStackTrace();
//                 }
//             };
//         };
//         Thread mt1 = new Thread(mt, "getCollectionInfo");
//         mt1.start();
//     }

//     // 是否存在指定的数据表记录
//     @ReactMethod
//     public void hasInstance(
//             String threadid,
//             String collectionName,
//             String instanceIDs,
//             Callback successCallback ){
//         Runnable mt = new Runnable() {
//             @Override
//             public void run() {
//                 Boolean exist = dcClass.has(threadid, collectionName, instanceIDs);
//                 successCallback.invoke(exist);
//                 System.out.println("---------------------------------has: " + exist);
//             };
//         };
//         Thread mt1 = new Thread(mt, "hasInstance");
//         mt1.start();
//     }
}



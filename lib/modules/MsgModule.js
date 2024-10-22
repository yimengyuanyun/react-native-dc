// 对原生接口的封装
import {NativeModules} from 'react-native';
const {MsgModule} = NativeModules;
/**
 * 消息相关接口
 */
// 向指定用户发送消息 res 0:在线消息发送成功，2:离线消息发送成功（应用根据需要自行接推送服务）3:消息发送失败）
export const msgSendMsg = (receiver, msg) => {
  return new Promise(resolve => {
    const successCallback = (res) => {
      //console.log('msg_SendMsg success', res);
      resolve({res});
    };
    const errCallback = (error) => {
      //console.log("-----------msg_SendMsg error", error);
      resolve({ error });
    };
    MsgModule.msg_SendMsg(
      receiver,
      msg,
      successCallback,
      errCallback,
    );
  });
};

// 从用户收件箱收取离线消息, limit, 一次最多提取多少条离线消息，最多500条每次
export const msgGetMsgFromUserBox = (limit) => {
  return new Promise(resolve => {
    const successCallback = (res) => {
      //console.log('msg_GetMsgFromUserBox success', res);
      resolve({res});
    };
    const errCallback = (error) => {
      //console.log("-----------msg_GetMsgFromUserBox error", error);
      resolve({ error });
    };
    MsgModule.msg_GetMsgFromUserBox(
      limit,
      successCallback,
      errCallback,
    );
  });
};
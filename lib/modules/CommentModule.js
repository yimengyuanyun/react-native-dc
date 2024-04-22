// 对原生接口的封装
import { NativeModules } from "react-native";
const { CommentModule } = NativeModules;
/**
 * 评论相关接口
 */
// 配置或增加用户自身的评论空间 0:成功 1:失败
export const commentAddUserCommentSpace = () => {
  return new Promise((resolve) => {
    const successCallback = (bool) => {
      console.log("comment_AddUserCommentSpace success", bool);
      resolve({ bool });
    };
    const errCallback = (error) => {
      console.log("-----------comment_AddUserCommentSpace error", error);
      resolve({ error });
    };
    CommentModule.comment_AddUserCommentSpace(successCallback, errCallback);
  });
};

// 为指定对象开通评论功能，返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
export const commentAddCommentableObj = (objCid, openFlag, commentSpace) => {
  return new Promise((resolve) => {
    const successCallback = (res) => {
      console.log("comment_AddCommentableObj success", res);
      resolve({ res });
    };
    CommentModule.comment_AddCommentableObj(
      objCid,
      openFlag,
      commentSpace,
      successCallback
    );
  });
};

// 为开通评论的对象增加评论空间，返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
export const commentAddObjCommentSpace = (objCid, commentSpace) => {
  return new Promise((resolve) => {
    const successCallback = (res) => {
      console.log("comment_AddObjCommentSpace success", res);
      resolve({ res });
    };
    CommentModule.comment_AddObjCommentSpace(
      objCid,
      commentSpace,
      successCallback
    );
  });
};

// 关闭指定对象的评论功能（会删除所有针对该对象的评论），返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
export const commentDisableCommentObj = (objCid) => {
  return new Promise((resolve) => {
    const successCallback = (res) => {
      console.log("comment_DisableCommentObj success", res);
      resolve({ res });
    };
    CommentModule.comment_DisableCommentObj(objCid, successCallback);
  });
};

// 举报恶意评论（会删除所有针对该对象的评论），返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
export const commentReportMaliciousComment = (
  objCid,
  commentBlockheight,
  commentCid
) => {
  return new Promise((resolve) => {
    const successCallback = (res) => {
      console.log("comment_ReportMaliciousComment success", res);
      resolve({ res });
    };
    CommentModule.comment_ReportMaliciousComment(
      objCid,
      commentBlockheight,
      commentCid,
      successCallback
    );
  });
};

// 精选评论，让评论可见，返回res-0:成功 1:评论空间没有配置 2:评论空间不足 3:评论数据同步中
export const commentSetObjCommentPublic = (
  objCid,
  commentBlockheight,
  commentCid
) => {
  return new Promise((resolve) => {
    const successCallback = (res) => {
      console.log("comment_SetObjCommentPublic success", res);
      resolve({ res });
    };
    CommentModule.comment_SetObjCommentPublic(
      objCid,
      commentBlockheight,
      commentCid,
      successCallback
    );
  });
};

// 发布对指定对象的评论，返回评论key,格式为:commentBlockHeight/commentCid
export const commentPublishCommentToObj = (
  objCid,
  objAuthor,
  commentType,
  comment,
  referCommentkey,
  openFlag
) => {
  return new Promise((resolve) => {
    const successCallback = (res) => {
      console.log("comment_PublishCommentToObj success", res);
      resolve({ res });
    };
    CommentModule.comment_PublishCommentToObj(
      objCid,
      objAuthor,
      commentType,
      comment,
      referCommentkey,
      openFlag,
      successCallback
    );
  });
};

// 删除已发布的评论，返回评论key,格式为:commentBlockHeight/commentCid
export const commentDeleteSelfComment = (objCid, objAuthor, commentKey) => {
  return new Promise((resolve) => {
    const successCallback = (bool) => {
      console.log("comment_DeleteSelfComment success", bool);
      resolve({ bool });
    };
    const errCallback = (error) => {
      console.log("-----------comment_DeleteSelfComment error", error);
      resolve({ error });
    };
    CommentModule.comment_DeleteSelfComment(
      objCid,
      objAuthor,
      commentKey,
      successCallback,
      errCallback
    );
  });
};

// 获取指定用户已开通评论的对象列表
// 返回已开通评论的对象列表,格式：[{"objCid":"YmF...bXk=","appId":"dGVzdGFwcA==","blockheight":2904,"commentSpace":1000,"userPubkey":"YmJh...vZGU=","signature":"oCY1...Y8sO/lkDac/nLu...Rm/xm...CQ=="}]
export const commentGetCommentableObj = (
  objAuthor,
  startBlockheight,
  direction,
  offset,
  seekKey,
  limit
) => {
  return new Promise((resolve) => {
    const successCallback = (res) => {
      console.log("comment_GetCommentableObj success", res);
      resolve({ res });
    };
    CommentModule.comment_GetCommentableObj(
      objAuthor,
      startBlockheight,
      direction,
      offset,
      seekKey,
      limit,
      successCallback
    );
  });
};

// 取指定已开通对象的评论列表
// 返回已开通评论的对象列表,格式：[{"objCid":"YmF...bXk=","appId":"dGVzdGFwcA==","blockheight":2904,"commentSpace":1000,"userPubkey":"YmJh...vZGU=","signature":"oCY1...Y8sO/lkDac/nLu...Rm/xm...CQ=="}]
export const commentGetObjComments = (
  objCid,
  objAuthor,
  startBlockheight,
  direction,
  offset,
  seekKey,
  limit
) => {
  return new Promise((resolve) => {
    const successCallback = (res) => {
      console.log("comment_GetObjComments success", res);
      resolve({ res });
    };
    CommentModule.comment_GetObjComments(
      objCid,
      objAuthor,
      startBlockheight,
      direction,
      offset,
      seekKey,
      limit,
      successCallback
    );
  });
};

// 获取指定用户发布过的评论，私密评论只有评论者和被评论者可见
// 返回用户评论列表，格式：[{"ObjCid":"bafk...fpy","AppId":"testapp","ObjAuthor":"bbaa...jkhmm","Blockheight":3209,"UserPubkey":"bba...2hzm","CommentCid":"baf...2aygu","Comment":"hello
// world","CommentSize":11,"Status":0,"Signature":"bkqy...b6dkda","Refercommentkey":"","CCount":0,"UpCount":0,"DownCount":0,"TCount":0}]
export const commentGetUserComments = (
  userPubkey,
  startBlockheight,
  direction,
  offset,
  seekKey,
  limit
) => {
  return new Promise((resolve) => {
    const successCallback = (res) => {
      console.log("comment_GetUserComments success", res);
      resolve({ res });
    };
    CommentModule.comment_GetUserComments(
      userPubkey,
      startBlockheight,
      direction,
      offset,
      seekKey,
      limit,
      successCallback
    );
  });
};

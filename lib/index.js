export * as AccountModule from './modules/AccountModule';
export * as BCModule from './modules/BCModule';
export * as DBModule from './modules/DBModule';
export * as DCModule from './modules/DCModule';
export * as FileModule from './modules/FileModule';
export * as CommentModule from './modules/CommentModule';
export * as MsgModule from './modules/MsgModule';

export default dc = {
    ...AccountModule,
    ...BCModule,
    ...DBModule,
    ...DCModule,
    ...FileModule,
    ...CommentModule,
    ...MsgModule,

}
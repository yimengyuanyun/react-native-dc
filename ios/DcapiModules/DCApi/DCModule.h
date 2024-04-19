//
//  Module.h
//  PrivatePhotos
//
//  Created by 王琴 on 2023/6/20.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <Dcapi/Dcapi.h>
#import "CustomEventsEmitter.h";

NS_ASSUME_NONNULL_BEGIN

@interface DCModule : RCTEventEmitter<RCTBridgeModule>

extern DcapiDcapi *dcapi;
extern CustomEventsEmitter *customEventsEmitter;

@end
@interface P2PHandlerModule : RCTEventEmitter<RCTBridgeModule, DcapiIf_FileTransmit>

@property (nonatomic, strong) NSString *receiver;
-(id)initWithInfo:(NSString *)receiver;   //带参数的构造函数

@end

NS_ASSUME_NONNULL_END


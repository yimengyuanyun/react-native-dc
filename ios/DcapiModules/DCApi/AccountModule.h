//
//  AccountModule.h
//  PrivatePhotos
//
//  Created by 王琴 on 2023/6/20.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <Dcapi/Dcapi.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountModule : RCTEventEmitter<RCTBridgeModule>

extern DcapiDcapi *dcapi;

@end

NS_ASSUME_NONNULL_END


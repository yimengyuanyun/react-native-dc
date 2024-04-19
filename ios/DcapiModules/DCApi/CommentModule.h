
#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <Dcapi/Dcapi.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentModule : RCTEventEmitter<RCTBridgeModule>

extern DcapiDcapi *dcapi;
@end

NS_ASSUME_NONNULL_END


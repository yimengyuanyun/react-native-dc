#ifndef CustomEventsEmitter_h
#define CustomEventsEmitter_h


#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface CustomEventsEmitter : RCTEventEmitter <RCTBridgeModule>

- (void)sendEventName:(NSString *)eventName body:(id)body;
- (bool)hasListeners;

@end


#endif

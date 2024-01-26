//
//  CustomEventsEmitter.m
//  Pods
//
//  Created by 王琴 on 2023/8/16.
//

#import "CustomEventsEmitter.h"

@implementation CustomEventsEmitter
{
  bool hasListeners;
}

RCT_EXPORT_MODULE(CustomEventsEmitter);

+ (id)allocWithZone:(NSZone *)zone {
  static CustomEventsEmitter *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [super allocWithZone:zone];
  });
  return sharedInstance;
}


- (NSArray<NSString *> *)supportedEvents {
  return @[@"addFile", @"getFile"];
}

// Will be called when this module's first listener is added.
-(void)startObserving {
  hasListeners = YES;
  // Set up any upstream listeners or background tasks as necessary
}

// Will be called when this module's last listener is removed, or on dealloc.
-(void)stopObserving {
  hasListeners = NO;
  // Remove upstream listeners, stop unnecessary background tasks
}

-(bool)hasListeners {
  return hasListeners;
}


- (void)sendEventName:(NSString*)eventName body:(NSString*)body {
  if (hasListeners) {
    NSLog(@"CustomEventsEmitter sendEventName emitting event: %@", eventName);
    [self sendEventWithName:eventName body:body];
  } else {
    NSLog(@"CustomEventsEmitter sendEventName called without listeners: %@", eventName);
  }
}

@end

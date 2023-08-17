//
//  DcapiModules.m
//  DcapiModules
//
//  Created by 王琴 on 2023/6/28.
//

#import "DcapiModules.h"
#import <Dcapi/Dcapi.h>
#import "CustomEventsEmitter.h"

DcapiDcapi *dcapi = NULL;

@implementation DcapiModules
CustomEventsEmitter *customEventsEmitter = NULL;

-(id) init
 {
  self = [super init];
  if(self)
  {
    dcapi = [[DcapiDcapi alloc] init];
    customEventsEmitter = [CustomEventsEmitter allocWithZone: nil];
    NSLog(@"000000---------init---------========");
  }
  return self;
 }
@end

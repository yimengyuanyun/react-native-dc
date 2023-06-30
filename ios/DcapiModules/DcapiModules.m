//
//  DcapiModules.m
//  DcapiModules
//
//  Created by 王琴 on 2023/6/28.
//

#import "DcapiModules.h"

DcapiDcapi *dcapi = nil;

@implementation DcapiModules

-(id) init
 {
  self = [super init];
  if(self)
  {
    dcapi = [[DcapiDcapi alloc] init];
    NSLog(@"000000---------init---------========");
  }
  return self;
 }
//const DcapiDcapi *dcapi = [[DcapiDcapi alloc] init];
//@synthesize dcapi;
//
//+ (DcapiModules *)sharedSingleton
//{
//  static DcapiModules *sharedSingleton;
//
//  @synchronized(self)
//  {
//    if (!sharedSingleton)
//      sharedSingleton = [[DcapiModules alloc] init];
//
//    return sharedSingleton;
//  }
//}
//
@end

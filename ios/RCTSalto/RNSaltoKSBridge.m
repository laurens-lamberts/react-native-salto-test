#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(RNSaltoKS, RCTEventEmitter)

RCT_EXTERN_METHOD(getPublicKey: (NSString*)deviceId resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(initialize)

@end

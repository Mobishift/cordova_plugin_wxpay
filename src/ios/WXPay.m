/********* WXPay.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

#import "WXAPi.h"
#import "WXApiObject.h"

@interface WXPay : CDVPlugin <WXApiDelegate>{
  // Member variables go here.
    enum WXScene _scene;
    NSString* _callbackId;
}

- (void)pay:(CDVInvokedUrlCommand*)command;
- (void)returnSuccess;
- (void)returnError:(NSString*)message;
@end

@implementation WXPay

-(id) init{
    if(self = [super init]){
        _scene = WXSceneSession;
    }
    return self;
}

- (void)pay:(CDVInvokedUrlCommand*)command
{
//    CDVPluginResult* pluginResult = nil;
    NSArray* params = [command.arguments objectAtIndex:0];
    _callbackId = command.callbackId;
    
    NSString* AppID = [params objectAtIndex:0];
    [WXApi registerApp:AppID];
    
    PayReq* request = [[PayReq alloc] init];
    request.partnerId = [params objectAtIndex:1];
    request.prepayId = [params objectAtIndex:2];
    request.package = [params objectAtIndex:3];
    request.nonceStr = [params objectAtIndex:4];
    request.timeStamp = (unsigned long)[params objectAtIndex:5];
    request.sign = [params objectAtIndex:6];
    [WXApi sendReq:request];
    
//    
//    if (echo != nil && [echo length] > 0) {
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
//    } else {
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
//    }

//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)returnSuccess{
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
}

-(void)returnError:(NSString *)message{
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
}

-(void)onResp:(BaseResp *)resp{
    if([resp isKindOfClass:[PayResp class]]){
        PayResp* response = (PayResp*)resp;
        switch (response.errCode) {
            case WXSuccess:
                [self returnSuccess];
                break;
            default:
                [self returnError: [NSString stringWithFormat:@"支付失败，code=%d", resp.errCode]];
                break;
        }
    }
}

@end

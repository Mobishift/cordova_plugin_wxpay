/********* WXPay.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

#import "WXAPi.h"
#import "WXApiObject.h"

@interface WXPay : CDVPlugin <WXApiDelegate>{
  // Member variables go here.
    NSString* _callbackId;
    NSString* _AppId;
}

- (void)pay:(CDVInvokedUrlCommand*)command;
- (void)returnSuccess;
- (void)returnError:(NSString*)message;
@end

@implementation WXPay

- (void)pay:(CDVInvokedUrlCommand*)command
{
//    CDVPluginResult* pluginResult = nil;
    
    _callbackId = command.callbackId;
    
    NSString* AppID = [command.arguments objectAtIndex:0];
    _AppId = AppID;
    [WXApi registerApp:AppID];
    
    if(![WXApi isWXAppInstalled]){
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"未安装微信"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
        return;
    }
    
    PayReq* request = [[PayReq alloc] init];
    request.partnerId = [command.arguments objectAtIndex:1];
    request.prepayId = [command.arguments objectAtIndex:2];
    request.package = [command.arguments objectAtIndex:3];
    request.nonceStr = [command.arguments objectAtIndex:4];
    request.timeStamp = [(NSString*)[command.arguments objectAtIndex:5] longLongValue];
    request.sign = [command.arguments objectAtIndex:6];
    if(![WXApi sendReq:request]){
        [self returnError:@"调用微信支付失败"];
    }
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

-(void)handleOpenURL:(NSNotification *)notification{
    NSURL* url = [notification object];
    if([url isKindOfClass:[NSURL class]] && [url.scheme isEqualToString:_AppId]){
        [WXApi handleOpenURL:url delegate:self];
    }
}

@end

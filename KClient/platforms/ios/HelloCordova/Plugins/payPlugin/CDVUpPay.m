//
//  CDVUpPay.m
//  KClient
//
//  Created by LanHai on 15/11/25.
//
//

#import "CDVUpPay.h"

#import "UPPayPlugin.h"
#import "UPPayPluginDelegate.h"
#import "MainViewController.h"

@implementation CDVUpPay

- (void)pay:(CDVInvokedUrlCommand *)command{
    
    NSString *tn = [command.arguments objectAtIndex:0];//交易流水号
    NSString *mode = [command.arguments objectAtIndex:1];//接入模式："00"代表接入生产环境，"01"代表接入开发环境
    self.callBackID = command.callbackId;
    MainViewController *mainController  = [MainViewController mainController];
    if (tn.length > 0) {
        [UPPayPlugin startPay:tn mode:mode viewController:mainController delegate:self];
    }
    else {
        CDVPluginResult *pluginResultfail = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"false"];
        NSLog(@"这是银联支付失败地回调ing 》》》》%@",pluginResultfail);
        [self.commandDelegate sendPluginResult:pluginResultfail callbackId:self.callBackID];
    }
}

#pragma mark - UPPayPluginDelegate

- (void)UPPayPluginResult:(NSString *)result{
    
    CDVPluginResult *pluginResultSuccess = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
    NSLog(@"这是银联支付成功地回调ing 》》》》%@",pluginResultSuccess);
    [self.commandDelegate sendPluginResult:pluginResultSuccess callbackId:self.callBackID];
}

@end

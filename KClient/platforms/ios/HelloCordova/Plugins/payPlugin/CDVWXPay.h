//
//  CDVWXPay.h
//  KClient
//
//  Created by LanHai on 15/12/9.
//
//


#import <Cordova/CDVPlugin.h>

#import "WXApi.h"
@interface CDVWXPay : CDVPlugin <WXApiDelegate>

- (void)pay:(CDVInvokedUrlCommand *)command;
@end

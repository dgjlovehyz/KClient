//
//  CDVPay.h
//  KshopClient
//
//  Created by 蓝海 on 15/7/30.
//
//


#import <Cordova/CDVPlugin.h>


@interface CDVPay : CDVPlugin



- (void)alipay:(CDVInvokedUrlCommand *)command;


@end

@protocol CDVPayDelegate <NSObject>
@optional
- (void)dosomeThing;

@end
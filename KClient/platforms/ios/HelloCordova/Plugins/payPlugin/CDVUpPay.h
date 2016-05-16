//
//  CDVUpPay.h
//  KClient
//
//  Created by LanHai on 15/11/25.
//
//


#import <Cordova/CDVPlugin.h>

#import "UPPayPluginDelegate.h"
@interface CDVUpPay : CDVPlugin <UPPayPluginDelegate>
@property (nonatomic, strong) NSString *callBackID;
- (void)pay:(CDVInvokedUrlCommand *)command;

@end

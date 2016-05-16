/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  HelloCordova
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

#import <AlipaySDK/AlipaySDK.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

#import "ErrorLogManagement.h"
#import "FilteredWebCache.h"
#import "DGJCache.h"
#import "RNCachingURLProtocol.h"

@implementation AppDelegate

- (instancetype)init{
    self = [super init];
    
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    int cacheSizeMemory = 8 * 1024 * 1024; // 8MB
    int cacheSizeDisk = 32 * 1024 * 1024; // 32MB
    FilteredWebCache* sharedCache = [[FilteredWebCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    
    
    return self;
}

+(AppDelegate *)app
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
      
    
    NSString *appinfo = [[NSBundle mainBundle] pathForResource:@"appInfo" ofType:@"plist"];
    NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:appinfo];
    NSDictionary *appShareInfo = [infoDic objectForKey:@"AppShareParameters"];
    NSDictionary *sinaDic = [appShareInfo objectForKey:@"SinaWeibo"];
    NSDictionary *tencentDic = [appShareInfo objectForKey:@"TencentWeibo"];
    NSDictionary *wechatDic = [appShareInfo objectForKey:@"Wechat"];
    NSDictionary *QQDic = [appShareInfo objectForKey:@"QQ"];
    NSDictionary *shareSDK = [appShareInfo objectForKey:@"ShareSdk"];
    [ShareSDK registerApp:[shareSDK objectForKey:@"AppId"] activePlatforms:@[@(SSDKPlatformTypeWechat),
                                                                             @(SSDKPlatformSubTypeWechatSession),
                                                                             @(SSDKPlatformSubTypeWechatTimeline),
                                                                             @(SSDKPlatformTypeQQ),
                                                                             @(SSDKPlatformSubTypeQQFriend),
                                                                             @(SSDKPlatformSubTypeQZone),
                                                                             @(SSDKPlatformTypeTencentWeibo),
                                                                             @(SSDKPlatformTypeSinaWeibo),
                                                                             @(SSDKPlatformTypeSMS),
                                                                             @(SSDKPlatformTypeMail)] onImport:^(SSDKPlatformType platformType) {
                                                                                 switch (platformType) {
                                                                                     case SSDKPlatformTypeSinaWeibo:[ShareSDKConnector connectWeibo:[WeiboSDK class]];break;
                                                                                     case SSDKPlatformTypeTencentWeibo:[ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];break;
                                                                                     case SSDKPlatformSubTypeWechatSession:
                                                                                     case SSDKPlatformSubTypeWechatTimeline:
                                                                                     case SSDKPlatformTypeWechat:[ShareSDKConnector connectWeChat:[WXApi class]];break;
                                                                                     case SSDKPlatformSubTypeQQFriend:
                                                                                     case SSDKPlatformSubTypeQZone:
                                                                                     case SSDKPlatformTypeQQ:[ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];break;
                                                                                     default:break;
                                                                                 }
                                                                             } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                                                                 switch (platformType) {
                                                                                     case SSDKPlatformTypeSinaWeibo:[appInfo SSDKSetupSinaWeiboByAppKey:[sinaDic objectForKey:@"AppId"] appSecret:[sinaDic objectForKey:@"AppKey"] redirectUri:[sinaDic objectForKey:@"RedirectUri"] authType:SSDKAuthTypeBoth];break;
                                                                                     case SSDKPlatformTypeTencentWeibo:[appInfo SSDKSetupTencentWeiboByAppKey:[tencentDic objectForKey:@"AppId"] appSecret:[tencentDic objectForKey:@"AppKey"] redirectUri:[tencentDic objectForKey:@"RedirectUri"]];break;
                                                                                     case SSDKPlatformSubTypeWechatSession:
                                                                                     case SSDKPlatformSubTypeWechatTimeline:
                                                                                     case SSDKPlatformTypeWechat:[appInfo SSDKSetupWeChatByAppId:[wechatDic objectForKey:@"AppId"] appSecret:[wechatDic objectForKey:@"AppKey"]];break;
                                                                                     case SSDKPlatformSubTypeQQFriend:
                                                                                     case SSDKPlatformSubTypeQZone:
                                                                                     case SSDKPlatformTypeQQ:[appInfo SSDKSetupQQByAppId:[QQDic objectForKey:@"AppId"] appKey:[QQDic objectForKey:@"AppKey"] authType:SSDKAuthTypeBoth];break;
                                                                                     default:break;
                                                                                 }
                                                                             }];
    
    
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    
    self.viewController = [[MainViewController alloc] init];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    errorModel *model = [errorModel createErrorModel:[NSNumber numberWithInt:4] andErrorCode:[NSNumber numberWithInt:-901] andDescribe:name andExceptionInfo:[arr componentsJoinedByString:@"<br>"]];
    ErrorLogManagement *manager = [ErrorLogManagement errorlog];
    
    [manager sendErrorlog:model];
    
    //或者直接用代码，输入这个崩溃信息，以便在console中进一步分析错误原因
    NSLog(@"1heqin, CRASH: %@", exception);
    NSLog(@"heqin, Stack Trace: %@", [exception callStackSymbols]);
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{

#ifdef __IPHONE_9_0
    if ([url.host isEqualToString:@"safepay"]) {
        //支付宝回调函数
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result11 = %@",resultDic);
        }];
        return YES;
    }
    if ([url.host isEqualToString:@"pay"]) {
        
        return [WXApi handleOpenURL:url delegate:self];
    }
    
#endif
    return YES;
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url
{
    if (!url) {return NO;}
    NSString* jsString = [NSString stringWithFormat:@"handleOpenURL(\"%@\");", url];
//    [self.viewController.webView stringByEvaluatingJavaScriptFromString:jsString];
    /*switch (self.openUrlType) {
     case SNSOpenURLTypeTencent: return [TencentOAuth HandleOpenURL:url];
     case SNSOpenURLTypeWechat: return [WXApi handleOpenURL:url delegate:self];
     default:break;
     }*/
    if ([url.host isEqualToString:@"pay"]) {
        
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"%@",url.host);
    if ([url.host isEqualToString:@"safepay"]) {
        //支付宝回调函数
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result11 = %@",resultDic);
        }];
        return YES;
    }
    
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
        return YES;
    }
   
    
    if ([url.host isEqualToString:@"pay"]) {
        
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

@end

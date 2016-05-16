//
//  CDVWXPay.m
//  KClient
//
//  Created by LanHai on 15/12/9.
//
//

#import "CDVWXPay.h"
#import <CommonCrypto/CommonDigest.h>
#import <arpa/inet.h>
#include <ifaddrs.h>
#import "ASIFormDataRequest.h"
#import "NSDictionary+Additions.h"
#import "NoteXMLParser.h"
#import "WXApi.h"


#define kRandomLength 30
#define WXURL @"https://api.mch.weixin.qq.com/pay/unifiedorder"

static const NSString *kRandomAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
@interface CDVWXPay()

@property (nonatomic, copy)NSString *key;
@property (nonatomic, copy)NSString *callBackID;

@end
@implementation CDVWXPay

- (void)pay:(CDVInvokedUrlCommand *)command{
    
    self.callBackID = command.callbackId;
    if (![WXApi isWXAppInstalled]) {
        
        CDVPluginResult *pluginResultSuccess = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:-6];
        NSLog(@"没有安装微信 》》》》%@",pluginResultSuccess);
        [self.commandDelegate sendPluginResult:pluginResultSuccess callbackId:command.callbackId];
        return;
        
    }
    if(command.arguments.count != 8){
        
        

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:-7];

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        NSLog(@"信息不全》》》》%@",pluginResult);
        return;
    }
    
    NSString *appid = command.arguments[0];                                     //公众账号ID
    NSString *mch_id = command.arguments[1];                                    //商户号
    self.key = command.arguments[2];                                            //api_key
    NSString *notify_url = command.arguments[3];                                //接收微信支付异步通知回调地址
    NSString *out_trade_no = command.arguments[4];                              //商户系统内部的订单号,
    NSString *total_fee = command.arguments[5];                                 //订单总金额
    NSString *body = command.arguments[6];                                      //商品或支付单简要描述
    NSString *detail = command.arguments[7];                                    //商品详情
    NSString *spbill_create_ip = [self getIPAddress];                           //APP和网页支付提交用户端ip
    NSString *trade_type = @"APP";                                              //交易类型
    NSString *nonce_str = [self getString];                                     //随机字符串
    
    if (appid == [NSNull null] || mch_id == [NSNull null] || self.key == [NSNull null] || notify_url == [NSNull null] || out_trade_no == [NSNull null] || total_fee == [NSNull null] || body == [NSNull null] || spbill_create_ip == [NSNull null] || detail == [NSNull null]) {
        CDVPluginResult *pluginResultSuccess = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:-3];
        NSLog(@"这是微信支付信息不完整 》》》》%@",pluginResultSuccess);
        [self.commandDelegate sendPluginResult:pluginResultSuccess callbackId:command.callbackId];
        return;
    }
    NSString *stringA = [NSString stringWithFormat:@"appid=%@&body=%@&mch_id=%@&nonce_str=%@&notify_url=%@&out_trade_no=%@&spbill_create_ip=%@&total_fee=%@&trade_type=%@",appid,body,mch_id,nonce_str,notify_url,out_trade_no,spbill_create_ip,total_fee,trade_type];
    
    NSString *stringSignTemp = [stringA stringByAppendingFormat:@"&key=%@",self.key];
    
    NSString *sign = [self md5:stringSignTemp];                                  //签名
    sign = [sign uppercaseStringWithLocale:[NSLocale currentLocale]];
    NSLog(@"%@",sign);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPay:) name:@"wxzf" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxReturn:) name:@"wxReturnInfo" object:nil];

    
    NSMutableDictionary *wxDict = [NSMutableDictionary dictionaryWithCapacity:0];
    [wxDict setObject:appid forKey:@"appid"];
    [wxDict setObject:body forKey:@"body"];
    [wxDict setObject:mch_id forKey:@"mch_id"];
    [wxDict setObject:nonce_str forKey:@"nonce_str"];
    [wxDict setObject:notify_url forKey:@"notify_url"];
    [wxDict setObject:out_trade_no forKey:@"out_trade_no"];
    [wxDict setObject:spbill_create_ip forKey:@"spbill_create_ip"];
    [wxDict setObject:total_fee forKey:@"total_fee"];
    [wxDict setObject:trade_type forKey:@"trade_type"];
    [wxDict setObject:sign forKey:@"sign"];
    
    
    NSString *xmlStr = [wxDict getWXXml];
    NSData *xmlData = [xmlStr dataUsingEncoding:NSUTF8StringEncoding];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:WXURL]];
    
//    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    
    [request setRequestMethod:@"POST"];
    request.postBody = [NSMutableData dataWithData:xmlData];
    [request setDelegate:self]; //异步方法
    
    [request startSynchronous];
    
    NSError *error = [request error];
    NSData *responses;
    if (error) {
        
        CDVPluginResult *pluginResultSuccess = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:-4];
        NSLog(@"这是微信支付下单失败 》》》》%@",pluginResultSuccess);
        [self.commandDelegate sendPluginResult:pluginResultSuccess callbackId:command.callbackId];
        return;
    }
    responses = [request responseData];
    
    NoteXMLParser *parser = [[NoteXMLParser alloc]init];
    
    [parser start:responses];
    
    NSLog(@"%@",parser.notes);
   
    
    
    
    
    
}

- (void)requestFinished:(ASIHTTPRequest *)request

{
    NSData *responses = [request responseData];
    NSString *response = [[NSString alloc]initWithData:responses encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
    
    
}


- (void)wxPay:(NSNotification *)notifi{
    
    
    NSDictionary *wxReturnInfo = [notifi object];
    NSLog(@"%@",wxReturnInfo);
    
    if ([[wxReturnInfo objectForKey:@"return_code"] isEqualToString:@"SUCCESS"] && [[wxReturnInfo objectForKey:@"return_msg"] isEqualToString:@"OK"]) {
        PayReq *payRequest = [[PayReq alloc]init];
        payRequest.partnerId = [wxReturnInfo objectForKey:@"mch_id"];
        payRequest.prepayId = [wxReturnInfo objectForKey:@"prepay_id"];
        payRequest.package = @"Sign=WXPay";
        payRequest.nonceStr = [wxReturnInfo objectForKey:@"nonce_str"];
        payRequest.timeStamp = [self getTime];
        
        NSString *stringA = [NSString stringWithFormat:@"appid=%@&noncestr=%@&package=%@&partnerid=%@&prepayid=%@&timestamp=%d",[wxReturnInfo objectForKey:@"appid"],payRequest.nonceStr,payRequest.package,payRequest.partnerId,payRequest.prepayId,payRequest.timeStamp];
        NSString *stringSignTemp = [stringA stringByAppendingFormat:@"&key=%@",self.key];
        NSString *sign = [self md5:stringSignTemp];
        sign = [sign uppercaseStringWithLocale:[NSLocale currentLocale]];
        payRequest.sign = sign;
        
        [WXApi sendReq:payRequest];
    }
    else {
        
        CDVPluginResult *pluginResultSuccess = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:-5];
        NSLog(@"这是微信支付下单成功,反回了错误 》》》》%@",pluginResultSuccess);
        [self.commandDelegate sendPluginResult:pluginResultSuccess callbackId:self.callBackID];
        
    }
    
    
    
    
}


- (void)wxReturn:(NSNotification *)nitifi{
    
    int returnID = [[nitifi object] intValue];
    
    CDVPluginResult *pluginResultSuccess = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:returnID];
    NSLog(@"这是微信支付回调 》》》》%@",pluginResultSuccess);
    [self.commandDelegate sendPluginResult:pluginResultSuccess callbackId:self.callBackID];
    
    
    
    
}



- (UInt32)getTime{
    
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"-------%@",locationString);
    
    
    return (UInt32)[senddate timeIntervalSince1970];
    
}


- (NSString *)getString{
    
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity:kRandomLength];
    for (int i = 0; i < kRandomLength; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }
    
    return randomString;
}

// Get IP Address



- (NSString *)getIPAddress {
    NSString *address = @"127.0.0.1";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
} 

-(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}



@end

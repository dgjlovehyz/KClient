//
//  CDVPay.m
//  KshopClient
//
//  Created by 蓝海 on 15/7/30.
//
//

#import "CDVPay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@implementation CDVPay


- (void)alipay:(CDVInvokedUrlCommand *)command
{
    
    
    
    NSLog(@"command.arguement = %@",command.arguments);
    NSString *productName = command.arguments[1];
    NSString *productDescription = command.arguments[2];
    NSString *price = command.arguments[3];
    NSString *privateKey = command.arguments[4];
    NSString *partner = command.arguments[5];
    NSString *seller = command.arguments[6];
    NSString *tradeNO = command.arguments[7];
    NSLog(@"tradeNO = %@",tradeNO);
    NSString *notifyUR = command.arguments[8];
    
    if (productName == [NSNull null] || productDescription == [NSNull null] || price == [NSNull null] || privateKey == [NSNull null] || partner == [NSNull null] || seller == [NSNull null] || tradeNO == [NSNull null] || notifyUR == [NSNull null]) {
        
        CDVPluginResult *pluginResultSuccess = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"false"];
        NSLog(@"这是支付信息不完整 》》》》%@",pluginResultSuccess);
        [self.commandDelegate sendPluginResult:pluginResultSuccess callbackId:command.callbackId];
        return;
    }
    
    Order *order = [[Order alloc]init];
    
    order.partner = partner;
    
    order.seller = seller;
    order.tradeNO = tradeNO; //订单ID（由商家自行制定）
    order.productName = [NSString stringWithFormat:@"商品：%@",productName]; //商品标题
    order.productDescription = [NSString stringWithFormat:@"描述：%@",productDescription]; //商品描述
    order.amount = price; //商品价格
    order.notifyURL = notifyUR; //回调URL
    NSLog(@"支付宝回调URL：%@",order.notifyURL);
    
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"yangxin";
    //编码格式
    appScheme = [appScheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        @try {
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut 22= %@",resultDic);
                NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
                NSString *resultInfo =[NSString stringWithFormat:@"%d",resultStatus];
                NSString *memo = resultDic[@"memo"];
                NSLog(@"memo = %@",memo);
                CDVPluginResult *pluginResultSuccess = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:resultInfo];
                NSLog(@"这是支付成功地回调ing 》》》》%@",pluginResultSuccess);
                [self.commandDelegate sendPluginResult:pluginResultSuccess callbackId:command.callbackId];
            }];

           
        }
        @catch (NSException *exception) {
            NSLog(@"CDVPay - Cannot set subject; error: %@", exception);
        }
    }
    
    
}


@end

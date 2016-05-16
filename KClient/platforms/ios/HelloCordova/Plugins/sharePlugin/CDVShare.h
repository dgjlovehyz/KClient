//
//  CDVShare.h
//  KshopClient
//
//  Created by 蓝海 on 15/8/11.
//
//


#import <Cordova/CDVPlugin.h>
#import <MessageUI/MessageUI.h>

@interface CDVShare : CDVPlugin <MFMailComposeViewControllerDelegate>
@property (nonatomic ,copy)NSString *shareTitle;
@property (nonatomic ,copy)NSString *shareString;
@property (nonatomic ,copy)NSString *shareURL;
@property (nonatomic ,copy)NSString *shareimgURL;

//- (void)share1:(CDVInvokedUrlCommand *)command;
- (void)share:(CDVInvokedUrlCommand *)command;

@end

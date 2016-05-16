//
//  CDVShare.m
//  KshopClient
//
//  Created by 蓝海 on 15/8/11.
//
//
#define screenSize  [UIScreen mainScreen].bounds.size
#import "CDVShare.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"

#import "WeiboSDK.h"
#import "AppDelegate.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
 
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

#import <MessageUI/MFMailComposeViewController.h>

@interface CDVShare()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, copy)NSString *imageUrl;

@end

@implementation CDVShare


#pragma -mark -- shareSDK --
- (void)share:(CDVInvokedUrlCommand *)command
{
    if (command.arguments.count<5) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"分享数据有误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
        return;
    }
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString *webUrl = command.arguments[3];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *title =   command.arguments[1];
    NSString *text = [NSString stringWithFormat:@"我在%@发现了一个不错的商品，赶快来看看吧。",app_Name];
    _imageUrl = command.arguments[4];
    
    int shareID;
    NSString *shareTerrace = command.arguments[0];
    if ([shareTerrace isEqualToString:@"wx"]) {
        shareID = SSDKPlatformSubTypeWechatSession;
    } else if ([shareTerrace isEqualToString:@"py"]){
        shareID = SSDKPlatformSubTypeWechatTimeline;
    } else if ([shareTerrace isEqualToString:@"qq"]){
        shareID = SSDKPlatformSubTypeQQFriend;
    } else if ([shareTerrace isEqualToString:@"qzone"]){
        shareID = SSDKPlatformSubTypeQZone;
    } else if ([shareTerrace isEqualToString:@"xlwb"]){
        text = [text stringByAppendingString:webUrl];
        shareID = SSDKPlatformTypeSinaWeibo;
    } else if ([shareTerrace isEqualToString:@"txwb"]){
        shareID = SSDKPlatformTypeTencentWeibo;
    } else if ([shareTerrace isEqualToString:@"dx"]){
        shareID = SSDKPlatformTypeSMS;
        text = [text stringByAppendingString:title];
        text = [text stringByAppendingString:webUrl];
    } else if ([shareTerrace isEqualToString:@"email"]){

//        [self sendMail:nil content:command.arguments[1]];
        text = [text stringByAppendingString:webUrl];
        [shareParams SSDKSetupShareParamsByText:text images:_imageUrl url:webUrl title:title type:SSDKContentTypeAuto];
        [self showMailPicker:shareParams];
        shareID = SSDKPlatformTypeMail;
        return;
    } else{
        shareID = SSDKPlatformTypeUnknown;
        return;
    }
    
    [shareParams SSDKSetupShareParamsByText:text images:_imageUrl url:webUrl title:title type:SSDKContentTypeAuto];
    
    __weak __typeof(self) weakSelf = self;
    [[AppDelegate app] setOpenUrlType:(SNSOpenURLTypeNone)];
    [ShareSDK share:shareID parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        NSLog(@"share error = %@",error);
        switch (state) {
                
            case SSDKResponseStateSuccess:
            {
                [[[UIAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                break;
            }
            case SSDKResponseStateFail:
            {
                [[[UIAlertView alloc] initWithTitle:nil message:@"分享失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                break;
            }
            case SSDKResponseStateCancel:
            {

                break;
            }
            default:break;
        }
    }];
}


//发短信-内容,收件人列表
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [[[[AppDelegate app] window] rootViewController] presentModalViewController:controller animated:YES];
    }
}

//短信完成处理
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:YES];
    if (result == MessageComposeResultCancelled) {
        NSLog(@"Message cancelled");
    } else if (result == MessageComposeResultSent) {
        NSLog(@"Message sent");
    } else {
        NSLog(@"Message failed");
    }
}

//发送邮件-收件人,内容
-(void)sendMail:(NSString *)subject content:(NSString *)content
{
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    if([MFMailComposeViewController canSendMail])
    {
        [controller setSubject:subject];
        [controller setMessageBody:content isHTML:NO];
        controller.mailComposeDelegate = self;
        [[[[AppDelegate app] window] rootViewController] presentModalViewController:controller animated:YES];
    }
}


/*
 *  分享到QQ空间-图文消息
 */
-(void)shareTencentQZoneWithText:(NSString*)title desc:(NSString*)desc imageUrl:(NSURL*)imageUrl webUrl:(NSString*)webUrl
{
    dispatch_async(dispatch_get_main_queue(), ^{
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:webUrl] title:title description:desc previewImageURL:imageUrl];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        [QQApiInterface SendReqToQZone:req];
    });
}

/*
 *  分享到QQ好友-图文消息
 */
-(void)shareTencentQQWithText:(NSString*)title desc:(NSString*)desc imageUrl:(NSURL*)imageUrl webUrl:(NSString*)webUrl
{
    dispatch_async(dispatch_get_main_queue(), ^{
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:webUrl] title:title description:desc previewImageURL:imageUrl];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        [QQApiInterface sendReq:req];
    });
}

/*
 *  分享到微信朋友圈-图文消息
 */
-(void)shareCircleWithText:(NSString*)title desc:(NSString*)desc thumbData:(NSData*)thumbData webUrl:(NSString*)webUrl
{
    dispatch_async(dispatch_get_main_queue(), ^{
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = desc;
        message.thumbData = thumbData;
        
        WXWebpageObject *mediaObject = [WXWebpageObject object];
        mediaObject.webpageUrl = webUrl;
        
        message.mediaObject = mediaObject;
        message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK_KCLIENT";
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneTimeline;
        [WXApi sendReq:req];
    });
}

/*
 *  分享到微信好友-图文消息
 */
-(void)shareWechatWithText:(NSString*)title desc:(NSString*)desc thumbData:(NSData*)thumbData webUrl:(NSString*)webUrl
{
    dispatch_async(dispatch_get_main_queue(), ^{
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = desc;
        message.thumbData = thumbData;
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = webUrl;
        
        message.mediaObject = ext;
        message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK_KCLIENT";
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
    });
}

//邮件
-(void)showMailPicker:(NSDictionary *)message {
    if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
        [self sendEmailAction:message]; // 调用发送邮件的代码
    }
    else {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"mailto://devprograms@apple.com"]];
    }
    
}

- (void)sendEmailAction:(NSDictionary *)message{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置邮件主题
    [mailCompose setSubject:[message objectForKey:@"title"]];
    // 设置收件人
    [mailCompose setToRecipients:@[@""]];
    // 设置抄送人
    [mailCompose setCcRecipients:@[@""]];
    // 设置密抄送
    [mailCompose setBccRecipients:@[@""]];
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = [message objectForKey:@"text"];
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
//    NSData *imageDatas = [NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]];
//    UIImage *image = [UIImage imageWithData:imageDatas];
//    NSData *imageData = UIImagePNGRepresentation(image);
//    [mailCompose addAttachmentData:imageData mimeType:@"" fileName:@"custom.png"];
    // 弹出邮件发送视图
    [self.viewController presentViewController:mailCompose animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
            case MFMailComposeResultCancelled: // 用户取消编辑
            [[[UIAlertView alloc] initWithTitle:nil message:@"取消分享" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            break;
            case MFMailComposeResultSaved: // 用户保存邮件
            [[[UIAlertView alloc] initWithTitle:nil message:@"取消分享" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            break;
            case MFMailComposeResultSent: // 用户点击发送
            [[[UIAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            break;
            case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            [[[UIAlertView alloc] initWithTitle:nil message:@"分享失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}


@end

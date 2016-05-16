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
//  MainViewController.h
//  HelloCordova
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "MainViewController.h"
#import "AFNetworking.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ErrorLogManagement.h"
#import "UpatePlugin.h"
#import "ZipArchive.h"
#import "RNCachingURLProtocol.h"
static MainViewController *mainController;


@implementation MainViewController

+ (MainViewController *)mainController{
    
    if (mainController == nil) {
        mainController = [[MainViewController alloc]init];
    }
    
    return mainController;
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Uncomment to override the CDVCommandDelegateImpl used
        // _commandDelegate = [[MainCommandDelegate alloc] initWithViewController:self];
        // Uncomment to override the CDVCommandQueue used
        // _commandQueue = [[MainCommandQueue alloc] initWithViewController:self];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    // View defaults to full size.  If you want to customize the view's size, or its subviews (e.g. webView),
    // you can do so here.

    [super viewWillAppear:animated];
    
    
    self.webView.frame = CGRectMake(0,20, self.view.bounds.size.width, self.view.bounds.size.height - 20);
    //去除滚动条
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.webView.scrollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)launchImageChange:(NSString *)path andType:(NSString *)type{
    
    UIImageView *launchView = [[UIImageView alloc] init];
    if ([type isEqualToString:@"old"]) {
        launchView.image = [UIImage imageNamed:path];
    }
    else {
        launchView.image = [UIImage imageWithContentsOfFile:path];
    }
    
    launchView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //    launchView.backgroundColor = [UIColor orangeColor];
    //    launchView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:launchView];
    
    
    [UIView animateWithDuration:5.0f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         launchView.alpha = 0.0f;
                         launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
                         
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [launchView removeFromSuperview];
                         
                     }];
    
    
}


- (NSString *)getLaunchImagePath{
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize viewSize = rect_screen.size;
    NSString *viewOrientation = @"Portrait";    //横屏请设置成 @"Landscape"
    NSString *launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    
    return launchImage;
    
}

- (NSString *)getScreenImageName{
    
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    CGSize iphone35 = CGSizeMake(320, 480);
    CGSize iphone4 = CGSizeMake(320, 568);
    CGSize iphone47 = CGSizeMake(375, 667);
    CGSize iphone55 = CGSizeMake(414, 736);
    if (CGSizeEqualToSize(size_screen, iphone35)) {
        return @"mdpi";
    }
    else if (CGSizeEqualToSize(size_screen, iphone4)) {
        return @"hdpi";
    }
    else if (CGSizeEqualToSize(size_screen, iphone47)) {
        return @"xhdpp";
    }
    else if (CGSizeEqualToSize(size_screen, iphone55)) {
        return @"xxhdpi";
    }
    
    
    return @"null";
    
}

- (BOOL)isNewLaunchImage:(NSNumber *)Newtime{
    
    NSUserDefaults *time = [NSUserDefaults standardUserDefaults];
    //    [time removeObjectForKey:@"oldTime"];
    //    NSLog(@"%@",[time objectForKey:@"oldTime"]);
    
    if (![time objectForKey:@"oldTime"]) {
        return YES;
    }
    else if ([[time objectForKey:@"oldTime"] longLongValue] < [Newtime longLongValue]) {
        return YES;
    }
    else {
        return NO;
    }
}

//loading页
- (void)downloadLaunhImage{
    
    
    //获取屏幕大小
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSLog(@"%@",documentsPath);
    NSString *imageName = [NSString stringWithFormat:@"newLaunchImage.png"];
    NSString *imagePath = [documentsPath stringByAppendingFormat:@"/newsImage"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    imagePath = [imagePath stringByAppendingPathComponent:imageName];
    NSString *appInfoPath = [[NSBundle mainBundle] pathForResource:@"appInfo" ofType:@"plist"];
    
    NSDictionary *appInfoDic = [NSDictionary dictionaryWithContentsOfFile:appInfoPath];
    
    NSString *launchImageUrl = [NSString stringWithFormat:@"%@service/home/startup.html",[appInfoDic objectForKey:@"AppHost"]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:launchImageUrl]];
    
    [request setRequestMethod:@"GET"];
    [request startSynchronous];
    
    NSError *error = [request error];
    NSDictionary *launchImageDic = nil;
    ErrorLogManagement *manager = [ErrorLogManagement errorlog];
    if (!error) {
        launchImageDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        
    }
    else{
        
        errorModel *model = [errorModel createErrorModel:[NSNumber numberWithInt:3] andErrorCode:[NSNumber numberWithInt:-601] andDescribe:@"网络请求异常" andExceptionInfo:[NSString stringWithFormat:@"%@",error]];
        [manager sendErrorlog:model];
    }
    NSLog(@"launch error = %@",error);
    if (launchImageDic == nil || launchImageDic.count == 0) {
        
        return;
    }
    
    if ([[launchImageDic objectForKey:@"data"] count] > 0) {
        
        if ([[launchImageDic objectForKey:@"status"] intValue] == 0) {
            
            
            NSDictionary *dataDic = [launchImageDic objectForKey:@"data"];
            
            if ([[dataDic objectForKey:@"enabled"] intValue] && [self isNewLaunchImage:[dataDic objectForKey:@"change"]]) {
                NSDictionary *fileData = [dataDic objectForKey:@"files"];
                NSArray *iosImage = [fileData objectForKey:@"ios_images"];
                NSString *imageUrl;
                
                NSString *typeName = [self getScreenImageName];
                
                for (NSDictionary *imageDic in iosImage) {
                    
                    if ([[imageDic objectForKey:@"type"] isEqualToString:typeName]) {
                        imageUrl = [imageDic objectForKey:@"file"];
                    }
                    
                }
                
                
                if (imageUrl.length > 0) {
                    
                    // something
                    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                    if (imageData.length > 0) {
                        
                        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
                            [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
                        }
                        BOOL isSave = [imageData writeToFile:imagePath atomically:YES];
                        
                        if (isSave) {
                            NSLog(@"图片保存成功");
                            NSUserDefaults *time = [NSUserDefaults standardUserDefaults];
                            [time setValue:[dataDic objectForKey:@"change"] forKey:@"oldTime"];
                            [time synchronize];
                            
                        }
                    }
                    else {
                        errorModel *model = [errorModel createErrorModel:[NSNumber numberWithInt:2] andErrorCode:[NSNumber numberWithInt:-701] andDescribe:@"lanuchImage下载失败" andExceptionInfo:@"启动图下载失败"];
                        [manager recordLog:model];
                    }
                    
                }
            }else {
            }
        }
        else {
        }
    }
    else {
    }
}

- (void)qidonglaunch{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *imageName = [NSString stringWithFormat:@"newLaunchImage.png"];
    NSString *imagePath = [documentsPath stringByAppendingFormat:@"/newsImage"];
    
    imagePath = [imagePath stringByAppendingPathComponent:imageName];
    NSString *oldImagePath = [self getLaunchImagePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        
        
        [self launchImageChange:imagePath andType:@"new"];
    }
    else {
        [self launchImageChange:oldImagePath andType:@"old"];
    }
    
    
    
}

#pragma -mark -- 注册 --
- (void)newLogin{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"http://1279423350.qy.test.cn/"]];
    NSString *path = @"ver/action/ClientRegister";
    //申明返回的结果是二进制类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //声明postjson数据
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    //            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //获取手机信息
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[UIDevice currentDevice].identifierForVendor.UUIDString  forKey:@"key"];
    NSString *os = [NSString stringWithFormat:@"%@:%@",[[UIDevice currentDevice]systemName],[[UIDevice currentDevice]systemVersion]];
    [dic setObject:os  forKey:@"os"];
    [dic setObject:[self getResolution] forKey:@"resolution"];
    [dic setObject:[[UIDevice currentDevice] model] forKey:@"brand"];
    [dic setObject:@"0" forKey:@"cpu"];//[NSNumber numberWithInt:0]
    [dic setObject:@"0" forKey:@"memory"];
    [dic setObject:@"0" forKey:@"hardware"];
    NSString *key = [[UIDevice currentDevice].identifierForVendor UUIDString];
    [dic setObject:key forKey:@"key"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:dic forKey:@"postData"];
    
    
    //            [manager POST:path parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
    //
    //                NSLog(@"%@",responseObject);
    //
    //            } failure:^(NSURLSessionDataTask *task, NSError *error) {
    //
    //                NSLog(@"%@",error);
    //            }];
    NSString *addressPath = [[NSBundle mainBundle] pathForResource:@"appAddress" ofType:@"plist"];
    NSDictionary *addressDic = [NSDictionary dictionaryWithContentsOfFile:addressPath];
    NSString *loginUrl = [addressDic objectForKey:@"AppRegAddress"];
    [manager POST:loginUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *returnInfo = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        if ([[[returnInfo objectForKey:@"root"] objectForKey:@"state"] isEqualToString:@"success"]) {
            NSLog(@"注册成功");
            NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/loginInfo.plist"];
            
            [returnInfo writeToFile:documentPath atomically:YES];
        }
        else {
            NSLog(@"注册失败1");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"-------%@",error);
        NSLog(@"注册失败2");
    }];
    
}

- (void)newLoginTow{
    NSString *addressPath = [[NSBundle mainBundle] pathForResource:@"appAddress" ofType:@"plist"];
    NSDictionary *addressDic = [NSDictionary dictionaryWithContentsOfFile:addressPath];
    NSString *loginUrl = [addressDic objectForKey:@"AppRegAddress"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:loginUrl]];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[UIDevice currentDevice].identifierForVendor.UUIDString  forKey:@"key"];
    NSString *os = [NSString stringWithFormat:@"%@:%@",[[UIDevice currentDevice]systemName],[[UIDevice currentDevice]systemVersion]];
    [dic setObject:os  forKey:@"os"];
    [dic setObject:[self getResolution] forKey:@"resolution"];
    [dic setObject:[[UIDevice currentDevice] model] forKey:@"brand"];
    [dic setObject:@"0" forKey:@"cpu"];//[NSNumber numberWithInt:0]
    [dic setObject:@"0" forKey:@"memory"];
    [dic setObject:@"0" forKey:@"hardware"];
    NSString *key = [[UIDevice currentDevice].identifierForVendor UUIDString];
    [dic setObject:key forKey:@"key"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:dic forKey:@"postData"];
    
    //    [request setPostValue:dic forKey:@"postData"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    request.postBody = [NSMutableData dataWithData:data];
    
    [request startSynchronous];
    ErrorLogManagement *manager = [ErrorLogManagement errorlog];
    NSError *error = [request error];
    NSData *data1 = nil;
    if (!error) {
        data1 = [request responseData];
        
    }
    
    NSLog(@"error = %@",error);
    if (data1 != nil) {
        NSDictionary *dicc = [NSJSONSerialization JSONObjectWithData:data1 options:0 error:nil];
        NSLog(@"%@",dicc);
        
        if (dicc.count == 0) {
            
            return;
        }
        NSString *documentPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/loginInfo.plist"];
        [dicc writeToFile:documentPath atomically:YES];
    }
    else {
        errorModel *model = [errorModel createErrorModel:[NSNumber numberWithInt:3] andErrorCode:[NSNumber numberWithInt:-601] andDescribe:@"网络请求错误(注册)" andExceptionInfo:[NSString stringWithFormat:@"%@",error]];
        [manager recordLog:model];
        NSLog(@"注册失败");
        
    }
}

#pragma -makr -- 获取分辨率 --
- (NSString *)getResolution{
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    NSString *Resoution = [NSString stringWithFormat:@"%f * %f",size_screen.height * scale_screen, size_screen.width * scale_screen];
    
    return Resoution;
}

#pragma -mark -- js交互获取图片 --

//获取web里的所有的img url
- (NSString *)createImgArrayJavaScript{
    NSString *js = @"var imgArray = document.getElementsByTagName('img'); var imgstr = ''; function f(){ for(var i = 0; i < imgArray.length; i++){ imgstr += imgArray[i].src;imgstr += ';';} return imgstr; } f();";
    return js;
}

//返回web img图片的数量
- (NSString *)createGetImgNumJavaScript{
    NSString *js = @"var imgArray = document.getElementsByTagName('img');function f(){ var num=imgArray.length;return num;} f();";
    return js;
}


#pragma mark - ViewLoad
- (void)viewDidLoad
{

    
    // Do any additional setup after loading the view from its nib.
    self.reachability = [GCNetworkReachability reachabilityWithHostName:@"www.baidu.com"];
    __weak UIAlertView *netWork = self.netWorking;
    __block ErrorLogManagement *manager = [ErrorLogManagement errorlog];
    __block errorModel *model  = [errorModel createErrorModel:[NSNumber numberWithInt:3] andErrorCode:[NSNumber numberWithInt:-501] andDescribe:@"没有网络" andExceptionInfo:@"NetworkReachabilityStatusNotReachable"];
    [self.reachability startMonitoringNetworkReachabilityWithHandler:^(GCNetworkReachabilityStatus status) {
        
        // this block is called on the main thread
        switch (status) {
            case GCNetworkReachabilityStatusNotReachable:
                NSLog(@"No connection");
                [netWork  show];
                
                break;
            case GCNetworkReachabilityStatusWWAN:
            case GCNetworkReachabilityStatusWiFi:
                // e.g. start syncing...
                [manager sendLocationMessage];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    // something
                    [self newLoginTow];
                    [self downloadLaunhImage];
                });
                [self initter];
                break;
        }
        
    }];
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    [super viewDidLoad];
    [self qidonglaunch];
    
    
    
}


- (void)initter{
    
    
    CDVInvokedUrlCommand *command = [[CDVInvokedUrlCommand alloc]init];
    command.startMark = @"Start";
    [[[UpatePlugin alloc]init] update:command];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAppVer:) name:@"appVer" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDataVer:) name:@"dataVer" object:nil];
}
#pragma -mark -- 通知中心升级 --

- (void)updateAppVer:(NSNotification *)notifi{
    
    _kclientDict = [notifi object];
    
    NSString *title = nil;
    if ([[_kclientDict objectForKey:@"share"] intValue] == 1) {
        title = @"下次再说";
    }
    
    NSString *message = [NSString stringWithFormat:@"%@",[_kclientDict objectForKey:@"description"]];
    _AppAlert = [[UIAlertView alloc]initWithTitle:[_kclientDict objectForKey:@"title"] message:message delegate:self cancelButtonTitle:@"立即升级" otherButtonTitles:title, nil];
    [_AppAlert show];
    _AppAlert.delegate = self;
    //获取客户端下载地址
   
}

- (void)updateDataVer:(NSNotification *)notifi{
    
    _dataDict = [notifi object];
    _downloadUrl = [_dataDict objectForKey:@"enclosure"];
    NSString *title = nil;
    if ([[_dataDict objectForKey:@"share"] intValue] == 1) {
        title = @"以后再说";
        
    }
    NSString *message = [NSString stringWithFormat:@"%@",[_dataDict objectForKey:@"description"]];
    _DataAlert = [[UIAlertView alloc]initWithTitle:[_dataDict objectForKey:@"title"] message:message delegate:self cancelButtonTitle:@"立即下载" otherButtonTitles:title, nil];
    [_DataAlert show];
    _DataAlert.delegate = self;
   
}


- (UIAlertView *)netWorking{
    
    if (!_netWorking) {
        _netWorking = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您无网络,请确保网络畅通" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        _netWorking.delegate = self;
        
    }
    
    return _netWorking;
}

#pragma -mark UIAlertDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == _DataAlert) {
        if(buttonIndex == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"后台持续下载更新中" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            　　[alert show];
            [self doDownLoadInADispacthWithNewSessionUrl:_downloadUrl];
        }
        else {
            NSLog(@"不下载data");
        }
    }
    else if (alertView == _PromptAlert){
        
        exit(0);
    }
    else if (alertView == _AppAlert) {
        if (buttonIndex == 0) {
            
            NSString *appInfoPath = [self.documentPath stringByAppendingPathComponent:@"appInfo.plist"];
            NSDictionary *appInfoDic = [NSDictionary dictionaryWithContentsOfFile:appInfoPath];
            NSString *host = [appInfoDic objectForKey:@"AppHost"];
            host  = [host stringByReplacingOccurrencesOfString:@"/" withString:@""];
            host  = [host stringByReplacingOccurrencesOfString:@"http:" withString:@""];
            host  = [host stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *updateUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://www.iyishang.cn/t/download/lhsp%@/iphone/app/lhsp%@.plist",host,host];
            BOOL isRight = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
            if (isRight) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"后台持续下载更新中" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
                　　[alert show];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
            }
            
        } else {
            NSLog(@"不下载");
        }
    }
    else if (alertView == _netWorking) {
        exit(0);
        
    }
    
}

//下载解压ZIP包调用的方法：这个方法将来要带一个版本参数，传入版本号，下载版本号对应的包
- (void)doDownLoadInADispacthWithNewSessionUrl:(NSString *)newSession
{
    //    if ([[NSFileManager defaultManager] fileExistsAtPath:_sessionPath]) {
    //         NSLog(@"下载之前先把之前的版本标记换成当前可用的版本，以便下次版本更新的时候，可以以当前版本作为老版本来更新");
    //        NSString *plistFile = [NSString stringWithFormat:@"%@%@",self.documentPath,@"/session.plist"];
    ////        NSMutableArray *sessionArry = [NSMutableArray arrayWithObjects:_nowSession, nil];
    ////        [sessionArry writeToFile:plistFile atomically:YES];
    //    }
    
    //开劈一个分线程来做下载
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //>>>>>>>>启动之后再去下载ZIP包
        
        //ZIP包存放的的下载地址，这里使用的一个第三方的空间，正式发布时要用自己的服务器地址
        NSURL  *url = [NSURL URLWithString:newSession];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        /*
         同步下载压缩包
         */
        NSLog(@"进入分线程并：开始下载压缩包");
        NSError *error = nil;
        NSData  *data = [NSURLConnection sendSynchronousRequest:request
                                              returningResponse:nil
                                                          error:&error];
        // NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //NSString* path = [paths objectAtIndex:0];
        if (data != nil){
            
            
            
            NSLog(@"下载成功");
            NSFileManager *manager = [NSFileManager defaultManager];
            NSString *filename = @"www.zip";
            NSString *filePath = [self.documentPath stringByAppendingPathComponent:filename];
            NSLog(@"Filepath:%@",filePath);
            NSString *unzipPath = [self.documentPath stringByAppendingPathComponent:@"www"];
            NSLog(@"unzipPath = %@",unzipPath);
            
            if ([data writeToFile:filePath atomically:YES])
            {
                NSLog(@"保存成功.");
                //解压
                ZipArchive *archive = [[ZipArchive alloc] init];
                if ([archive UnzipOpenFile:filePath])
                {
                    [manager removeItemAtPath:unzipPath error:nil];
                    
                    if ([archive UnzipFileTo:self.documentPath overWrite:YES])
                    {
                        //[self.mes setStringValue:@"正在解压.."];
                        NSLog(@"解压成功");
                        //这里需要解压后的文件启动
                        NSString *unzipWWWfile = [NSString stringWithFormat:@"%@%@",self.documentPath,@"/www"];
                        NSLog(@"unzipWWWfile::%@",unzipWWWfile);
                        if ([[NSFileManager defaultManager] fileExistsAtPath:unzipWWWfile])
                        {
                            
                            NSLog(@"存在unzipWWWfile文件:%@",unzipWWWfile);
                            self.documentIndexPath1 = [NSString stringWithFormat:@"%@%@",unzipWWWfile,@"/app/index.html"];
                            NSString* startFilePath1 = @"";
                            if ([[NSFileManager defaultManager] fileExistsAtPath:self.documentIndexPath1]) {
                                
                                NSLog(@"下载的包里存在unzipWWWfile文件下地/app/index.html:%@",self.documentIndexPath1);
                                startFilePath1 = self.documentIndexPath1;
                                //                               //回到主线程
                                //   这里到底是要直接启动下载的，还是下次再启动。？？？
                                
                                // dispatch_async(dispatch_get_main_queue(), ^{
                                //
                                //self.openURL = [NSURL fileURLWithPath:startFilePath1];
                                //NSLog(@"启动了新下载的的WWW文件");
                                
                                //                                  });
                                
                            }else{
                                //index.html 不存在的时候就从工程里自带的index启动
                                //回到主线程
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.documentIndexPath1 = [self.commandDelegate pathForResource:self.startPage];
                                    if (startFilePath1 == nil) {
                                        self.loadErr = [NSString stringWithFormat:@"ERROR: Start Page at '%@/%@' was not found.", self.wwwFolderName, self.startPage];
                                        NSLog(@"%@", self.loadErr);

                                    } else {
                                        
                                        NSLog(@"启动了自己带的的的WWW文件");
                                    }
                                    
                                    
                                });
                                
                            }
                        }
                        //删除压缩文件
                        [manager removeItemAtPath:filePath error:nil];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _PromptAlert = [[UIAlertView alloc]initWithTitle:@"更新提示" message:@"数据下载成功,请重新启动应用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                            [_PromptAlert show];
                            [self updateNewVersion:@"data" withNumber:[_dataDict objectForKey:@"dataver"]];
                        });
                    }
                    else
                    {
                        NSLog(@"解压失败");
                    }
                }
                [archive UnzipCloseFile];
            }
            else
            {
                NSLog(@"保存失败.");
            }
        } else {
            NSLog(@"%@", error);
        }
        
        
    });
}


- (void)updateNewVersion:(NSString *)type withNumber:(NSString *)number{
    
    NSString *appInfoPath = [self.documentPath stringByAppendingPathComponent:@"appInfo.plist"];
    NSMutableDictionary *oldAppInfo = [NSMutableDictionary dictionaryWithContentsOfFile:appInfoPath];
    if ([type isEqualToString:@"app"]) {
        [oldAppInfo setObject:number forKey:@"AppSrcVersion"];
    }
    else if ([type isEqualToString:@"data"]) {
        [oldAppInfo setObject:number forKey:@"App3wVersion"];
    }
    else {
        NSLog(@"数据有误");
        return;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:appInfoPath]) {
        BOOL isDelete = [[NSFileManager defaultManager] removeItemAtPath:appInfoPath error:nil];
        if (isDelete) {
            [oldAppInfo writeToFile:appInfoPath atomically:YES];
        }
        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

/* Comment out the block below to over-ride */

/*
- (UIWebView*) newCordovaViewWithFrame:(CGRect)bounds
{
    return[super newCordovaViewWithFrame:bounds];
}
*/

@end

@implementation MainCommandDelegate

/* To override the methods, uncomment the line in the init function(s)
   in MainViewController.m
 */

#pragma mark CDVCommandDelegate implementation

- (id)getCommandInstance:(NSString*)className
{
    return [super getCommandInstance:className];
}

- (NSString*)pathForResource:(NSString*)resourcepath
{
    return [super pathForResource:resourcepath];
}

@end

@implementation MainCommandQueue

/* To override, uncomment the line in the init function(s)
   in MainViewController.m
 */
- (BOOL)execute:(CDVInvokedUrlCommand*)command
{
    return [super execute:command];
}

@end

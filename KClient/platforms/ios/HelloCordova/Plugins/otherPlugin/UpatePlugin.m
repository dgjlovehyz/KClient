//
//  UpatePlugin.m
//  KClient
//
//  Created by ZGL on 15/11/9.
//
//

#import "UpatePlugin.h"
#import "MainViewController.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "ErrorLogManagement.h"

@implementation UpatePlugin

- (void)update:(CDVInvokedUrlCommand *)command{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.documentPath = [paths objectAtIndex:0];
    NSDictionary *updateInfo = [self checkTheUpdate];
#pragma -mark -- oooooo --
//    return;
    if (updateInfo == nil || updateInfo.count == 0) {
        return;
    }
    //写入当前工程里WWW地版本号
    //NSLog(@"标记版本号，在沙河的一个Plist文件里做标记，这样可以保证杀死进程的时候，还是记录下来当前版本。");
    NSString *appInfoPath = [self.documentPath stringByAppendingPathComponent:@"appInfo.plist"];
    

    NSMutableDictionary *oldAppInfo = [NSMutableDictionary dictionaryWithContentsOfFile:appInfoPath];
    
    NSDictionary *newVersionDic = [updateInfo objectForKey:@"version"];
    NSDictionary *newAppDic = [newVersionDic objectForKey:@"app"];
    NSDictionary *newDataDic = [newVersionDic objectForKey:@"data"];

    
    BOOL appver = NO;
    if (newAppDic.count != 0) {
        if ([self versionCompare:[newAppDic objectForKey:@"appver"] withOld:[oldAppInfo objectForKey:@"AppSrcVersion"]]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"appVer" object:newAppDic];
            appver = YES;
            return;
        }
    }
    
    BOOL dataver = NO;
    if (newDataDic.count != 0) {
        //    获取老版本号
        NSString *nowSession = [newDataDic objectForKey:@"dataver"];
        NSString *oldSession = [oldAppInfo objectForKey:@"App3wVersion"];
        
        if ([self versionCompare:nowSession withOld:oldSession]) {
            //这里直接启动老版本，不下载
            NSLog(@"比对版本号，版本一样,这里直接启动老版本，不下载");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dataVer" object:newDataDic];
            dataver = YES;
        }
    }

    if (![command.startMark isEqualToString:@"Start"]) {
        if (!dataver && !appver) {
            
            UIAlertView *DataAlert = [[UIAlertView alloc]initWithTitle:@"已经是最新版本" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [DataAlert show];
            
        }
    }
    
}

#pragma -mark -- 版本对比 --

- (BOOL)versionCompare:(NSString *)new withOld:(NSString *)old
{
    if ([new compare:old options:NSNumericSearch] == NSOrderedDescending) {
        return YES;
    } else {
        return NO;
    }
}


#pragma -mark -- 检测跟新 --
- (NSDictionary *)checkTheUpdate
{

            NSString *addressPath = [[NSBundle mainBundle] pathForResource:@"appAddress" ofType:@"plist"];
            NSDictionary *addressDic = [NSDictionary dictionaryWithContentsOfFile:addressPath];
            NSString *addressUrl = [addressDic objectForKey:@"AppUpgradeAddress"];
            
            
            NSString *loginInfoPath = [self.documentPath stringByAppendingPathComponent:@"loginInfo.plist"];
            NSDictionary *loginInfoDic = [NSDictionary dictionaryWithContentsOfFile:loginInfoPath];
            
            NSDictionary *oldVersionInfo;
            NSString * appver;
            NSString *dataver;
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *appInfoPath = [self.documentPath stringByAppendingPathComponent:@"appInfo.plist"];
            if (![[user objectForKey:@"name"] isEqualToString:@"oldUser"]) {
                NSString *appInfoPaths = [[NSBundle mainBundle] pathForResource:@"appInfo" ofType:@"plist"];
                NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:appInfoPaths];
                if ([[NSFileManager defaultManager] fileExistsAtPath:appInfoPath]) {
                    [[NSFileManager defaultManager] removeItemAtPath:appInfoPath error:nil];
                }
                [dic writeToFile:appInfoPath atomically:YES];
                [user setObject:@"oldUser" forKey:@"name"];
                [user synchronize];
            }
            ErrorLogManagement *manager = [ErrorLogManagement errorlog];
            if ([[NSFileManager defaultManager] fileExistsAtPath:appInfoPath]) {
                oldVersionInfo = [NSDictionary dictionaryWithContentsOfFile:appInfoPath];
                appver = [oldVersionInfo objectForKey:@"AppSrcVersion"];
                dataver = [oldVersionInfo objectForKey:@"App3wVersion"];
            }
            else {
                errorModel *model = [errorModel createErrorModel:[NSNumber numberWithInt:3] andErrorCode:[NSNumber numberWithInt:-801] andDescribe:@"文件读取出错" andExceptionInfo:@"appInfo文件读取失败"];
                [manager recordLog:model];
                appver = @"";
                dataver = @"";
            }
            NSString *appkey;
            if (loginInfoDic) {
                appkey = [[[loginInfoDic objectForKey:@"root"] objectForKey:@"message"] objectForKey:@"sncode"];
            }
            
            
            NSString *stringUrl = [NSString stringWithFormat:@"%@?appkey=%@&apptype=%@&appver=%@&dataver=%@",addressUrl,appkey,@"ios",appver,dataver];
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:stringUrl]];
            [request setRequestMethod:@"GET"];
            [request startSynchronous];
            
            NSError *error = [request error];
            if (!error) {
                NSData *data = [request responseData];
                NSDictionary *updateInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                return updateInfo;
            }
            else {
                errorModel *model = [errorModel createErrorModel:[NSNumber numberWithInt:3] andErrorCode:[NSNumber numberWithInt:-901] andDescribe:@"访问版本服务器失败" andExceptionInfo:[NSString stringWithFormat:@"%@",error]];
                [manager recordLog:model];
            }
            
            
            return nil;

}


@end

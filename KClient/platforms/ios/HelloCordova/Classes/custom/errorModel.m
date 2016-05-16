//
//  errorModel.m
//  KClient
//
//  Created by LanHai on 16/1/18.
//
//

#import "errorModel.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#import "MonitorIOS.h"


@implementation errorModel

+ (errorModel *)createErrorModel:(NSNumber *)level andErrorCode:(NSNumber *)errorCode andDescribe:(NSString *)describe andExceptionInfo:(NSString *)ExceptionInfo{
    
    errorModel *Model = [[errorModel alloc]init];
    Model.level = level;
    Model.errorCode = errorCode;
    Model.describe = describe;
    Model.ExceptionInfo = ExceptionInfo;
    Model.environment = [Model getRunTimeEnvironment];
    Model.time = [Model getNowTime];
    
    return Model;
}

- (NSDictionary *)modelChangeDictionary{
    
    NSMutableDictionary *logDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [logDic setObject:self.level forKey:@"Level"];
    [logDic setObject:self.errorCode forKey:@"ErrorCode"];
    [logDic setObject:self.describe forKey:@"ErrorDesc"];
    [logDic setObject:self.ExceptionInfo forKey:@"Exception"];
    [logDic setObject:self.environment forKey:@"DeviceInfo"];
    [logDic setObject:self.time forKey:@"Time"];
    
    return logDic;
}



- (NSString *)getNowTime{
    
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"-------%@",locationString);
    return locationString;
}

- (NSDictionary *)getRunTimeEnvironment{
    
    UIDevice* myDevice = [UIDevice currentDevice];
    
    NSMutableDictionary *deviceInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    CTTelephonyNetworkInfo *netWorkInfo = [[CTTelephonyNetworkInfo alloc]init];
    NSString *appInfoPath = [[NSBundle mainBundle]pathForResource:@"appInfo" ofType:@"plist"];
    NSDictionary *appInfoDic = [NSDictionary dictionaryWithContentsOfFile:appInfoPath];
    [deviceInfo setObject:myDevice.model forKey:@"Manufacturer"];
    [deviceInfo setObject:myDevice.systemVersion forKey:@"SysVersion"];
    [deviceInfo setObject:@"null" forKey:@"SysNetwork"];
    [deviceInfo setObject:[NSString stringWithFormat:@"%f",[self availableMemory]] forKey:@"SysMemory"];
    [deviceInfo setObject:[NSString stringWithFormat:@"%f",[MonitorIOS systemMonitor]] forKey:@"SysCpu"];
    [deviceInfo setObject:[appInfoDic objectForKey:@"AppSrcVersion"] forKey:@"AppVersion"];
    [deviceInfo setObject:[appInfoDic objectForKey:@"App3wVersion"] forKey:@"App3wVersion"];
    [deviceInfo setObject:[appInfoDic objectForKey:@"AppName"] forKey:@"AppPackageName"];
    [deviceInfo setObject:@"null" forKey:@"AppFristInstallTime"];
    [deviceInfo setObject:@"null" forKey:@"AppUpdateInstallTime"];
    [deviceInfo setObject:[appInfoDic objectForKey:@"Appid"] forKey:@"AppDomain"];
    
    
    return [NSDictionary dictionaryWithDictionary:deviceInfo];
}

- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}


@end

//
//  ErrorLogManagement.m
//  KClient
//
//  Created by LanHai on 16/1/15.
//
//

#import "ErrorLogManagement.h"
#import "GCNetworkReachability.h"
#import "ASIFormDataRequest.h"


@implementation ErrorLogManagement

+(ErrorLogManagement *)errorlog{
    
    return [[ErrorLogManagement alloc]init];
    
}

- (BOOL)recordLog:(errorModel *)errorModels{
    

    __weak errorModel *model = errorModels;
    
    GCNetworkReachability *reachability = [GCNetworkReachability reachabilityWithHostName:@"www.baidu.com"];
    
    [reachability startMonitoringNetworkReachabilityWithHandler:^(GCNetworkReachabilityStatus status) {
       
        switch (status) {
                case GCNetworkReachabilityStatusNotReachable:
                case GCNetworkReachabilityStatusWWAN:
                
                [self saveErrorLog:errorModels];
                
                
                break;
                case GCNetworkReachabilityStatusWiFi:
                
                // e.g. start syncing...
                
                [self sendErrorlog:model];
                
                break;
        }
    }];
    return YES;
}

- (BOOL)sendErrorlog:(errorModel *)model{
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.1.219:8081/logs/api.ashx"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSDictionary *dic = [model modelChangeDictionary];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:data];
    [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request setRequestMethod:@"POST"];
    request.postBody = tempJsonData;
    [request startSynchronous];
    
    NSError *error = [request error];
    NSDictionary *returnDic = nil;
    if (!error) {
        returnDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        
        if ([[returnDic objectForKey:@"state"] intValue] == 0) {
            NSLog(@"errorlog上传成功");
            return YES;
        }
        else {
            [self saveErrorLog:model];
            return NO;
            
        }
    }
    else {
        [self saveErrorLog:model];
        return NO;
    }
}




-(NSString *)JSONString:(NSString *)aString {
    NSMutableString *s = [NSMutableString stringWithString:aString];
    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [NSString stringWithString:s];
}

-(NSString *)JSONURLString:(NSString *)aString {
 NSMutableString *s = [NSMutableString stringWithString:aString];
 [s replaceOccurrencesOfString:@"\\\\" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
 return [NSString stringWithString:s];
}

- (NSMutableString *)addPostValue:(NSString *)values andKey:(NSString *)key inString:(NSMutableString *)string{
    
    
    [string appendFormat:@",\"%@\":\"%@\"",key,values];
    
    
    
    return string;
}

- (void)saveErrorLog:(errorModel *)model{
    
    
    NSDictionary *data = [model modelChangeDictionary];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *logPath = [documentsPath stringByAppendingPathComponent:@"errorLog.plist"];
    
    NSMutableArray *errorLogDic = [[NSMutableArray alloc]initWithCapacity:0];
    
    NSDictionary *dic = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:logPath]) {
        dic = [NSDictionary dictionaryWithContentsOfFile:logPath];
        [[NSFileManager defaultManager] removeItemAtPath:logPath error:nil];
    }
    else {
        [dic setValue:errorLogDic forKey:@"data"];
    }
    [data setValue:@"0" forKey:@"state"];
    errorLogDic = [dic objectForKey:@"data"];
    [errorLogDic addObject:data];
    [dic setValue:errorLogDic forKey:@"data"];
    [dic writeToFile:logPath atomically:YES];
    
  
}

- (void)sendLocationMessage{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *logPath = [documentsPath stringByAppendingPathComponent:@"errorLog.plist"];
    
    NSDictionary *errorDic = [NSDictionary dictionaryWithContentsOfFile:logPath];
    NSArray *array = [errorDic objectForKey:@"data"];
    
    for (NSDictionary *dic in array) {
        errorModel *model = [self dictionaryChangeModel:dic];
        if ([self sendErrorlog:model]) {
            [dic setValue:@"1" forKey:@"state"];
        }
    }
    NSMutableArray *nosendModel = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in array) {
        if ([[dic objectForKey:@"state"] isEqualToString:@"1"]) {
            [nosendModel addObject:dic];
        }
    }
    
    [errorDic setValue:nosendModel forKey:@"state"];
    [errorDic writeToFile:logPath atomically:YES];
    
}
- (errorModel *)dictionaryChangeModel:(NSDictionary *)dic{
    
    errorModel *model = [[errorModel alloc]init];
    model.level = [dic objectForKey:@"Level"];
    model.errorCode = [dic objectForKey:@"ErrorCode"];
    model.describe = [dic objectForKey:@"ErrorDesc"];
    model.ExceptionInfo = [dic objectForKey:@"Exception"];
    model.environment = [dic objectForKey:@"DeviceInfo"];
    model.time = [dic objectForKey:@"Time"];
    
    
    return model;
}

@end

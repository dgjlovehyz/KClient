//
//  errorModel.h
//  KClient
//
//  Created by LanHai on 16/1/18.
//
//

#import <Foundation/Foundation.h>

@interface errorModel : NSObject

@property (nonatomic, strong) NSNumber *level;                  //等级
@property (nonatomic, strong) NSNumber *errorCode;              //错误码
@property (nonatomic, strong) NSString *describe;                 //描述
@property (nonatomic, strong) NSString *ExceptionInfo;            //异常信息
@property (nonatomic, strong) NSDictionary *environment;              //运行环境
@property (nonatomic, strong) NSString *time;                     //错误时间

+ (errorModel *)createErrorModel:(NSNumber *)level andErrorCode:(NSNumber *)errorCode andDescribe:(NSString *)describe andExceptionInfo:(NSString *)ExceptionInfo;

- (NSDictionary *)modelChangeDictionary;

@end

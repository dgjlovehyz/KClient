//
//  ErrorLogManagement.h
//  KClient
//
//  Created by LanHai on 16/1/15.
//
//

#import <Foundation/Foundation.h>
#import "errorModel.h"

@interface ErrorLogManagement : NSObject


+ (ErrorLogManagement *)errorlog;

- (BOOL)recordLog:(errorModel *)errorModels;
- (BOOL)sendErrorlog:(errorModel *)model;
- (void)sendLocationMessage;
- (void)saveErrorLog:(errorModel *)model;
@end

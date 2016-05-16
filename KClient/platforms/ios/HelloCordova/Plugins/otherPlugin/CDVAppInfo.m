//
//  CDVAppInfo.m
//  KClient
//
//  Created by ZGL on 15/11/9.
//
//

#import "CDVAppInfo.h"

@implementation CDVAppInfo

- (void)cfgInfo:(CDVInvokedUrlCommand *)command
{
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistInfoPath = [[NSBundle mainBundle] pathForResource:@"appInfo" ofType:@"plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistInfoPath]) {
        NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:plistInfoPath];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:infoDic];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
}

@end

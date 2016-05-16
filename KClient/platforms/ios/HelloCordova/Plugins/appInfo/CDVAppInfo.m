/********* CDVAppInfo.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

@interface CDVAppInfo : CDVPlugin {
  // Member variables go here.
}

- (void)coolMethod:(CDVInvokedUrlCommand*)command;
@end

@implementation CDVAppInfo

- (void)coolMethod:(CDVInvokedUrlCommand*)command
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistInfoPath = [[NSBundle mainBundle] pathForResource:@"appInfo" ofType:@"plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistInfoPath]) {
        NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:plistInfoPath];
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:infoDic];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }
}

@end

//
//  UpatePlugin.h
//  KClient
//
//  Created by ZGL on 15/11/9.
//
//


#import <Cordova/CDVPlugin.h>



@interface UpatePlugin : CDVPlugin
@property (nonatomic, copy) NSString *documentPath;

- (void)update:(CDVInvokedUrlCommand *)command;

@end

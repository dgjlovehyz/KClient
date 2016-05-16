//
//  imageCacheJSInteraction.m
//  HelloCordova
//
//  Created by LanHai on 16/4/25.
//
//

#import "imageCacheJSInteraction.h"
#import "WKWebViewJavascriptBridge.h"

@interface imageCacheJSInteraction ()

@property (nonatomic , strong) WKWebViewJavascriptBridge *bridge;

@end

@implementation imageCacheJSInteraction
@synthesize bridge;
- (void)startCacheImage:(id)webview{
    WKWebView *wkWeb = (WKWebView *)webview;
    bridge = [WKWebViewJavascriptBridge bridgeForWebView:wkWeb];
    
    [bridge registerHandler:@"getScreenHeight" handler:^(id data, WVJBResponseCallback responseCallback) {
        responseCallback([NSNumber numberWithInt:[UIScreen mainScreen].bounds.size.height]);
    }];
    
    
}

@end

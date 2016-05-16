//
//  FilteredWebCache.h
//  CordovaLib
//
//  Created by LanHai on 20/04/16.
//
//

#import <Foundation/Foundation.h>
#import <Foundation/NSURLCache.h>
#import "ASIHTTPRequestDelegate.h"

@interface FilteredWebCache : NSURLCache <ASIHTTPRequestDelegate> {
    int found;
    int missed;
    
}
-(BOOL) shouldBlockFileCache:(NSURLRequest*) request;
-(NSString*) cacheFilePath:(NSURLRequest*) request;
-(NSCachedURLResponse*) loadCacheFromFile:(NSURLRequest*) request;

@end

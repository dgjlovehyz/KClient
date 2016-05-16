//
//  FilteredWebCache.m
//  CordovaLib
//
//  Created by LanHai on 20/04/16.
//
//

#import "FilteredWebCache.h"
#import "ASIHTTPRequest.h"
#import <Foundation/NSURLRequest.h>
@implementation FilteredWebCache
//- (NSCachedURLResponse*)cachedResponseForRequest:(NSURLRequest *)request {
//  NSLog( @"req cache for %@", [[request URL] description] );
//  NSLog( @"main dom url %@", [[request mainDocumentURL] description]);
//  NSCachedURLResponse* rep = [super cachedResponseForRequest: request];
//  return rep;
//}
//
//- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request {
//  NSLog( @"store cache for %@", [[request URL] description] );
//  [super storeCachedResponse:cachedResponse forRequest:request];
//}
#pragma mark NSURLCache
- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString *)path {
    self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path];
    found = 0;
    missed = 0;
    return self;
}
-(NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    //  NSLog( @"request cache for %@", [[request URL] description] );
    NSCachedURLResponse* cacheResponse  = [super cachedResponseForRequest: request];
    if( nil != cacheResponse ) {
        found++;
        // NSLog(@"got cache from NSURLCache");
        // NSLog(@"found %d missed %d", found, missed);
        return cacheResponse;
    }
    
    if( [self shouldBlockFileCache:request] ) {
        // NSLog(@"block from file cache");
        missed++;
        // NSLog(@"found %d missed %d", found, missed);
        return nil;
    }
    
    cacheResponse = [self loadCacheFromFile:request];
    if( nil == cacheResponse ) {
        missed++;
    } else {
        found++;
    }
    // NSLog(@"found %d missed %d", found, missed);
    
    return cacheResponse;
    
}
#pragma mark -
#pragma mark disk cache afx

-(NSString*) cacheFilePath:(NSURLRequest*) request {
    
    // parse url
    NSURL* url = request.URL;
    
    // the top path is host name
    NSString* host = url.host;
    // create hash code according to the reletive path
    NSString* relUrl = url.relativePath;
    NSUInteger hash = [relUrl hash];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSLog(@"PATH S%@", paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* storagePath = [NSString stringWithFormat:@"%@/cache/%@/%08x", documentsDirectory, host, hash];
    NSLog(@"%@",storagePath);
    // storagePath is auto release
    return storagePath;
}
-(NSCachedURLResponse*) loadCacheFromFile:(NSURLRequest*) request {
    
    NSCachedURLResponse* cacheResponse = nil;
    
    NSString* storagePath = [self cacheFilePath:request];
    if( nil == storagePath ) {
        return cacheResponse;
    }
    
    NSString* dataPath = [storagePath stringByAppendingString:@"/data"];
    NSString* mimePath = [storagePath stringByAppendingString:@"/mime"];
    NSString* encodingPath = [storagePath stringByAppendingFormat:@"/encoding"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        NSLog(@"CACHE FOUND for %@", request.URL.relativePath);
        
        NSData* content = [NSData dataWithContentsOfFile:dataPath];
        NSData* mimeData = [NSData dataWithContentsOfFile:mimePath];
        NSData* encodingData = [NSData dataWithContentsOfFile:encodingPath];
        
        NSString* mime = nil;
        if( nil != mimeData ) {
            mime = [[NSString alloc] initWithData:mimeData encoding:NSUTF8StringEncoding];
        } else {
            mime = @"";
        }
        NSString* encoding = nil;
        if( nil != encodingData ) {
            encoding = [[NSString alloc] initWithData:encodingData encoding:NSUTF8StringEncoding];
        }
        
        NSURLResponse* response = [[NSURLResponse alloc] initWithURL:request.URL MIMEType:mime expectedContentLength:[content length] textEncodingName:encoding];
        
        cacheResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:content];
    } else {
        //trick here : if no cache, populate it asynchronously and return nil
        NSLog(@"download CACHE for %@", request.URL.relativePath);
        // [NSThread detachNewThreadSelector:@selector(populateCacheFor:) toTarget:self withObject:request];
        NSURL *url = request.URL;
        ASIHTTPRequest *asirequest = [ASIHTTPRequest requestWithURL:url];
        asirequest.argObj = request;
        [asirequest setDelegate:self];
        [asirequest startAsynchronous];
    }
    
    return cacheResponse;
}
-(BOOL) shouldBlockFileCache:(NSURLRequest*) request {
    
    NSURL* url = request.URL;
    
    if( nil == url.host || 0 == url.host.length ) {
        // block the request without host
        return YES;
    }
    if( nil != url.user || nil != url.password ) {
        // block the request with security
        return YES;
    }
    
    // check the file type
    NSString* ressourceName = url.relativePath;
    //we're only caching the following files
    if (
        [ressourceName rangeOfString:@".png"].location!=NSNotFound ||
        [ressourceName rangeOfString:@".jp"].location!=NSNotFound ||
        [ressourceName rangeOfString:@".gif"].location!=NSNotFound ||
        [ressourceName rangeOfString:@".tif"].location!=NSNotFound ||
        [ressourceName rangeOfString:@".js"].location!=NSNotFound ||
        [ressourceName rangeOfString:@".css"].location!=NSNotFound ||
        [ressourceName rangeOfString:@".cgz"].location!=NSNotFound ||
        [ressourceName rangeOfString:@".jgz"].location!=NSNotFound) {
        return NO;
    }
    
    return YES;
}
#pragma mark -
#pragma mark ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    NSString* storagePath = [self cacheFilePath: request.argObj];
    
    NSData* content = [request responseData];
    NSString* contentType = [[request responseHeaders] objectForKey:@"Content-Type"];
    NSString* mime = nil;
    NSString* encoding = nil;
    // split contentType
    NSRange sepRange = [contentType rangeOfString:@"; "];
    if( sepRange.location != NSNotFound ) {
        // sep the content type
        mime = [contentType substringToIndex: sepRange.location];
        // get text encoding
        encoding = [contentType substringFromIndex: (sepRange.location + sepRange.length)];
    } else {
        mime = contentType;
    }
    
    NSError* error = nil;
    //the store is invoked automatically.
    [[NSFileManager defaultManager] createDirectoryAtPath:storagePath withIntermediateDirectories:YES attributes:nil error:&error];
    BOOL ok;// = [[NSFileManager defaultManager] createDirectoryAtPath:absolutePath withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSString* dataPath = [storagePath stringByAppendingString:@"/data"];
    ok = [content writeToFile:dataPath atomically:YES];
    //  NSLog(@"Caching %@ : %@", dataPath , ok?@"OK":@"KO");
    if( ok ) {
        //save mime and encoding
        if( nil != mime ) {
            error = nil;
            NSString* mimePath = [storagePath stringByAppendingString:@"/mime"];
            [mime writeToFile:mimePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        }
        if( nil != encoding ) {
            error = nil;
            NSString* encodingPath = [storagePath stringByAppendingFormat:@"/encoding"];
            [encoding writeToFile:encodingPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        }
    }
}
#pragma mark -

@end
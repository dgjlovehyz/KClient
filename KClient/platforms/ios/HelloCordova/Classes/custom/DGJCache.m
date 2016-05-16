//
//  DGJCache.m
//  HelloCordova
//
//  Created by LanHai on 16/4/20.
//
//

#import "DGJCache.h"

@interface DGJCache ()

@property (nonatomic, strong) NSMutableDictionary *cachedResponses;

@end

@implementation DGJCache
@synthesize cachedResponses;

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request{
    
    
    // Get the path for the request
    NSString *pathString = [[request URL] absoluteString];
    
    // 判断我们是否为这个路径提供了替代资源
    NSString *substitutionFileName = [[self substitutionPaths] objectForKey:pathString];
    NSLog(@"%@",pathString);
    NSString *name = [pathString lastPathComponent];
    BOOL isNeedCached = [self isPicture:name];
    if (!isNeedCached)
    {
        // 没有替代资源，返回默认值
        return [super cachedResponseForRequest:request];
    }
    
    // 如果我们已经创建了一个缓存实例，那么返回它
    NSCachedURLResponse *cachedResponse = [cachedResponses objectForKey:pathString];
    if (cachedResponse)
    {
        return cachedResponse;
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    path = [path stringByAppendingPathComponent:@"imageCached"];
    // 获得替代文件的路径
    NSString *substitutionFilePath = [NSString stringWithFormat:@"%@/%@",path, name];
//    [[NSBundle mainBundle]
//     pathForResource:[substitutionFileName stringByDeletingPathExtension]
//     ofType:[substitutionFileName pathExtension]];
    NSAssert(substitutionFilePath,
             @"File %@ in substitutionPaths didn't exist", substitutionFileName);
    if ([self picturewith:pathString andSavePath:path]) {
        return [super cachedResponseForRequest:request];
    }
    
    // 加载替代数据
    NSData *data = [NSData dataWithContentsOfFile:substitutionFilePath];
    
    // 创建可缓存的响应
    NSURLResponse *response =
    [[NSURLResponse alloc]
      initWithURL:[request URL]
      MIMEType:[self mimeTypeForPath:pathString]
      expectedContentLength:[data length]
      textEncodingName:nil]
     ;
    cachedResponse =
    [[NSCachedURLResponse alloc] initWithResponse:response data:data];
    
    // 为后续响应，把它加入我们的响应词典中
    if (!cachedResponses)
    {
        cachedResponses = [[NSMutableDictionary alloc] init];
    }
    [cachedResponses setObject:cachedResponse forKey:pathString];
    
    return cachedResponse;
    
    
}

- (BOOL)isPicture:(NSString *)name{
    
    if ([name hasSuffix:@"png"] || [name hasSuffix:@"jpg"]) {
        return YES;
    }
    
    return NO;
    
}

//判断图片是否存在，如果不存在那么保存，如果存在返回yes

- (BOOL)savePicture:(NSString *)url withPath:(NSString *)path{
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    return [manager createFileAtPath:path contents:data attributes:nil];
  
}

- (BOOL)picturewith:(NSString *)url andSavePath:(NSString *)path{
    
    if (![self hasPictureiBy:path]) {
        [self savePicture:url withPath:path];
        return YES;
    }
    else {
        return NO;
    }
    
    
}

- (BOOL)hasPictureiBy:(NSString *)path{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    return [manager fileExistsAtPath:path];
    
}


- (NSString *)mimeTypeForPath:(NSString *)pathString{
    
    
    
    
    return nil;
}



- (NSDictionary *)substitutionPaths
{
    return
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"fakeGlobalNavBG.png",
     @"http://images.apple.com/global/nav/images/globalnavbg.png",
     nil];
}

@end

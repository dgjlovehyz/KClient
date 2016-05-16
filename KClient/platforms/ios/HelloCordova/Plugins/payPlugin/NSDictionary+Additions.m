//
//  NSDictionary+Additions.m
//  KClient
//
//  Created by LanHai on 15/12/11.
//
//

#import "NSDictionary+Additions.h"
#import "NSStack.h"

@implementation NSDictionary (Additions)

- (NSString*)newXMLString {
    NSMutableString *xmlString = [[NSMutableString alloc] initWithString:@"<xml>"];
    NSStack *stack = [[NSStack alloc] init];
    NSArray  *keys = nil;
    NSString *key  = nil;
    NSObject *value    = nil;
    NSObject *subvalue = nil;
    NSInteger size = 0;
    [stack push:self];
    while (![stack empty]) {
        value = [stack top];
        [stack pop];
        if (value) {
            if ([value isKindOfClass:[NSString class]]) {
                [xmlString appendFormat:@"</%@>", value];
            }
            else if([value isKindOfClass:[NSDictionary class]])
            {
                keys = [(NSDictionary*)value allKeys];
                size = [(NSDictionary*)value count];
                for (key in keys) {
                    subvalue = [(NSDictionary*)value objectForKey:key];
                    if ([subvalue isKindOfClass:[NSDictionary class]]) {
                        [xmlString appendFormat:@"<%@>", key];
                        [stack push:key];
                        [stack push:subvalue];
                    }
                    else if([subvalue isKindOfClass:[NSString class]])
                    {
                        [xmlString appendFormat:@"<%@>%@</%@>", key, subvalue, key];
                    }
                }
            }
        }
    }
    [xmlString appendString:@"</xml>"];
    return xmlString;
}


- (NSString *)getWXXml{
    
    NSMutableString *xmlString = [[NSMutableString alloc] initWithString:@"<xml>"];
    
    [self generateXml:xmlString withKey:@"appid"];
    [self generateXml:xmlString withKey:@"body"];
    [self generateXml:xmlString withKey:@"mch_id"];
    [self generateXml:xmlString withKey:@"nonce_str"];
    [self generateXml:xmlString withKey:@"notify_url"];
    [self generateXml:xmlString withKey:@"out_trade_no"];
    [self generateXml:xmlString withKey:@"spbill_create_ip"];
    [self generateXml:xmlString withKey:@"total_fee"];
    [self generateXml:xmlString withKey:@"trade_type"];
    [self generateXml:xmlString withKey:@"sign"];
    [xmlString appendString:@"</xml>"];

    return xmlString;
    
}

- (NSString *)generateXml:(NSMutableString *)xmlString withKey:(NSString *)key{
    
    [xmlString appendFormat:@"<%@>%@</%@>",key,[self objectForKey:key],key];
    
    
    return xmlString;
}


@end

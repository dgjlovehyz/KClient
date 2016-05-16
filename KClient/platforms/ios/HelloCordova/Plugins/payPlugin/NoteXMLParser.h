//
//  NoteXMLParser.h
//  KClient
//
//  Created by LanHai on 15/12/14.
//
//

#import <Foundation/Foundation.h>



@interface NoteXMLParser : NSObject <NSXMLParserDelegate>

//解析出得数据，内部是字典类型
@property (strong,nonatomic) NSMutableArray * notes ;

// 当前标签的名字 ,currentTagName 用于存储正在解析的元素名
@property (strong ,nonatomic) NSString * currentTagName ;

//开始解析
- (void)start:(NSData *)xmlData;

@end

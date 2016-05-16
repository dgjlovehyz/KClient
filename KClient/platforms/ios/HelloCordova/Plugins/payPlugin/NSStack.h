//
//  NSStack.h
//  KClient
//
//  Created by LanHai on 15/12/11.
//
//

#import <Foundation/Foundation.h>

@interface NSStack : NSObject
{
    NSMutableArray  *_stackArray;
}
/**
 * @desc judge whether the stack is empty
 *
 * @return TRUE if stack is empty, otherwise FALASE is returned
 */
- (BOOL) empty;
/**
 * @desc get top object in the stack
 *
 * @return nil if no object in the stack, otherwise an object
 * is returned, user should judge the return by this method
 */
- (id) top;
/**
 * @desc pop stack top object
 */
- (void) pop;
/**
 * @desc push an object to the stack
 */
- (void) push:(id)value;
@end

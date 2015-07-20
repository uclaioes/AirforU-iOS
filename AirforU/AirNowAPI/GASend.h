/*!
 * @name        GASend.h
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import <Foundation/Foundation.h>

#import "GAIDictionaryBuilder.h"
#import "GAI.h"

@interface GASend : NSObject

+ (void)sendEventWithAction:(NSString *)action;
+ (void)sendEventWithAction:(NSString *)action withLabel:(NSString *)label;
+ (void)sendEventWithAction:(NSString *)action withLabel:(NSString *)label withValue:(int)value;

@end

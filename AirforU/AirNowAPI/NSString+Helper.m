/*!
 * @name        NSString+Helper.m
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import "NSString+Helper.h"

@implementation NSString (Helper)

- (BOOL)isAllDigits
{
    NSCharacterSet *nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet:nonNumbers];
    return r.location == NSNotFound;
}

@end

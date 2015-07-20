/*!
 * @name        NSDate+AQHelper.h
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import <Foundation/Foundation.h>

@interface NSDate (AQHelper)

- (NSString *)dateID;

// offset ranges from [-6,0]
- (NSString *)weekdayForOffset:(NSInteger)offset;

@end

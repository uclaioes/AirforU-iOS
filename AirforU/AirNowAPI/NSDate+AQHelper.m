/*!
 * @name        NSDate+AQHelper.m
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import "NSDate+AQHelper.h"
#import "AQConstants.h"

@implementation NSDate (AQHelper)

- (NSString *)dateID
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateID = [formatter stringFromDate:self];
    return dateID;
}

- (NSString *)weekdayForOffset:(NSInteger)offset
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"cccc"];
    return [formatter stringFromDate:[self dateByAddingTimeInterval:(SECONDS_PER_DAY*offset)]];
}

@end

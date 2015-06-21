//
//  NSDate+AQHelper.m
//  AirforU
//
//  Created by QINGWEI on 4/27/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

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

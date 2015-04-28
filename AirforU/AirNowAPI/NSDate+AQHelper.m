//
//  NSDate+AQHelper.m
//  AirforU
//
//  Created by QINGWEI on 4/27/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "NSDate+AQHelper.h"

@implementation NSDate (AQHelper)

- (NSString *)dateID
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateID = [formatter stringFromDate:self];
    return dateID;
}

@end

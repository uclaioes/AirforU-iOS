//
//  NSString+Helper.m
//  AirforU
//
//  Created by QINGWEI on 5/4/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

- (BOOL)isAllDigits
{
    NSCharacterSet *nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet:nonNumbers];
    return r.location == NSNotFound;
}

@end

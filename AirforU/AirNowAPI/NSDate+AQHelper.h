//
//  NSDate+AQHelper.h
//  AirforU
//
//  Created by QINGWEI on 4/27/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (AQHelper)

- (NSString *)dateID;

// offset ranges from [-6,0]
- (NSString *)weekdayForOffset:(NSInteger)offset;

@end

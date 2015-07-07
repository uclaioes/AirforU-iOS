//
//  GASend.h
//  AirforU
//
//  Created by Qingwei Lan on 7/6/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GAIDictionaryBuilder.h"
#import "GAI.h"

@interface GASend : NSObject

+ (void)sendEventWithAction:(NSString *)action;
+ (void)sendEventWithAction:(NSString *)action withLabel:(NSString *)label;
+ (void)sendEventWithAction:(NSString *)action withLabel:(NSString *)label withValue:(int)value;

@end

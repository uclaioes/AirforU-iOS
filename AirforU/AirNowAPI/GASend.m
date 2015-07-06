//
//  GASend.m
//  AirforU
//
//  Created by Qingwei Lan on 7/6/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "GASend.h"

@interface GASend ()

@end

@implementation GASend

+ (void)sendEventWithAction:(NSString *)action
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *identification = [defaults objectForKey:@"identification"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    if (identification)
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:action label:timestamp value:nil] build]];
}

+ (void)sendEventWithAction:(NSString *)action withLabel:(NSString *)label
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *identification = [defaults objectForKey:@"identification"];
    
    if (identification)
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:action label:label value:nil] build]];
}

@end

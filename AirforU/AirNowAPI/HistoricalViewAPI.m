//
//  HistoricalViewAPI.m
//  AirforU
//
//  Created by Qingwei Lan on 6/20/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "HistoricalViewAPI.h"

@interface HistoricalViewAPI ()

@end

@implementation HistoricalViewAPI

+ (NSURL *)urlForMonitoringStation:(NSString *)station
{
    NSString *urlString = [NSString stringWithFormat:@"http://engage.environment.ucla.edu/airforu_get_histo.php?location=%@", station];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", urlString);
    return [NSURL URLWithString:urlString];
}

@end

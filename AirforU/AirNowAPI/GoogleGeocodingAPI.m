//
//  GoogleGeocodingAPI.m
//  AirforU
//
//  Created by QINGWEI on 5/31/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "GoogleGeocodingAPI.h"
#import "AQConstants.h"

@implementation GoogleGeocodingAPI

+ (NSURL *)urlForSearch:(NSString *)search
{
    NSURL *url = nil;
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true&key=%@", search, GEOCODING_KEY];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    url = [NSURL URLWithString:urlString];

    return url;
}

+ (NSURL *)urlForLatitude:(CLLocationDegrees)latitude withLongitude:(CLLocationDegrees)longitude
{
    NSURL *url = nil;
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&key=%@", latitude, longitude, GEOCODING_KEY];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    url = [NSURL URLWithString:urlString];
    
    return url;
}

@end

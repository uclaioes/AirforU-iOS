//
//  AirQualityFetchAPI.h
//  AirforU
//
//  Created by QINGWEI on 6/2/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AirQualityFetchAPI : NSObject

+ (NSArray *)getAirQualityForContent:(NSString *)content
                         forLatitude:(CLLocationDegrees)latitude
                        forLongitude:(CLLocationDegrees)longitude;

+ (NSArray *)getAirQualityForContent:(NSString *)content
                          forZipcode:(NSString *)zipcode;

+ (NSArray *)getAirQualityForContent:(NSString *)content
                           forSearch:(NSString *)search;

@end

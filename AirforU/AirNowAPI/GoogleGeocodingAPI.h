//
//  GoogleGeocodingAPI.h
//  AirforU
//
//  Created by QINGWEI on 5/31/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GoogleGeocodingAPI : NSObject

+ (NSURL *)urlForSearch:(NSString *)search;

+ (NSURL *)urlForLatitude:(CLLocationDegrees)latitude withLongitude:(CLLocationDegrees)longitude;

@end

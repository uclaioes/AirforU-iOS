//
//  AirNow API.h
//  Air Quality
//
//  Created by QINGWEI on 1/20/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AirNowAPI : NSObject

+ (NSURL *)URLForLatitute:(CLLocationDegrees)latitude
             forLongitude:(CLLocationDegrees)longitude;

+ (NSURL *)URLForDate:(NSDate *)date
          forLatitute:(CLLocationDegrees)latitude
         forLongitude:(CLLocationDegrees)longitude;

+ (NSURL *)URLForZipcode:(NSString *)zipcode;

+ (NSURL *)URLForDate:(NSDate *)date
           forZipcode:(NSString *)zipcode;



@end

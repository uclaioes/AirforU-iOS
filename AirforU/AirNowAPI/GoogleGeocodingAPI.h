//
//  GoogleGeocodingAPI.h
//  AirforU
//
//  Created by QINGWEI on 5/31/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleGeocodingAPI : NSObject

+ (NSURL *)urlForSearch:(NSString *)search;

+ (NSURL *)urlForLatitude:(NSString *)latitude withLongitude:(NSString *)longitude;

@end

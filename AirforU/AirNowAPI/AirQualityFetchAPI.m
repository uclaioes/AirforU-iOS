//
//  AirQualityFetchAPI.m
//  AirforU
//
//  Created by QINGWEI on 6/2/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "AirQualityFetchAPI.h"
#import "GoogleGeocodingAPI.h"
#import "AQConstants.h"
#import "AirNowAPI.h"
#import "AQUtilities.h"

@interface AirQualityFetchAPI ()

@end

@implementation AirQualityFetchAPI

+ (NSArray *)getLocationPropertiesForURL:(NSURL *)url
{
    NSString *location = @"Not Available";
    NSString *latitude = @"";
    NSString *longitude = @"";
    
    NSData *locData = [NSData dataWithContentsOfURL:url];
    if (locData) {
        NSDictionary *locDict = [NSJSONSerialization JSONObjectWithData:locData options:0 error:NULL];
        if (locDict) {
            NSArray *components = [[locDict valueForKeyPath:GEOCODING_RESUTLS_ADDRESS_COMPONENTS] firstObject];
            NSString *locality = @"";
            NSString *state = @"";
            NSString *lat;
            NSString *lng;
            for (NSDictionary *component in components) {
                if ([[component valueForKey:@"types"] containsObject:@"locality"]) {
                    locality = [component valueForKey:@"long_name"];
                }
                else if ([[component valueForKey:@"types"] containsObject:@"administrative_area_level_1"])
                    state = [component valueForKey:@"short_name"];
            }
            if (![locality isEqualToString:@""] &&
                ![state isEqualToString:@""])
                location = [NSString stringWithFormat:@"%@, %@", locality, state];
            lat = [[locDict valueForKeyPath:GEOCODING_RESULTS_LAT] firstObject];
            lng = [[locDict valueForKeyPath:GEOCODING_RESULTS_LNG] firstObject];
            if (lat && lng) {
                latitude = lat;
                longitude = lng;
            }
        }
    }
    
    return @[location, latitude, longitude];
}

+ (NSArray *)getAirQualityPropertiesForURL:(NSURL *)url
{
    NSString *aqi = @"N/A";
    NSString *description = @"";
    NSString *station = @"";
    
    NSData *aqiData = [NSData dataWithContentsOfURL:url];
    if (aqiData) {
        NSDictionary *aqiDict = [NSJSONSerialization JSONObjectWithData:aqiData options:0 error:NULL];
        if (aqiDict) {
            NSNumber *max = [[aqiDict valueForKeyPath:AIR_NOW_RESULTS_AQI] valueForKeyPath:@"@max.intValue"];
            if ([aqiDict count] == 0)
                max = [NSNumber numberWithInt:-1];
            if (max.integerValue != -1)
                aqi = [NSString stringWithFormat:@"%@", max];
            
            // get monitoring station
            if ([aqiDict count] != 0)
                station = [[aqiDict valueForKeyPath:AIR_NOW_RESULTS_AREA] firstObject];
        }
    }
    
    if (![aqi isEqualToString:@"N/A"])
        description = [AQUtilities aqQualityTitleForAQ:[AQUtilities aqForAQI:aqi]];
    
    return @[aqi, description, station];
}

+ (NSArray *)getAirQualityForContent:(NSString *)content
                         forLatitude:(CLLocationDegrees)latitude
                        forLongitude:(CLLocationDegrees)longitude
{
    /* Set the properties to be returned */
    NSString *location = @"Not Available";
    NSString *aqi = @"N/A";
    NSString *description = @"";
    NSString *station = @"";
    
    /* fetch the location */
    NSURL *locURL = [GoogleGeocodingAPI urlForLatitude:latitude withLongitude:longitude];
    NSArray *locationData = [self getLocationPropertiesForURL:locURL];
    location = locationData[0];
    
    /* fetch the aqi */
    NSURL *aqiURL;
    if ([content isEqualToString:AIR_NOW_TODAY])
        aqiURL = [AirNowAPI URLForLatitute:latitude forLongitude:longitude];
    else if ([content isEqualToString:AIR_NOW_TOMORROW_FORECAST])
        aqiURL = [AirNowAPI URLForDate:[[NSDate date] dateByAddingTimeInterval:SECONDS_PER_DAY] forLatitute:latitude forLongitude:longitude];
    
    NSArray *aqiData = [self getAirQualityPropertiesForURL:aqiURL];
    aqi = aqiData[0];
    description = aqiData[1];
    station = aqiData[2];
    
    return @[location, aqi, description, station];
}

+ (NSArray *)getAirQualityForContent:(NSString *)content
                          forZipcode:(NSString *)zipcode
{
    /* Set the properties to be returned */
    NSString *location = @"Not Available";
    NSString *aqi = @"N/A";
    NSString *description = @"";
    NSString *station = @"";

    /* fetch the location */
    NSURL *locURL = [GoogleGeocodingAPI urlForZipcodeSearch:zipcode];
    NSArray *locationData = [self getLocationPropertiesForURL:locURL];
    location = locationData[0];
    
    /* fetch the aqi */
    NSURL *aqiURL;
    if ([content isEqualToString:AIR_NOW_TODAY])
        aqiURL = [AirNowAPI URLForZipcode:zipcode];
    else if ([content isEqualToString:AIR_NOW_TOMORROW_FORECAST])
        aqiURL = [AirNowAPI URLForDate:[[NSDate date] dateByAddingTimeInterval:SECONDS_PER_DAY] forZipcode:zipcode];
    
    NSArray *aqiData = [self getAirQualityPropertiesForURL:aqiURL];
    aqi = aqiData[0];
    description = aqiData[1];
    station = aqiData[2];

    return @[location, aqi, description, station];
}

+ (NSArray *)getAirQualityForContent:(NSString *)content
                           forSearch:(NSString *)search
{
    /* Set the properties to be returned */
    NSString *location = @"Not Available";
    NSString *aqi = @"N/A";
    NSString *description = @"";
    NSString *station = @"";

    /* fetch the location */
    NSURL *locURL = [GoogleGeocodingAPI urlForCitySearch:search];
    NSArray *locationData = [self getLocationPropertiesForURL:locURL];
    location = locationData[0];
    NSString *latitude = [NSString stringWithFormat:@"%@", locationData[1]];
    NSString *longitude = [NSString stringWithFormat:@"%@", locationData[2]];
    NSLog(@"%@, %@", latitude, longitude);
    /* fetch the aqi */
    NSURL *aqiURL;
    if (![latitude isEqualToString:@""] && ![longitude isEqualToString:@""]) {
        if ([content isEqualToString:AIR_NOW_TODAY])
            aqiURL = [AirNowAPI URLForLatitute:latitude.doubleValue forLongitude:longitude.doubleValue];
        else if ([content isEqualToString:AIR_NOW_TOMORROW_FORECAST])
            aqiURL = [AirNowAPI URLForDate:[[NSDate date] dateByAddingTimeInterval:SECONDS_PER_DAY] forLatitute:latitude.doubleValue forLongitude:longitude.doubleValue];
        
        NSArray *aqiData = [self getAirQualityPropertiesForURL:aqiURL];
        aqi = aqiData[0];
        description = aqiData[1];
        station = aqiData[2];
    }
    
    return @[location, aqi, description, station];
}

@end

/*!
 * @name        AirQualityFetchAPI.h
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

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

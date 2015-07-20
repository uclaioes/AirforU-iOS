/*!
 * @name        GoogleGeocoding.h
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GoogleGeocodingAPI : NSObject

+ (NSURL *)urlForCitySearch:(NSString *)city;

+ (NSURL *)urlForZipcodeSearch:(NSString *)zipcode;

+ (NSURL *)urlForLatitude:(CLLocationDegrees)latitude withLongitude:(CLLocationDegrees)longitude;

@end

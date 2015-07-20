/*!
 * @name        AirNowAPI.h
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

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

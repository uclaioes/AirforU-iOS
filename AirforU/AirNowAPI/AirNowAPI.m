/*!
 * @name        AirNowAPI.m
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import "AirNowAPI.h"
#import "AQConstants.h"

@implementation AirNowAPI

+ (NSURL *)URLForLatitute:(CLLocationDegrees)latitude
             forLongitude:(CLLocationDegrees)longitude
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.airnowapi.org/aq/observation/latLong/current/?format=application/json&latitude=%f&longitude=%f&distance=25&API_KEY=%@", latitude, longitude, AIR_NOW_API_KEY];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)URLForDate:(NSDate *)date
          forLatitute:(CLLocationDegrees)latitude
         forLongitude:(CLLocationDegrees)longitude
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.airnowapi.org/aq/forecast/latlong/?format=application/json&latitude=%f&longitude=%f&date=%@&distance=25&api_key=%@", latitude, longitude, dateString, AIR_NOW_API_KEY];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)URLForZipcode:(NSString *)zipcode
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.airnowapi.org/aq/observation/zipCode/current/?format=application/json&zipCode=%@&distance=25&API_KEY=%@", zipcode, AIR_NOW_API_KEY];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)URLForDate:(NSDate *)date
           forZipcode:(NSString *)zipcode
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.airnowapi.org/aq/forecast/zipCode/?format=application/json&zipCode=%@&date=%@&distance=25&API_KEY=%@", zipcode, dateString, AIR_NOW_API_KEY];
    
    return [NSURL URLWithString:urlString];
}





@end

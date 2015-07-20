/*!
 * @name        GoogleGeocoding.m
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import "GoogleGeocodingAPI.h"
#import "AQConstants.h"

@implementation GoogleGeocodingAPI

+ (NSURL *)urlForCitySearch:(NSString *)city
{
    NSURL *url = nil;
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&result_type=locality&components=country:US&sensor=true&key=%@", city, GEOCODING_KEY];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url = [NSURL URLWithString:urlString];

    return url;
}

+ (NSURL *)urlForZipcodeSearch:(NSString *)zipcode
{
    NSURL *url = nil;
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?components=postal_code:%@country:US&sensor=true&key=%@", zipcode, GEOCODING_KEY];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url = [NSURL URLWithString:urlString];

    return url;
}

+ (NSURL *)urlForLatitude:(CLLocationDegrees)latitude withLongitude:(CLLocationDegrees)longitude
{
    NSURL *url = nil;
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&result_type=locality&sensor=true&key=%@", latitude, longitude, GEOCODING_KEY];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url = [NSURL URLWithString:urlString];
    
    return url;
}

@end

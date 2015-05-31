//
//  AirNow API.m
//  Air Quality
//
//  Created by QINGWEI on 1/20/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "AirNowAPI.h"
#import "AirNowAPIKey.h"
#import "UIColor+Helper.h"

@implementation AirNowAPI

+ (NSURL *)URLForLatitute:(CLLocationDegrees)latitude
             forLongitude:(CLLocationDegrees)longitude
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.airnowapi.org/aq/observation/latLong/current/?format=application/json&latitude=%f&longitude=%f&distance=25&API_KEY=%@", latitude, longitude, AirNowAPIKey];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)URLForDate:(NSDate *)date
          forLatitute:(CLLocationDegrees)latitude
         forLongitude:(CLLocationDegrees)longitude
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.airnowapi.org/aq/forecast/latlong/?format=application/json&latitude=%f&longitude=%f&date=%@&distance=25&api_key=%@", latitude, longitude, dateString, AirNowAPIKey];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)URLForZipcode:(NSString *)zipcode
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.airnowapi.org/aq/observation/zipCode/current/?format=application/json&zipCode=%@&distance=25&API_KEY=%@", zipcode, AirNowAPIKey];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL *)URLForDate:(NSDate *)date
           forZipcode:(NSString *)zipcode
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    
    NSString *urlString = [NSString stringWithFormat:@"http://www.airnowapi.org/aq/forecast/zipCode/?format=application/json&zipCode=%@&date=%@&distance=25&API_KEY=%@", zipcode, dateString, AirNowAPIKey];
    
    return [NSURL URLWithString:urlString];
}



//+ (NSDictionary *)airQualityInfoForDate:(NSDate *)date
//                           content:(NSString *)content
//                          latitude:(NSString *)latitude
//                         longitude:(NSString *)longitude
//{
//    NSURL *url;
//    
//    if ([content isEqualToString:AIR_NOW_TODAY]) {
//        url = [self URLForLatitute:latitude forLongitude:longitude];
//    } else if ([content isEqualToString:AIR_NOW_TOMORROW_FORECAST]) {
//        url = [self URLForDate:[date dateByAddingTimeInterval:SECONDS_DAY] forLatitute:latitude forLongitude:longitude];
//    }
//    
//    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
//    NSDictionary *propertyListResults;
//    NSError *error;
//    
//    
//    if (jsonResults) {
//        propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:&error];
//        NSLog(@"%@", propertyListResults);
//
//        if (propertyListResults)
//            return [self airQualityInfoForJSONResults:propertyListResults];
//    }
//    
//    return nil;
//}
//
//+ (NSDictionary *)airQualityInfoForDate:(NSDate *)date
//                           content:(NSString *)content
//                           zipcode:(NSString *)zipcode
//{
//    NSURL *url;
//    
//    if ([content isEqualToString:AIR_NOW_TODAY]) {
//        url = [self URLForZipcode:zipcode];
//    } else if ([content isEqualToString:AIR_NOW_TOMORROW_FORECAST]) {
//        url = [self URLForDate:[date dateByAddingTimeInterval:SECONDS_DAY] forZipcode:zipcode];
//    }
//    
//    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
//    NSDictionary *propertyListResults;
//    NSError *error;
//    
//    if (jsonResults) {
//        propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:&error];
//        if (propertyListResults)
//            return [self airQualityInfoForJSONResults:propertyListResults];
//    }
//    
//    return nil;
//}
//
//+ (NSDictionary *)airQualityInfoForJSONResults:(NSDictionary *)results
//{
//    NSString *aqi = @"";
//    NSString *location = @"";
//    NSString *description = @"";
//    
//    if (results) {
//        
//        /* Parse Category */
//        
//        BOOL categoryExists = false;
//        NSArray *category = [results valueForKeyPath:AIR_NOW_RESULTS_CATEGORY_NAME];
//        NSString *categoryName = @"Unavailable";
//        if (category && [category count] > 0) {
//            categoryName = [self worstAQ:category];
//            categoryExists = true;
//        }
//        
//        /* Parse Location */
//        
//        NSArray *stateArray = [results valueForKeyPath:AIR_NOW_RESULTS_STATE_CODE];
//        NSArray *locationArray = [results valueForKeyPath:AIR_NOW_RESULTS_AREA];
//        NSString *state, *loc;
//        if (stateArray && locationArray && [stateArray count] != 0 && [locationArray count] != 0) {
//            state = [stateArray firstObject];
//            loc = [locationArray firstObject];
//        }
//        
//        /* Parse AQI */
//
//        NSArray *aqi = [results valueForKeyPath:AIR_NOW_RESULTS_AQI];
//        NSNumber *max = [aqi valueForKeyPath:@"@max.intValue"];
//        if ([max isEqualToNumber:[NSNumber numberWithInt:-1]] || [results count] == 0)
//            max = [NSNumber numberWithInt:-1];
//    }
//    
//    return @{ DOWNLOADED_AQI : aqi,
//              DOWNLOADED_LOCATION : location,
//              DOWNLOADED_DESCRIPTION : description };
//}




+ (AQAirQuality)aqForAQI:(NSString *)aqi
{
    int aqiValue = [aqi intValue];
    
    if (aqiValue >= 0 && aqiValue <= 50)
        return AQGood;
    else if (aqiValue >= 51 && aqiValue <= 100)
        return AQModerate;
    else if (aqiValue >= 101 && aqiValue <= 150)
        return AQUnhealthyForSensitive;
    else if (aqiValue >= 151 && aqiValue <= 200)
        return AQUnhealthy;
    else if (aqiValue >= 201 && aqiValue <= 300)
        return AQVeryUnhealthy;
    else if (aqiValue >= 301)
        return AQHazardous;
    
    return AQUnavailable;
}

+ (UIColor *)aqColorForAQ:(AQAirQuality)aq
{
    switch (aq)
    {
        case AQGood: return [UIColor aqGreenColor]; break;
        case AQModerate: return [UIColor aqYellowColor]; break;
        case AQUnhealthyForSensitive: return [UIColor aqOrangeColor]; break;
        case AQUnhealthy: return [UIColor aqRedColor]; break;
        case AQVeryUnhealthy: return [UIColor aqPurpleColor]; break;
        case AQHazardous: return [UIColor aqMaroonColor]; break;
        case AQUnavailable: return [UIColor whiteColor]; break;
            
        default: break;
    }
    
    return [UIColor clearColor];
}

+ (UIColor *)aqTextColorForAQ:(AQAirQuality)aq
{
    if (aq == AQGood || aq == AQModerate)
        return [UIColor blackColor];
    return [UIColor whiteColor];
}

+ (NSString *)aqImageNameForAQ:(AQAirQuality)aq
{
    NSString *imageName = @"good_background.png";
    
    switch (aq)
    {
        case AQGood: imageName = @"good_background.png"; break;
        case AQModerate: imageName = @"moderate_background.png"; break;
        case AQUnhealthyForSensitive: imageName = @"sensitive_backgroung.png"; break;
        case AQUnhealthy: imageName = @"unhealthy_background.png"; break;
        case AQVeryUnhealthy: imageName = @"very_unhealthy_background.png"; break;
        case AQHazardous: imageName = @"hazardous_background.png"; break;
        case AQUnavailable: break;
        
        default: break;
    }
    
    return imageName;
}

+ (NSString *)aqQualityTitleForAQ:(AQAirQuality)aq
{
    NSString *airQuality = @"";
    
    switch (aq)
    {
        case AQGood: airQuality = @"Good"; break;
        case AQModerate: airQuality = @"Moderate"; break;
        case AQUnhealthyForSensitive: airQuality = @"Unhealthy for Sensitive Groups"; break;
        case AQUnhealthy: airQuality = @"Unhealthy"; break;
        case AQVeryUnhealthy: airQuality = @"Very Unhealthy"; break;
        case AQHazardous: airQuality = @"Hazardous"; break;
        case AQUnavailable: airQuality = @""; break;
            
        default: break;
    }
    
    return airQuality;
}

+ (NSString *)aqRangeForAQ:(AQAirQuality)aq
{
    switch (aq)
    {
        case AQGood: return @"(0–50)"; break;
        case AQModerate: return @"(51–100)"; break;
        case AQUnhealthyForSensitive: return @"(101–150)"; break;
        case AQUnhealthy: return @"(151–200)"; break;
        case AQVeryUnhealthy: return @"(201–300)"; break;
        case AQHazardous: return @"(300-500)"; break;
            
        default: break;
    }
    
    return @"";
}

+ (NSString *)aqPreventionDetailForAQ:(AQAirQuality)aq
{
    switch (aq)
    {
        case AQGood: return @"No significant health effects."; break;
        case AQModerate: return @"Unusually sensitive people should consider reducing prolonged or heavy outdoor exertion."; break;
        case AQUnhealthyForSensitive: return @"The following groups should reduce prolonged or heavy outdoor exertion:\n• People with lung disease, such as asthma\n• Children and older adults\n• People who are active outdoors"; break;
        case AQUnhealthy: return @"The following groups should avoid prolonged or heavy outdoor exertion:\n• People with lung disease, such as asthma\n• Children and older adults\n• People who are active outdoors\nEveryone else should limit prolonged outdoor exertion."; break;
        case AQVeryUnhealthy: return @"The following groups should avoid all outdoor exertion:\n• People with lung disease, such as asthma\n• Children and older adults\n• People who are active outdoors\nEveryone else should limit outdoor exertion."; break;
        case AQHazardous: return @""; break;
            
        default: break;
    }
    
    return @"";
}

+ (NSString *)worstAQ:(NSArray *)aq
{
    NSString *worst = @"Good";
    for (NSString *a in aq) {
        if ([worst isEqualToString:@"Good"] && ![a isEqualToString:@"Good"])
            worst = a;
        else if ([worst isEqualToString:@"Moderate"] && ![a isEqualToString:@"Good"] && ![a isEqualToString:@"Moderate"])
            worst = a;
        else if ([worst isEqualToString:@"Unhealthy for Sensitive Groups"] && ![a isEqualToString:@"Good"] && ![a isEqualToString:@"Moderate"] && ![a isEqualToString:@"Unhealthy for Sensitive Groups"])
            worst = a;
        else if ([worst isEqualToString:@"Unhealthy"] && ([a isEqualToString:@"Very Unhealthy"] || [a isEqualToString:@"Hazardous"]))
            worst = a;
        else if ([worst isEqualToString:@"Very Unhealthy"] && [a isEqualToString:@"Hazardous"])
            worst = a;
    }
    
    return worst;
}

+ (Location *)locationForAQLocation:(AQLocation)aql
{
    Location *loc = [[Location alloc] init];
    
    switch (aql) {
        case AQCentralLA:loc.latitude = @"34.0046"; loc.longitude = @"-118.2452"; break;
        case AQNorthwestCoastalLA:loc.latitude = @"34.0649"; loc.longitude = @"-118.4383"; break;
        case AQSouthwestCoastalLA:loc.latitude = @"33.9522"; loc.longitude = @"-118.3490"; break;
        case AQSouthCoastalLA:loc.latitude = @"33.7606"; loc.longitude = @"-118.3023"; break;
        case AQSanFrancisco:loc.latitude = @"37.7422"; loc.longitude = @"-122.3980"; break;
        case AQOakland:loc.latitude = @"37.8410"; loc.longitude = @"-122.2739"; break;
        case AQSanJose:loc.latitude = @"37.3076"; loc.longitude = @"-121.8777"; break;
        case AQSacramento:loc.latitude = @"38.5640"; loc.longitude = @"-121.5042"; break;
        case AQSanDiego:loc.latitude = @"32.7084"; loc.longitude = @"-117.1131"; break;
        case AQBakersfield:loc.latitude = @"35.3608"; loc.longitude = @"-118.9993"; break;
        case AQFresno:loc.latitude = @"36.6935"; loc.longitude = @"-119.7903"; break;
        case AQSequoia:loc.latitude = @"36.4287"; loc.longitude = @"-118.4830"; break;
        case AQYosemite:loc.latitude = @"37.6738"; loc.longitude = @"-119.7024"; break;
        case AQRedding:loc.latitude = @"40.5709"; loc.longitude = @"-122.3831"; break;
        case AQChico:loc.latitude = @"39.7228"; loc.longitude = @"-121.8338"; break;
        case AQLassen:loc.latitude = @"40.7626"; loc.longitude = @"-121.4712"; break;
        case AQConcord:loc.latitude = @"37.9688"; loc.longitude = @"-122.0315"; break;
        case AQSanRaefel:loc.latitude = @"37.9342"; loc.longitude = @"-122.6173"; break;
        case AQStockton:loc.latitude = @"37.9645"; loc.longitude = @"-121.2385"; break;
        case AQSantaCruz:loc.latitude = @"36.9968"; loc.longitude = @"-121.9472"; break;
        case AQHollister:loc.latitude = @"36.8738"; loc.longitude = @"-121.3484"; break;
        case AQMerced:loc.latitude = @"37.2989"; loc.longitude = @"-120.4091"; break;
        case AQColumbus:loc.latitude = @"32.4330"; loc.longitude = @"-84.9747"; break;
        case AQNipomo:loc.latitude = @"35.0410"; loc.longitude = @"-120.4502"; break;

        default: break;
    }
    
    return loc;
}

+ (NSString *)faqQuestionForSection:(NSInteger)section
{
    switch (section)
    {
        case 4: return @"What is the Air Quality Index (AQI)?"; break;
        case 5: return @"Where do we get the Air Quality information?"; break;
        case 6: return @"What pollutants are considered in the AQI?"; break;
        case 7: return @"What is particulate matter (PM)?"; break;
        case 8: return @"What are some of the health effects of air pollution?"; break;
        case 9: return @"What populations are especially vulnerable to air pollution?"; break;
        case 10: return @"What are some steps I can take to protect my health?"; break;
        case 11: return @"What are some steps that can be taken to protect the health of children?"; break;
        case 12: return @"What are outdoor activities?"; break;
        case 13: return @"Where do you get data for facilities that release toxics?"; break;

        default: break;
    }
    
    return @"";
}

+ (NSString *)faqAnswerForSection:(NSInteger)section
{
    switch (section)
    {
        case 4: return @"The AQI is a measure of how polluted or clean the air is.  The higher the AQI, the worse the air quality.  There are 6 levels in the AQI system; each depicted by a range and color.  Each level corresponds to certain health effects and identifies the populations that need to take steps to protect their health. An AQI of 100 corresponds to the national air quality standards and levels above 100 pose higher health risks."; break;
        case 5: return @"Air Quality information is obtained from the Environmental Protection Agency’s (EPA) AirNow website.  The AirNow program gathers air quality data monitored by regulatory agencies throughout the nation. The AQI has been developed by the EPA and is reported in accordance with EPA guidelines."; break;
        case 6: return @"The AQI is calculated by considering four major pollutants in the air – ozone, particulate matter (PM), sulfur dioxide and carbon monoxide. Ground-level ozone and PM pose the greatest threats to human health."; break;
        case 7: return @"Particulate Matter (PM) consists of particles of various shapes and sizes that are floating in the air and pose serious health hazards. PM10 and PM2.5 are two different categories that are regulated; PM10 are larger in size while PM2.5 are smaller in size.  The smaller particles are usually more harmful since they can get deposited deep in our lungs as we breathe. They come from a variety of sources such as vehicle exhaust, industrial processes, forest fires and dust."; break;
        case 8: return @"The health effects of air pollution include, but are not limited to, difficulty in breathing, respiratory inflammation, reduced lung function or lung damage, heart attacks, cancer and premature death. The effects may be due to short-term exposure (few hours-days) or long-term (over the course of months and years)."; break;
        case 9: return @"Air pollution affects young children, the elderly, people with pre-existing heart and lung disease and asthmatics disproportionately but it also affects young and healthy individuals."; break;
        case 10: return @"Limiting time outdoors is one of the most effective steps to reduce exposure to poor air quality.  When outdoor air quality is poor it is best to avoid outdoor exercise and close windows.  Outdoor activities that increase the heart rate also increase breathing rates and thus should be avoided. To reduce exposure to particles in the air, air filters on air conditioning/heating systems should be regularly maintained or stand-alone air filters/purifiers could be used.  Protective masks can be worn during outdoor activities."; break;
        case 11: return @"Since children are more active outdoors they breath in more air.  When combined with the fact that their lungs are still developing, make children under 18 a susceptible population.  Time spent outdoors should be limited when high air pollution events."; break;
        case 12: return @"Outdoor activities such as running or other exercises increase the breathing rate and thus can be harmful when air pollution is high outdoors even for healthy people.  Outdoor activities include running, jogging or strenuous gardening etc. that increase the heart rate."; break;
        case 13: return @"This data is obtained from EPA's Toxic Release Inventory (TRI). All large manufacturing facilities are required to report to the TRI on an annual basis and provide information about the amounts of specific chemicals that they release into the environment. These chemicals pose significant health hazards to humans and the environment e.g. cancer-causing chemicals."; break;

        default: break;
    }
    
    return @"";
}

+ (NSString *)intakeSurveyQuestionForQuestionNumber:(NSUInteger)questionNumber
{
    switch (questionNumber) {
        case 1: return @"Age"; break;
        case 2: return @"Sex"; break;
        case 3: return @"Children"; break;
        case 4: return @"Children Health Condition"; break;
        case 5: return @"Health Condition"; break;
        case 6: return @"Exercise"; break;
        case 7: return @"AQI"; break;
        case 8: return @"AQI Range"; break;
        case 9: return @"PM2.5"; break;

        default: break;
    }
    
    return @"";
}

@end

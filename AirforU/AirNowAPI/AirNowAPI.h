//
//  AirNow API.h
//  Air Quality
//
//  Created by QINGWEI on 1/20/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Location.h"

// define keys for results
#define AIR_NOW_RESULTS_AREA @"ReportingArea"
#define AIR_NOW_RESULTS_STATE_CODE @"StateCode"
#define AIR_NOW_RESULTS_AQI @"AQI"
#define AIR_NOW_RESULTS_DATE_OBSERVED @"DateObserved"
#define AIR_NOW_RESULTS_DATE_FORECAST @"DateForecast"
#define AIR_NOW_RESULTS_CATEGORY_NAME @"Category.Name"
#define AIR_NOW_RESULTS_ACTIONDAY @"actionDay"

#define AIR_NOW_HISTORY @"Historical Exposure"
#define AIR_NOW_TODAY @"Today's Air Quality"
#define AIR_NOW_TOMORROW_FORECAST @"Tomorrow's Forecast"

#define DOWNLOADED_AQI @"DownloadedAQI"
#define DOWNLOADED_LOCATION @"DownloadedLocation"
#define DOWNLOADED_DESCRIPTION @"DownloadedDescription"

#define NAVIGATION_BAR_HEIGHT 44.0
#define TAB_BAR_HEIGHT 49.0
#define TOP_HEIGHT 20.0

#define SECONDS_DAY 24*60*60

typedef enum {
    AQGood,
    AQModerate,
    AQUnhealthyForSensitive,
    AQUnhealthy,
    AQVeryUnhealthy,
    AQHazardous,
    AQUnavailable
} AQAirQuality;

typedef enum {
    AQCentralLA,
    AQNorthwestCoastalLA,
    AQSouthwestCoastalLA,
    AQSouthCoastalLA,
    AQSanFrancisco,
    AQOakland,
    AQSanJose,
    AQSacramento,
    AQSanDiego,
    AQBakersfield,
    AQFresno,
    AQSequoia,
    AQYosemite,
    AQRedding,
    AQChico,
    AQLassen,
    AQConcord,
    AQSanRaefel,
    AQStockton,
    AQSantaCruz,
    AQHollister,
    AQMerced,
    AQColumbus,
    AQNipomo
} AQLocation;

@interface AirNowAPI : NSObject

+ (NSURL *)URLForLatitute:(CLLocationDegrees)latitude
             forLongitude:(CLLocationDegrees)longitude;

+ (NSURL *)URLForDate:(NSDate *)date
          forLatitute:(CLLocationDegrees)latitude
         forLongitude:(CLLocationDegrees)longitude;

+ (NSURL *)URLForZipcode:(NSString *)zipcode;

+ (NSURL *)URLForDate:(NSDate *)date
           forZipcode:(NSString *)zipcode;

///* Air Quality Info */
//+ (NSDictionary *)airQualityInfoForDate:(NSDate *)date
//                           content:(NSString *)content
//                          latitude:(CLLocationDegrees)latitude
//                         longitude:(CLLocationDegrees)longitude;
//
//+ (NSDictionary *)airQualityInfoForDate:(NSDate *)date
//                           content:(NSString *)content
//                           zipcode:(NSString *)zipcode;

+ (AQAirQuality)aqForAQI:(NSString *)aqi;

+ (UIColor *)aqColorForAQ:(AQAirQuality)aq;
+ (UIColor *)aqTextColorForAQ:(AQAirQuality)aq;
+ (NSString *)aqImageNameForAQ:(AQAirQuality)aq;
+ (NSString *)aqQualityTitleForAQ:(AQAirQuality)aq;
+ (NSString *)aqRangeForAQ:(AQAirQuality)aq;
+ (NSString *)aqPreventionDetailForAQ:(AQAirQuality)aq;

+ (NSString *)worstAQ:(NSArray *)aq;

+ (Location *)locationForAQLocation:(AQLocation)aql;

// FAQ Questions & Answers
+ (NSString *)faqQuestionForSection:(NSInteger)section;
+ (NSString *)faqAnswerForSection:(NSInteger)section;

+ (NSString *)intakeSurveyQuestionForQuestionNumber:(NSUInteger)questionNumber;

@end

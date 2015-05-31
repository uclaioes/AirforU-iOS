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
#import "AQConstants.h"


@interface AirNowAPI : NSObject

+ (NSURL *)URLForLatitute:(CLLocationDegrees)latitude
             forLongitude:(CLLocationDegrees)longitude;

+ (NSURL *)URLForDate:(NSDate *)date
          forLatitute:(CLLocationDegrees)latitude
         forLongitude:(CLLocationDegrees)longitude;

+ (NSURL *)URLForZipcode:(NSString *)zipcode;

+ (NSURL *)URLForDate:(NSDate *)date
           forZipcode:(NSString *)zipcode;

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

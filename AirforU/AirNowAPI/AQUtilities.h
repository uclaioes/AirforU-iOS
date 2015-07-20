//
//  AQUtilities.h
//  AirforU
//
//  Created by QINGWEI on 6/2/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AQConstants.h"

@interface AQUtilities : NSObject

+ (AQAirQuality)aqForAQI:(NSString *)aqi;

+ (UIColor *)aqColorForAQ:(AQAirQuality)aq;
+ (UIColor *)aqTextColorForAQ:(AQAirQuality)aq;
+ (NSString *)aqImageNameForAQ:(AQAirQuality)aq;
+ (NSString *)aqQualityTitleForAQ:(AQAirQuality)aq;
+ (NSString *)aqRangeForAQ:(AQAirQuality)aq;
+ (NSAttributedString *)aqPreventionDetailForAQ:(AQAirQuality)aq;

+ (NSString *)worstAQ:(NSArray *)aq;

// FAQ Questions & Answers
+ (NSString *)faqQuestionForSection:(NSInteger)section;
+ (NSString *)faqAnswerForSection:(NSInteger)section;

+ (NSString *)intakeSurveyQuestionForQuestionNumber:(NSUInteger)questionNumber;

@end

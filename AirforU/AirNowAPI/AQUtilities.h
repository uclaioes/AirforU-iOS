/*!
 * @name        AQUtilities.h
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

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
+ (NSString *)aqPreventionDetailForAQ:(AQAirQuality)aq;

+ (NSString *)worstAQ:(NSArray *)aq;

// FAQ Questions & Answers
+ (NSString *)faqQuestionForSection:(NSInteger)section;
+ (NSString *)faqAnswerForSection:(NSInteger)section;

+ (NSString *)intakeSurveyQuestionForQuestionNumber:(NSUInteger)questionNumber;

@end

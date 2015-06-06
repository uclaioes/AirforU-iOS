//
//  AQDimensions.h
//  AirforU
//
//  Created by Qingwei on 6/6/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AQDimensions : NSObject

typedef enum {
    IPHONE4,
    IPHONE5,
    IPHONE6,
    IPHONE6P
} AQPhoneType;

/* Air Quality Page */
+ (CGFloat)sizeForContentLabelForPhoneType:(AQPhoneType)type;
+ (CGFloat)sizeForLocationLabelForPhoneType:(AQPhoneType)type;
+ (CGFloat)sizeForAQILabelForPhoneType:(AQPhoneType)type;
+ (CGFloat)sizeForAirQualityDescriptionForPhoneType:(AQPhoneType)type;
+ (CGFloat)sizeForBehavorialQuestionForPhoneType:(AQPhoneType)type;

/* Historical View Page */
+ (CGFloat)sizeForWeekdayLabelsForPhoneType:(AQPhoneType)type;
+ (CGFloat)sizeForSmallAQIForPhoneType:(AQPhoneType)type;
+ (CGFloat)sizeForLargeAQIForPhoneType:(AQPhoneType)type;
+ (CGFloat)sizeForAverageTextLabelForPhoneType:(AQPhoneType)type;
+ (CGFloat)sizeForAverageLabelForPhoneType:(AQPhoneType)type;
+ (CGFloat)sizeForAverageAirQualityDescriptionForPhoneType:(AQPhoneType)type;
+ (CGFloat)sizeForDisclaimerForPhoneType:(AQPhoneType)type;

@end

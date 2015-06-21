//
//  AQDimensions.m
//  AirforU
//
//  Created by Qingwei on 6/6/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "AQDimensions.h"

@implementation AQDimensions

/* Determine Phone Size */
+ (AQPhoneType)phoneTypeForScreenHeight:(CGFloat)height
{
    if (height <= 510)
        return IPHONE4;
    else if (height <= 600)
        return IPHONE5;
    else if (height <= 700)
        return IPHONE6;
    else
        return IPHONE6P;
}

/* Air Quality Page */
+ (CGFloat)sizeForContentLabelForPhoneType:(AQPhoneType)type
{
    switch (type) {
        case IPHONE4: return 16.0; break;
        case IPHONE5: return 18.0; break;
        case IPHONE6: return 20.0; break;
        case IPHONE6P: return 22.0; break;
        default: break;
    }
    
    return 0.0;
}

+ (CGFloat)sizeForLocationLabelForPhoneType:(AQPhoneType)type
{
    switch (type) {
        case IPHONE4: return 19.0; break;
        case IPHONE5: return 21.0; break;
        case IPHONE6: return 24.0; break;
        case IPHONE6P: return 27.0; break;
        default: break;
    }
    
    return 0.0;
}

+ (CGFloat)sizeForAQILabelForPhoneType:(AQPhoneType)type
{
    switch (type) {
        case IPHONE4: return 38.0; break;
        case IPHONE5: return 44.0; break;
        case IPHONE6: return 54.0; break;
        case IPHONE6P: return 66.0; break;
        default: break;
    }
    
    return 0.0;
}

+ (CGFloat)sizeForAirQualityDescriptionForPhoneType:(AQPhoneType)type
{
    switch (type) {
        case IPHONE4: return 19.0; break;
        case IPHONE5: return 21.0; break;
        case IPHONE6: return 24.0; break;
        case IPHONE6P: return 27.0; break;
        default: break;
    }
    
    return 0.0;
}

/* Historical View Page */
+ (CGFloat)sizeForWeekdayLabelsForPhoneType:(AQPhoneType)type
{
    switch (type) {
        case IPHONE4: return 14.0; break;
        case IPHONE5: return 15.0; break;
        case IPHONE6: return 16.0; break;
        case IPHONE6P: return 17.0; break;
        default: break;
    }
    
    return 0.0;
}

+ (CGFloat)sizeForSmallAQIForPhoneType:(AQPhoneType)type
{
    switch (type) {
        case IPHONE4: return 10.0; break;
        case IPHONE5: return 12.0; break;
        case IPHONE6: return 15.0; break;
        case IPHONE6P: return 16.0; break;
        default: break;
    }
    
    return 0.0;
}

+ (CGFloat)sizeForLargeAQIForPhoneType:(AQPhoneType)type
{
    switch (type) {
        case IPHONE4: return 22.0; break;
        case IPHONE5: return 26.0; break;
        case IPHONE6: return 30.0; break;
        case IPHONE6P: return 38.0; break;
        default: break;
    }
    
    return 0.0;
}

+ (CGFloat)sizeForAverageTextLabelForPhoneType:(AQPhoneType)type
{
    switch (type) {
        case IPHONE4: return 13.0; break;
        case IPHONE5: return 14.0; break;
        case IPHONE6: return 16.0; break;
        case IPHONE6P: return 18.0; break;
        default: break;
    }
    
    return 0.0;
}

+ (CGFloat)sizeForAverageAirQualityDescriptionForPhoneType:(AQPhoneType)type
{
    switch (type) {
        case IPHONE4: return 14.0; break;
        case IPHONE5: return 16.0; break;
        case IPHONE6: return 18.0; break;
        case IPHONE6P: return 20.0; break;
        default: break;
    }
    
    return 0.0;
}

+ (CGFloat)sizeForDisclaimerForPhoneType:(AQPhoneType)type;
{
    switch (type) {
        case IPHONE4: return 9.0; break;
        case IPHONE5: return 8.0; break;
        case IPHONE6: return 9.0; break;
        case IPHONE6P: return 11.0; break;
        default: break;
    }
    
    return 0.0;
}

@end

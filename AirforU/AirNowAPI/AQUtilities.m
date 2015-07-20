//
//  AQUtilities.m
//  AirforU
//
//  Created by QINGWEI on 6/2/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "AQUtilities.h"
#import "UIColor+Helper.h"

@interface AQUtilities ()

@end

@implementation AQUtilities

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
        case AQUnavailable: return [UIColor clearColor]; break;
            
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
        case AQHazardous: return @"(301-500)"; break;
            
        default: break;
    }
    
    return @"";
}

+ (NSAttributedString *)aqPreventionDetailForAQ:(AQAirQuality)aq
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    switch (aq)
    {
        case AQGood:
        {
            attributedString = [[NSMutableAttributedString alloc] initWithString: @"No significant health effects."];
            break;
        }
        case AQModerate:
        {
            attributedString = [[NSMutableAttributedString alloc] initWithString: @"Unusually sensitive people should consider reducing prolonged or heavy outdoor exertion."];
            break;
        }
        case AQUnhealthyForSensitive:
        {
            attributedString = [[NSMutableAttributedString alloc] initWithString: @"The following groups should reduce prolonged or heavy outdoor exertion:\n• People with lung disease, such as asthma\n• Children and older adults\n• People who are active outdoors"];
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(28, 6)];
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(35, 9)];
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(48, 5)];
            break;
        }
        case AQUnhealthy:
        {
            attributedString = [[NSMutableAttributedString alloc] initWithString: @"The following groups should avoid prolonged or heavy outdoor exertion:\n• People with lung disease, such as asthma\n• Children and older adults\n• People who are active outdoors\nEveryone else should limit prolonged outdoor exertion."];
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(28, 5)];
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(34, 9)];
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(47, 5)];
            break;
        }
        case AQVeryUnhealthy:
        {
            attributedString = [[NSMutableAttributedString alloc] initWithString: @"The following groups should avoid all outdoor exertion:\n• People with lung disease, such as asthma\n• Children and older adults\n• People who are active outdoors\nEveryone else should limit outdoor exertion."];
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(28, 9)];
            break;
        }
        case AQHazardous:
        {
            attributedString = [[NSMutableAttributedString alloc] initWithString: @"Health alert: everyone may experience more serous health effects."];
            break;
        }
        default: break;
    }
    
    return attributedString;
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

+ (NSString *)faqQuestionForSection:(NSInteger)section
{
    switch (section)
    {
        case 4: return @"What is the Air Quality Index (AQI)?"; break;
        case 5: return @"Where do you get the Air Quality information?"; break;
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

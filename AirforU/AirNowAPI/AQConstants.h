/*!
 * @name        AQConstants.h
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#ifndef AQCONSTANTS_INCLUDED
#define AQCONSTANTS_INCLUDED

// API key for Google Geocoding
#define GEOCODING_KEY @"AIzaSyCHM2Ix8dcqYfP86f3v64ZvqdhYIhmr3qk"
#define AIR_NOW_API_KEY @"11fb85f4-56b2-405d-9074-e726f7da8cda"

// define keys for AirNowAPI results
#define AIR_NOW_RESULTS_AREA @"ReportingArea"
#define AIR_NOW_RESULTS_AQI @"AQI"

//define keys for Google Geocoding Results
#define GEOCODING_RESULTS_FORMATTED_ADDRESS @"results.formatted_address"
#define GEOCODING_RESUTLS_ADDRESS_COMPONENTS @"results.address_components"
#define GEOCODING_RESULTS_LAT @"results.geometry.location.lat"
#define GEOCODING_RESULTS_LNG @"results.geometry.location.lng"

// define keys for Content in PageContentViewController
#define AIR_NOW_HISTORY @"Last Week AQI"
#define AIR_NOW_TODAY @"Today's Air Quality"
#define AIR_NOW_TOMORROW_FORECAST @"Tomorrow's Forecast"

// define seconds in a day
#define SECONDS_PER_DAY 24*60*60

#define BEHAVIORAL_QUESTION_DATE @"behavioralQuestionDate"
#define HAS_BEEN_SURVEYED @"hasBeenSurveyed"
#define REFRESH_DATE @"refreshDate"

// define AQ levels
typedef enum {
    AQUnavailable,
    AQGood,
    AQModerate,
    AQUnhealthyForSensitive,
    AQUnhealthy,
    AQVeryUnhealthy,
    AQHazardous
} AQAirQuality;

#endif

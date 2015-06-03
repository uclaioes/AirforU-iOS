//
//  AQConstants.h
//  AirforU
//
//  Created by QINGWEI on 5/31/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#ifndef AQCONSTANTS_INCLUDED
#define AQCONSTANTS_INCLUDED

// API key for Google Geocoding
#define GEOCODING_KEY @"AIzaSyCHM2Ix8dcqYfP86f3v64ZvqdhYIhmr3qk"
#define AIR_NOW_API_KEY @"11fb85f4-56b2-405d-9074-e726f7da8cda"

// define keys for AirNowAPI results
#define AIR_NOW_RESULTS_AREA @"ReportingArea"
#define AIR_NOW_RESULTS_STATE_CODE @"StateCode"
#define AIR_NOW_RESULTS_AQI @"AQI"
#define AIR_NOW_RESULTS_DATE_OBSERVED @"DateObserved"
#define AIR_NOW_RESULTS_DATE_FORECAST @"DateForecast"
#define AIR_NOW_RESULTS_CATEGORY_NAME @"Category.Name"
#define AIR_NOW_RESULTS_ACTIONDAY @"actionDay"

//define keys for Google Geocoding Results
#define GEOCODING_RESULTS_FORMATTED_ADDRESS @"results.formatted_address"
#define GEOCODING_RESUTLS_ADDRESS_COMPONENTS @"results.address_components"
#define GEOCODING_RESULTS_LAT @"results.geometry.location.lat"
#define GEOCODING_RESULTS_LNG @"results.geometry.location.lng"

// define keys for Content in PageContentViewController
#define AIR_NOW_HISTORY @"Historical Exposure"
#define AIR_NOW_TODAY @"Today's Air Quality"
#define AIR_NOW_TOMORROW_FORECAST @"Tomorrow's Forecast"

#define DOWNLOADED_AQI @"DownloadedAQI"
#define DOWNLOADED_LOCATION @"DownloadedLocation"
#define DOWNLOADED_DESCRIPTION @"DownloadedDescription"

// define UI sizes
#define NAVIGATION_BAR_HEIGHT 44.0
#define TAB_BAR_HEIGHT 49.0
#define TOP_HEIGHT 20.0

// define seconds in a day
#define SECONDS_PER_DAY 24*60*60

// define AQ levels
typedef enum {
    AQGood,
    AQModerate,
    AQUnhealthyForSensitive,
    AQUnhealthy,
    AQVeryUnhealthy,
    AQHazardous,
    AQUnavailable
} AQAirQuality;

// test cities
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

#endif

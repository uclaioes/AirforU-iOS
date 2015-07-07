//
//  AppDelegate.h
//  Air Quality
//
//  Created by QINGWEI on 2/8/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AQConstants.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/* Location Properties (with Core Location) */
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLPlacemark *placemark;


@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic) BOOL shouldZipSearch;
@property (nonatomic) BOOL shouldCitySearch;
@property (nonatomic, strong) NSString *city;

- (NSArray *)getAirQualityWithContent:(NSString *)content;

/* Intake survey properties */
@property (nonatomic, strong) NSMutableArray *answers; // contains NSString
@property (nonatomic, strong) NSMutableArray *userInformation; // contains NSString

@end


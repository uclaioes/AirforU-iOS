//
//  AppDelegate.m
//  Air Quality
//
//  Created by QINGWEI on 2/8/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "AppDelegate.h"
#import "AirNowAPI.h"
#import "AirQualityFetchAPI.h"
#import "ViewController.h"
#import "QuestionTableViewController.h"
#import "GASend.h"
#import "CCLocationNotifications.h"
#import "NSDate+AQHelper.h"

@interface AppDelegate () <UITabBarControllerDelegate, CLLocationManagerDelegate>
@end

@implementation AppDelegate
{
    BOOL allowNotif;
    BOOL allowsSound;
    BOOL allowsBadge;
    BOOL allowsAlert;
}

#pragma mark - Application Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /* Background session configuration */
    [application setMinimumBackgroundFetchInterval:14400];  // 4 hours
    
    
    
    /* Initialize Google Analytics Tracker */
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 45;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-60540649"];
    
    
    
    /* Register Local Notifications */
    UIUserNotificationType types = UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [application registerUserNotificationSettings:mySettings];
    
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    [self setNotificationTypesAllowed];
    if (notif)
    {
        if (allowNotif && allowsAlert) {
            NSCalendar *cal = [NSCalendar currentCalendar];
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            [comps setDay:9];
            [comps setMonth:5];
            [comps setYear:2015];
            [comps setHour:10];
            [comps setMinute:0];
            [comps setSecond:0];
            [cal setTimeZone:[NSTimeZone defaultTimeZone]];
            NSDate *tempDate = [cal dateFromComponents:comps];
            
            notif.timeZone = [NSTimeZone defaultTimeZone];
            notif.fireDate = tempDate;
            notif.repeatInterval = NSCalendarUnitWeekOfYear;
            notif.alertBody = @"Check your local air quality levels!";
            
            /* Schedule Notification */
            [application scheduleLocalNotification:notif];
            
            [GASend sendEventWithAction:@"Notification Services Enabled"];
        } else {
            [GASend sendEventWithAction:@"Notification Services Disabled"];
        }
    }
    
    
    
    /* Core Location Integration */
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    } else if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
    
    if ([CLLocationManager locationServicesEnabled]) {
        [GASend sendEventWithAction:@"Location Services Enabled"];
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            [GASend sendEventWithAction:@"Location Services Permission Denied"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                            message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
            [GASend sendEventWithAction:@"Location Services Permission Authorized Always"];
        } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            [GASend sendEventWithAction:@"Location Services Permission Authorized When In Use"];
        }
    } else {
        [GASend sendEventWithAction:@"Location Services Disabled"];
    }
    
    
    
    /* Other Setups on Launch */
    ((UITabBarController *)self.window.rootViewController).delegate = self;
    
    UIGraphicsBeginImageContext(self.window.frame.size);
    [[UIImage imageNamed:@"good_background.png"] drawInRect:self.window.bounds];
    UIImage *bg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.window.backgroundColor = [UIColor colorWithPatternImage:bg];
    
    for (int i = 0; i < 9; i++)
        [self.answers addObject:@""];
    
    for (int i = 0; i < 3; i++)
        [self.userInformation addObject:@""];
    
    [self.window makeKeyAndVisible];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL surveyed = [defaults boolForKey:HAS_BEEN_SURVEYED];
    NSString *date = [defaults stringForKey:BEHAVIORAL_QUESTION_DATE];
    if (!date)
        [defaults setObject:[[NSDate dateWithTimeIntervalSince1970:0] dateID] forKey:BEHAVIORAL_QUESTION_DATE];
    
    NSString *refreshDate = [defaults stringForKey:REFRESH_DATE];
    if (!refreshDate)
        [defaults setObject:[[NSDate dateWithTimeIntervalSince1970:0] dateID] forKey:REFRESH_DATE];
    
    if (!surveyed) {
        [[((UITabBarController *)self.window.rootViewController).viewControllers firstObject] performSegueWithIdentifier:@"Agreement Segue" sender:self];
    } else {
        self.zipcode = [defaults objectForKey:@"zipcode"];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application
performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"BACKGROUND FETCH STARTED");
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURL *url;
    if (self.latitude && self.longitude)
        url = [AirNowAPI URLForLatitute:self.latitude forLongitude:self.longitude];
    else if (![self.zipcode isEqualToString:@""])
        url = [AirNowAPI URLForZipcode:self.zipcode];
    else
        url = [AirNowAPI URLForZipcode:@"90024"];
    
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completionHandler(UIBackgroundFetchResultFailed);
            return;
        }
        
        // Parse response/data and determine whether new content was available
        // Launch notifications if over AQI 100
        
        if (data) {
            
            NSDictionary *propertyListResults;
            NSError *error2;
            
            propertyListResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error2];
            NSNumber *max = [[propertyListResults valueForKeyPath:AIR_NOW_RESULTS_AQI] valueForKeyPath:@"@max.intValue"];
//            max = [NSNumber numberWithInt:150];
            NSLog(@"%@", max);
            
            if ([max integerValue] >= 100) {
                // Create local notification to alert
                UILocalNotification *notif = [[UILocalNotification alloc] init];
                if (notif == nil)
                    return;
                notif.alertBody = @"Your local air quality is poor!";
                [application presentLocalNotificationNow:notif];
                [GASend sendEventWithAction:@"Notification (Local air quality is poor) Sent"];
            }
        }
        
        completionHandler(UIBackgroundFetchResultNewData);
        return;
        
    }];
    
    [task resume];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [GASend sendEventWithAction:@"Notification (Check local air quality) Sent"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[GAI sharedInstance] dispatch];
    
    /* Google Analytics Report */
    [GASend sendEventWithAction:@"Close App"];
    [GASend sendEventWithAction:@"---------------------------------------------------"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /* Google Analytics Report */
    [GASend sendEventWithAction:@"---------------------------------------------------"];
    [GASend sendEventWithAction:@"Open App"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[GAI sharedInstance] dispatch];
    
    /* Google Analytics Report */
    [GASend sendEventWithAction:@"Close App"];
    [GASend sendEventWithAction:@"---------------------------------------------------"];
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSUInteger index = tabBarController.selectedIndex;
    
    /* Google Analytics Report */
    switch (index) {
        case 0: [GASend sendEventWithAction:@"Show Air Quality Tab"]; break;
        case 1: [GASend sendEventWithAction:@"Show Health Info Tab"]; break;
        case 2: [GASend sendEventWithAction:@"Show Toxics Tab"]; break;
        case 3: [GASend sendEventWithAction:@"Show Prizes Tab"]; break;
        case 4: [GASend sendEventWithAction:@"Show Learn More Tab"]; break;
        default: break;
    }
}

#pragma mark - QuestionTableViewControllerDelegate

- (NSMutableArray *)answers
{
    if (!_answers)
        _answers = [[NSMutableArray alloc] initWithCapacity:0];
    return _answers;
}

- (NSMutableArray *)userInformation
{
    if (!_userInformation)
        _userInformation = [[NSMutableArray alloc] initWithCapacity:0];
    return _userInformation;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (self.latitude == 0 || self.longitude == 0) {
        [self.locationManager stopUpdatingLocation];
        CLLocation *location = [locations lastObject];
        self.latitude = location.coordinate.latitude;
        self.longitude = location.coordinate.longitude;

        NSLog(@"GPS LOCATION: %f, %f", self.latitude, self.longitude);
        
        if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground) {
            NSLog(@"NOTIFICATION SENT");
            [[NSNotificationCenter defaultCenter] postNotificationName:CLLocationDidUpdateNotification object:self];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:CLLocationDidBackgroundUpdateNotification object:self];
            NSLog(@"APPLICATION IS IN BACKGROUND");
        }
    }
}

#pragma mark - Actions

- (void)setNotificationTypesAllowed
{
    // get the current notification settings
    UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    allowNotif = (currentSettings.types != UIUserNotificationTypeNone);
    allowsSound = (currentSettings.types & UIUserNotificationTypeSound) != 0;
    allowsBadge = (currentSettings.types & UIUserNotificationTypeBadge) != 0;
    allowsAlert = (currentSettings.types & UIUserNotificationTypeAlert) != 0;
}

- (NSArray *)getAirQualityWithContent:(NSString *)content
{
    NSArray *values;

    /* Google Analytics Report */
    
    if (self.shouldZipSearch && self.zipcode && [self.zipcode length] == 5) {
        
        [GASend sendEventWithAction:[NSString stringWithFormat:@"Show %@ (%@)", content, self.zipcode]];
        values = [AirQualityFetchAPI getAirQualityForContent:content forZipcode:self.zipcode];
        
    } else if (self.shouldCitySearch && self.city) {
        
        [GASend sendEventWithAction:[NSString stringWithFormat:@"Show %@ (%@)", content, self.city]];
        values = [AirQualityFetchAPI getAirQualityForContent:content forSearch:self.city];
        
    } else if (self.latitude && self.longitude) {
        
        [GASend sendEventWithAction:[NSString stringWithFormat:@"Show %@ (%f, %f)", content, self.latitude, self.longitude]];
        values = [AirQualityFetchAPI getAirQualityForContent:content forLatitude:self.latitude forLongitude:self.longitude];
        
    } else {
        
        [GASend sendEventWithAction:[NSString stringWithFormat:@"Show %@ (Default)", content]];
        values = [AirQualityFetchAPI getAirQualityForContent:content forZipcode:@"90024"];
        
    }

    return values;
}

@end

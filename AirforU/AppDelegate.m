//
//  AppDelegate.m
//  Air Quality
//
//  Created by QINGWEI on 2/8/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "AppDelegate.h"
#import "AirNowAPI.h"
#import "ViewController.h"
#import "PageContentViewController.h"
#import "QuestionTableViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "CCLocationNotifications.h"
#import "NSDate+AQHelper.h"

#import "GoogleGeocodingAPI.h"

@interface AppDelegate () <UITabBarControllerDelegate, CLLocationManagerDelegate>
@end

@implementation AppDelegate
{
    BOOL allowNotif;
    BOOL allowsSound;
    BOOL allowsBadge;
    BOOL allowsAlert;
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSUInteger index = tabBarController.selectedIndex;
    
    /* Google Analytics Report */
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSString *identification = self.identification;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    switch (index) {
        case 0: [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:@"Show Air Quality Tab" label:timestamp value:nil] build]]; break;
        case 1: [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:@"Show Health Info Tab" label:timestamp value:nil] build]]; break;
        case 2: [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:@"Show Toxics Tab" label:timestamp value:nil] build]]; break;
        case 3: [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:@"Show Prizes Tab" label:timestamp value:nil] build]]; break;
        case 4: [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:@"Show Learn More Tab" label:timestamp value:nil] build]]; break;
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
    if (self.location.coordinate.latitude == 0 || self.location.coordinate.longitude == 0) {
        [self.locationManager stopUpdatingLocation];
        CLLocation *location = [locations lastObject];
        self.location = location;
        NSLog(@"GPS LOCATION: %f, %f", self.location.coordinate.latitude, self.location.coordinate.longitude);
        
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

- (NSArray *)getURLForAirQualityWithContent:(NSString *)content
{
    /* Google Analytics Report */
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSString *identification = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).identification;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    NSURL *airnowURL = nil;
    NSURL *geocodingURL = nil;
    
    if (self.shouldZipSearch && self.zipcode && [self.zipcode length] == 5)
    {
        NSLog(@"used zipcode");
        geocodingURL = [GoogleGeocodingAPI urlForSearch:self.zipcode];
        if ([content isEqualToString:AIR_NOW_TODAY]) {
            airnowURL = [AirNowAPI URLForZipcode:self.zipcode];
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:[NSString stringWithFormat:@"Show Today's Air Quality (%@)", self.zipcode] label:timestamp value:nil] build]];
        } else if ([content isEqualToString:AIR_NOW_TOMORROW_FORECAST])
            airnowURL = [AirNowAPI URLForDate:[[NSDate date] dateByAddingTimeInterval:SECONDS_DAY] forZipcode:self.zipcode];
    }
    
    else if (self.location && self.location.coordinate.latitude && self.location.coordinate.longitude)
    {
        NSLog(@"used location");
//        geocodingURL = [GoogleGeocodingAPI];
        if ([content isEqualToString:AIR_NOW_TODAY]) {
            airnowURL = [AirNowAPI URLForLatitute:self.location.coordinate.latitude forLongitude:self.location.coordinate.longitude];
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:[NSString stringWithFormat:@"Show Today's Air Quality (%f, %f)", self.location.coordinate.latitude, self.location.coordinate.longitude] label:timestamp value:nil] build]];
        } else if ([content isEqualToString:AIR_NOW_TOMORROW_FORECAST])
            airnowURL = [AirNowAPI URLForDate:[[NSDate date] dateByAddingTimeInterval:SECONDS_DAY] forLatitute:self.location.coordinate.latitude forLongitude:self.location.coordinate.longitude];
    }
    
    else
    {
        NSLog(@"used default");
        NSString *zipcode = @"90024"; // defaulted to: zipcode of UCLA
        
        geocodingURL = [GoogleGeocodingAPI urlForSearch:zipcode];
        
        if ([content isEqualToString:AIR_NOW_TODAY]) {
            airnowURL = [AirNowAPI URLForZipcode:zipcode];
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:@"Show Today's Air Quality (Default)" label:timestamp value:nil] build]];
        } else if ([content isEqualToString:AIR_NOW_TOMORROW_FORECAST])
            airnowURL = [AirNowAPI URLForDate:[[NSDate date] dateByAddingTimeInterval:SECONDS_DAY] forZipcode:zipcode];
    }
    
    return @[airnowURL ? airnowURL : [NSNull null],
             geocodingURL ? geocodingURL : [NSNull null]];
}

- (NSArray *)getAirQualityWithContent:(NSString *)content
{
    NSArray *urls = [self getURLForAirQualityWithContent:content];
    // use geocoding to get location
    NSURL *geocodingURL = urls[1];
    NSURL *airnowURL = urls[0];
    
    NSString *location = @"Not Available";
    NSString *aqi = @"N/A";
    
    if ((NSNull *)geocodingURL != [NSNull null]) {
        NSData *jsonResults = [NSData dataWithContentsOfURL:geocodingURL];
        if (jsonResults) {
            NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
            NSString *formattedAddress = [[propertyListResults valueForKeyPath:GEOCODING_RESULTS_FORMATTED_ADDRESS] firstObject];
            if (formattedAddress)
                location = formattedAddress;
        }
    }
    
    if ((NSNull *)airnowURL != [NSNull null]) {
        NSData *jsonResults = [NSData dataWithContentsOfURL:airnowURL];
        NSDictionary *propertyListResults;
        if (jsonResults) {
            
            propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
            BOOL categoryExists = false;
            
            NSArray *category = [propertyListResults valueForKeyPath:AIR_NOW_RESULTS_CATEGORY_NAME];
            if (category && [category count] > 0)
                categoryExists = true;
            NSNumber *max = [[propertyListResults valueForKeyPath:AIR_NOW_RESULTS_AQI] valueForKeyPath:@"@max.intValue"];
            if ([max isEqualToNumber:[NSNumber numberWithInt:-1]] || [propertyListResults count] <= 0)
                max = [NSNumber numberWithInt:-1];
            
            NSString *maxString;
            if ([max isEqualToNumber:[NSNumber numberWithInteger:-1]] && !categoryExists)
                maxString = @"N/A";
            else if ([max isEqualToNumber:[NSNumber numberWithInteger:-1]] && categoryExists)
                maxString = @"";
            else
                maxString = [NSString stringWithFormat:@"%@", max];
            
            aqi = maxString;
        }
    }
    
    NSLog(@"%@", @[aqi, location]);
    
    return @[aqi, location];
}

#pragma mark - Application Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    NSURL *url = [GoogleGeocodingAPI urlForCity:@"westwood ca"];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    if (data) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//        NSLog(@"%@",dict);
//        NSString *add = [[dict valueForKeyPath:GEOCODING_RESULTS_FORMATTED_ADDRESS] firstObject];
//        NSString *lat = [[dict valueForKeyPath:GEOCODING_RESULTS_LAT] firstObject];
//        NSString *lng = [[dict valueForKeyPath:GEOCODING_RESULTS_LNG] firstObject];
//
//        NSLog(@"%@ (%@, %@)", add, lat, lng);
//        
//        NSURL *search = [AirNowAPI URLForLatitute:[lat doubleValue] forLongitude:[lng doubleValue]];
//        NSData *searchData = [NSData dataWithContentsOfURL:search];
//        if (searchData) {
//            NSDictionary *s = [NSJSONSerialization JSONObjectWithData:searchData options:0 error:NULL];
//            NSString *location = [NSString stringWithFormat:@"%@ %@", [[s valueForKeyPath:AIR_NOW_RESULTS_AREA] firstObject], [[s valueForKeyPath:AIR_NOW_RESULTS_STATE_CODE] firstObject]];
//            NSLog(@"LOCATION %@", location);
//        }
//    }
    
    /* Background session configuration */
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    
    
    /* Get the state of applicaton
     * Background or Foreground */
    UIApplicationState state = application.applicationState;
    NSLog(@"Background? %d", state == UIApplicationStateBackground);
    
    
    
    /* Initialize Google Analytics Tracker */
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 45;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-60706322-1"];
    
    
    
    /* Register Local Notifications */
    UIUserNotificationType types = UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [application registerUserNotificationSettings:mySettings];
    
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    [self setNotificationTypesAllowed];
    if (notif)
    {
        if (allowNotif && allowsAlert)
        {
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
        
        NSLog(@"Location Services Enabled");
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
            [alert show];
        }
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
    BOOL surveyed = [defaults boolForKey:@"hasBeenSurveyed"];
    NSString *date = [defaults stringForKey:@"behavioralQuestionDate"];
    if (!date)
        [defaults setObject:[[NSDate dateWithTimeIntervalSince1970:0] dateID] forKey:@"behavioralQuestionDate"];
    
    NSString *refreshDate = [defaults stringForKey:@"refreshDate"];
    if (!refreshDate)
        [defaults setObject:[[NSDate dateWithTimeIntervalSince1970:0] dateID] forKey:@"refreshDate"];
    
    if (!surveyed)
        [[((UITabBarController *)self.window.rootViewController).viewControllers firstObject] performSegueWithIdentifier:@"Agreement Segue" sender:self];
    else {
        self.identification = [defaults objectForKey:@"identification"];
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
    
    NSURL *url = [self getURLForAirQualityWithContent:AIR_NOW_TODAY][0];
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
            }
        }
        
        completionHandler(UIBackgroundFetchResultNewData);
        return;
        
    }];
    
    [task resume];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[GAI sharedInstance] dispatch];
    
    /* Google Analytics Report */
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSString *identification = self.identification;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:@"Close App" label:timestamp value:nil] build]];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:@"---------------------------------------------------"
                                                           label:timestamp value:nil] build]];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    /* Google Analytics Report */
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSString *identification = self.identification;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    if (self.identification) {
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:@"---------------------------------------------------"
                                                               label:timestamp value:nil] build]];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:@"Open App" label:timestamp value:nil] build]];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    [self saveContext];
    [[GAI sharedInstance] dispatch];
    
    /* Google Analytics Report */
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSString *identification = self.identification;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:@"Close App" label:timestamp value:nil] build]];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory
{
    // The directory the application uses to store the Core Data store file. This code uses a directory named "LAN.Air_Quality" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Air_Quality" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Air_Quality.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext
{
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

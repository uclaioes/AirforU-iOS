/*!
 * @name        AppDelegate.m
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import "AppDelegate.h"
#import "AirNowAPI.h"
#import "AirQualityFetchAPI.h"
#import "ViewController.h"
#import "QuestionTableViewController.h"
#import "GASend.h"
#import "CCLocationNotifications.h"
#import "NSDate+AQHelper.h"

@interface AppDelegate () <UITabBarControllerDelegate, CLLocationManagerDelegate>

/* GCM properties */
@property(nonatomic, strong) void (^registrationHandler) (NSString *registrationToken, NSError *error);
@property(nonatomic, assign) BOOL connectedToGCM;
@property(nonatomic, strong) NSString* registrationToken;
@property(nonatomic, assign) BOOL subscribedToTopic;

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
    /* Initialize Google Analytics Tracker */
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 45;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-60540649"];
    
    /* Register for local notifications */
    UIUserNotificationType types = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [application registerUserNotificationSettings:mySettings];
    
    /* Register for remote notifications */
    [application registerForRemoteNotifications];
    
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    [self setNotificationTypesAllowed];
    
    if (notif) {
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
    if (!date) {
        [defaults setObject:[[NSDate dateWithTimeIntervalSince1970:0] dateID] forKey:BEHAVIORAL_QUESTION_DATE];
    }
    
    NSString *refreshDate = [defaults stringForKey:REFRESH_DATE];
    if (!refreshDate) {
        [defaults setObject:[[NSDate dateWithTimeIntervalSince1970:0] dateID] forKey:REFRESH_DATE];
    }
    
    if (!surveyed) {
        [[((UITabBarController *)self.window.rootViewController).viewControllers firstObject] performSegueWithIdentifier:@"Agreement Segue" sender:self];
    } else {
        self.zipcode = [defaults objectForKey:@"zipcode"];
    }
    
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"TOKEN: %@", deviceToken);
    [GASend sendEventWithAction:@"Device ID" withLabel:[NSString stringWithFormat:@"%@", deviceToken]];
    
    // Start the GGLInstanceID shared instance with the default config
    // and request a registration token to enable reception of notifications
    [[GGLInstanceID sharedInstance] startWithConfig:[GGLInstanceIDConfig defaultConfig]];
    _registrationOptions = @{kGGLInstanceIDRegisterAPNSOption: deviceToken,
                             kGGLInstanceIDAPNSServerTypeSandboxOption: @YES};
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:_gcmSenderID
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:_registrationOptions
                                                      handler:_registrationHandler];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [GASend sendEventWithAction:@"Notification (Check local air quality) Sent"];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"Notification received: %@", userInfo);
    
    // This works only if the app started the GCM service
    [[GCMService sharedInstance] appDidReceiveMessage:userInfo];
    
    // Handle the received message
    // Invoke the completion handler passing the appropriate UIBackgroundFetchResult value
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[GAI sharedInstance] dispatch];
    
    /* Google Analytics Report */
    [GASend sendEventWithAction:@"Close App"];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /* Google Analytics Report */
    [GASend sendEventWithAction:@"Open App"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[GAI sharedInstance] dispatch];
    
    /* Google Analytics Report */
    [GASend sendEventWithAction:@"Close App"];
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

#pragma mark - GGLInstanceIDDelegate

- (void)onTokenRefresh
{
    // A rotation of the registration tokens is happening, so the app needs to request a new token.
    NSLog(@"The GCM registration token needs to be changed.");
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:_gcmSenderID
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:_registrationOptions
                                                      handler:_registrationHandler];
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

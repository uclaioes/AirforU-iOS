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

@interface AppDelegate () <UITabBarControllerDelegate, CLLocationManagerDelegate>
@end

@implementation AppDelegate

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

//- (void)test
//{
//    AQLocation aqloc = AQNorthwestCoastalLA;
//    self.location = [AirNowAPI locationForAQLocation:aqloc];
//}

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
//    NSLog(@"%@", [AirNowAPI URLForLatitute:self.location.coordinate.latitude forLongitude:self.location.coordinate.longitude]);
    
    if (self.location.coordinate.latitude == 0 || self.location.coordinate.longitude == 0) {
        [self.locationManager stopUpdatingLocation];
        CLLocation *location = [locations lastObject];
        self.location = location;
        NSLog(@"%f, %f", self.location.coordinate.latitude, self.location.coordinate.longitude);
        [[NSNotificationCenter defaultCenter] postNotificationName:CLLocationDidUpdateNotification object:self];
    }
}

#pragma mark - Application Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /* Initialize Google Analytics Tracker */

    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 45;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-60706322-1"];
    
    
    
    /* Core Location Integration */
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    [self.locationManager requestWhenInUseAuthorization];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    } else if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }

    [self.locationManager startUpdatingLocation];
    
    
    /* Other Setups on Launch */
    
    ((UITabBarController *)self.window.rootViewController).delegate = self;
    
    self.zipcode = nil;
//    self.location = nil;
    
    for (int i = 0; i < 9; i++)
        [self.answers addObject:@""];
    
    for (int i = 0; i < 3; i++)
        [self.userInformation addObject:@""];
    
    [self.window makeKeyAndVisible];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL surveyed = [defaults boolForKey:@"hasBeenSurveyed"];
    
    if (!surveyed)
        [[((UITabBarController *)self.window.rootViewController).viewControllers firstObject] performSegueWithIdentifier:@"Agreement Segue" sender:self];
    else
        self.identification = [defaults objectForKey:@"identification"];
        
    return YES;
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
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:@"Show Today's Air Quality" label:timestamp value:nil] build]];
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

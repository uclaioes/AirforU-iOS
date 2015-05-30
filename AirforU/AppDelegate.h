//
//  AppDelegate.h
//  Air Quality
//
//  Created by QINGWEI on 2/8/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "Location.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

/* Location Properties (with Core Location) */
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, strong) CLLocation *location;

@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic) BOOL shouldZipSearch;

- (NSURL *)getURLForAirQualityWithContent:(NSString *)content;

@property (nonatomic, strong) NSString *identification;

@property (nonatomic, strong) NSMutableArray *answers; // contains NSString
@property (nonatomic, strong) NSMutableArray *userInformation; // contains NSString

@end


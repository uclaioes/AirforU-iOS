/*!
 * @name        AppDelegate.h
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Google/CloudMessaging.h>
#import "AQConstants.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/* Location Properties (with Core Location) */
@property (nonatomic, strong) CLLocationManager *locationManager;

/* Air Quality fetch properties */
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


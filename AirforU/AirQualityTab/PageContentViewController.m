//
//  PageContentViewController.m
//  Air Quality
//
//  Created by QINGWEI on 2/28/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "PageContentViewController.h"
#import "HealthInfoTableViewController.h"
#import "CCLocationNotifications.h"
#import "ViewController.h"
#import "AirNowAPI.h"
#import "AppDelegate.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface PageContentViewController ()

@property (nonatomic) AQAirQuality aq;

// User Interface Properties
@property (nonatomic, strong) UIButton *aqiButton;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *qualityLabel;
@property (nonatomic, strong) UILabel *contentLabel;

// Air Quality Properties
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

@property (nonatomic, strong) NSString *aqi;
@property (nonatomic, strong) NSString *location;

// Historical Exposure Properties
@property (nonatomic, strong) NSArray *history;
@property (nonatomic, strong) NSString *zipcode;
@property (nonatomic) NSInteger average;

@end

@implementation PageContentViewController

#define GAP 10.0

- (void)setLabel:(UILabel *)label
           title:(NSString *)title
      titleColor:(UIColor *)textColor
            font:(UIFont *)textFont
 backgroundColor:(UIColor *)backgroundColor
   textAlignment:(NSTextAlignment)textAlignment
   lineBreakMode:(NSLineBreakMode)mode
      lineNumber:(NSInteger)numberOfLines
{
    label.text = title;
    label.textColor = textColor;
    label.backgroundColor = backgroundColor;
    label.textAlignment = textAlignment;
    label.lineBreakMode = mode;
    label.numberOfLines = numberOfLines;
    label.font = textFont;
}

- (void)setButton:(UIButton *)button
            title:(NSString *)title
       titleColor:(UIColor *)textColor
             font:(UIFont *)textFont
  backgroundColor:(UIColor *)backgroundColor
     cornerRadius:(CGFloat)cornerRadius
{
    button.backgroundColor = backgroundColor;
    button.layer.cornerRadius = cornerRadius;
    button.titleLabel.font = textFont;
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
}

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAirQuality:) name:CLLocationDidUpdateNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    if ([self.content isEqualToString:AIR_NOW_HISTORY])
    {
        self.zipcode = @"90024";
        self.history = @[@{@"Tue" : @"210"},
                         @{@"Wed" : @"1"},
                         @{@"Thu" : @"60"},
                         @{@"Fri" : @"101"},
                         @{@"Sat" : @"350"},
                         @{@"Sun" : @"200"}];
        
        NSInteger total = 0;
        for (NSDictionary *dict in self.history) {
            NSInteger value = [[[dict allValues] firstObject] integerValue];
            total += value;
        }
        self.average = total / 6.0;
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.contentSize/24.0, self.view.bounds.size.width, self.contentSize/18.0)];
        [self.view addSubview:self.contentLabel];
        
        /* Content Label */
        [self setLabel:self.contentLabel
                 title:[NSString stringWithFormat:@"Last week exposure %@", self.zipcode]
            titleColor:[UIColor blackColor]
                  font:[UIFont fontWithName:@"Helvetica-Bold" size:19.0]
       backgroundColor:[UIColor clearColor]
         textAlignment:NSTextAlignmentCenter
         lineBreakMode:NSLineBreakByWordWrapping
            lineNumber:1];
        
        CGFloat height = (self.contentSize*(5.0/8.0) - self.contentLabel.bounds.size.height - 6*GAP) / 6;
        
        for (int i = 0; i < [self.history count]; i++) {
            NSDictionary *dict = self.history[i];
            NSString *key = [[dict allKeys] firstObject];
            NSString *value = [dict valueForKey:key];
            
            /* Exposure AQI Label */
            UIButton *exposureButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2.0 - height/2.0, self.contentSize/18.0 + self.contentLabel.bounds.size.height + GAP + i*(height + GAP), height, height)];
            [self.view addSubview:exposureButton];
            
            [self setButton:exposureButton
                      title:value
                 titleColor:[UIColor blackColor]
                       font:[UIFont fontWithName:@"Helvetica" size:13.0]
            backgroundColor:[AirNowAPI aqColorForAQ:[AirNowAPI aqForAQI:value]]
               cornerRadius:height/2.0];
            
            UILabel *exposureLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, self.contentSize/18.0 + self.contentLabel.bounds.size.height + GAP + i*(height + GAP), self.view.bounds.size.width/2.0 - height/2.0 - 40.0, height)];
            [self.view addSubview:exposureLabel];
            
            /* Exposure Day Label */
            [self setLabel:exposureLabel
                     title:key
                titleColor:[UIColor blackColor]
                      font:[UIFont fontWithName:@"Helvetica" size:15.0]
           backgroundColor:[UIColor clearColor]
             textAlignment:NSTextAlignmentLeft
             lineBreakMode:NSLineBreakByWordWrapping
                lineNumber:1];
        }
        
        /* Average Label */
        CGFloat averageLabelHeight = self.contentSize*(1/4.0) - self.contentSize/18.0 - 2*GAP;
        UIButton *averageButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2.0 - averageLabelHeight/2.0, self.contentSize*(5.0/8.0) + self.contentSize/18.0 + 2*GAP, averageLabelHeight, averageLabelHeight)];
        [self.view addSubview:averageButton];
        
        [self setButton:averageButton
                  title:[NSString stringWithFormat:@"%ld", self.average]
             titleColor:[UIColor blackColor]
                   font:[UIFont fontWithName:@"Helvetica" size:16.0]
        backgroundColor:[AirNowAPI aqColorForAQ:[AirNowAPI aqForAQI:[NSString stringWithFormat:@"%ld", self.average]]]
           cornerRadius:averageLabelHeight/2.0];
        
        /* Average Text Label */
        UILabel *averageLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, self.contentSize*(5.0/8.0) + self.contentSize/18.0 + 2*GAP, self.view.bounds.size.width/2.0 - averageLabelHeight/2.0 - 40.0, averageLabelHeight)];
        [self.view addSubview:averageLabel];
        
        [self setLabel:averageLabel
                 title:@"Average weekly AQI"
            titleColor:[UIColor blackColor]
                  font:[UIFont fontWithName:@"Helvetica" size:15.0]
       backgroundColor:[UIColor clearColor]
         textAlignment:NSTextAlignmentLeft
         lineBreakMode:NSLineBreakByWordWrapping
            lineNumber:5];
    }
    
    else
    {
        /* Content Label */
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.contentSize/18.0, self.view.bounds.size.width, self.contentSize/18.0)];
        [self.view addSubview:self.contentLabel];
        
        [self setLabel:self.contentLabel
                 title:self.content
            titleColor:[UIColor whiteColor]
                  font:[UIFont fontWithName:@"Helvetica-Bold" size:19.0]
       backgroundColor:[UIColor clearColor]
         textAlignment:NSTextAlignmentCenter
         lineBreakMode:NSLineBreakByWordWrapping
            lineNumber:1];
        
        
        /* Location Label */
        self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.contentSize/6.0, self.view.bounds.size.width, self.contentSize/12.0 + 10.0)];
        [self.view addSubview:self.locationLabel];
        
        [self setLabel:self.locationLabel
                 title:@""
            titleColor:[UIColor whiteColor]
                  font:[UIFont fontWithName:@"Helvetica-Bold" size:23.0]
       backgroundColor:[UIColor clearColor]
         textAlignment:NSTextAlignmentCenter
         lineBreakMode:NSLineBreakByWordWrapping
            lineNumber:2];
        
        
        /* AQI Button */
        self.aqiButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2.0 - self.contentSize/8.0, self.contentSize/3.0, self.contentSize/4.0, self.contentSize/4.0)];
        [self.view addSubview:self.aqiButton];

        [self setButton:self.aqiButton
                  title:@""
             titleColor:[UIColor clearColor]
                   font:[UIFont fontWithName:@"Helvetica-Bold" size:55.0]
        backgroundColor:[UIColor clearColor]
           cornerRadius:self.contentSize/8.0];
        
        [self.aqiButton addTarget:self action:@selector(showHealthInfo:) forControlEvents:UIControlEventTouchDown];
        
        
        /* Quality Label */
        self.qualityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, self.contentSize/3.0 + self.contentSize/4.0, self.view.bounds.size.width, self.contentSize/12.0)];
        [self.view addSubview:self.qualityLabel];

        [self setLabel:self.qualityLabel
                 title:@""
            titleColor:[UIColor whiteColor]
                  font:[UIFont fontWithName:@"Helvetica-Bold" size:23.0]
       backgroundColor:[UIColor clearColor]
         textAlignment:NSTextAlignmentCenter
         lineBreakMode:NSLineBreakByWordWrapping
            lineNumber:5];
    }
}

- (void)refreshAirQuality:(NSNotification *)notification
{
    [self getAirQuality];
}

- (void)getAirQuality
{
    /* Google Analytics Report */
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSString *identification = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).identification;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    NSURL *url;
    
    if (self.zipSearch && app.zipcode && [app.zipcode length] == 5)
    {
        NSLog(@"used zipcode");
        if ([self.content isEqualToString:AIR_NOW_TODAY]) {
            url = [AirNowAPI URLForZipcode:app.zipcode];
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:[NSString stringWithFormat:@"Show Today's Air Quality (%@)", app.zipcode] label:timestamp value:nil] build]];
        } else if ([self.content isEqualToString:AIR_NOW_TOMORROW_FORECAST])
            url = [AirNowAPI URLForDate:[[NSDate date] dateByAddingTimeInterval:SECONDS_DAY] forZipcode:app.zipcode];
    }
    
    else if (app.location && app.location && app.location)
    {
        NSLog(@"used location");
        if ([self.content isEqualToString:AIR_NOW_TODAY]) {
            url = [AirNowAPI URLForLatitute:app.location.coordinate.latitude forLongitude:app.location.coordinate.longitude];
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:[NSString stringWithFormat:@"Show Today's Air Quality (%f, %f)", app.location.coordinate.latitude, app.location.coordinate.longitude] label:timestamp value:nil] build]];
        } else if ([self.content isEqualToString:AIR_NOW_TOMORROW_FORECAST])
            url = [AirNowAPI URLForDate:[[NSDate date] dateByAddingTimeInterval:SECONDS_DAY] forLatitute:app.location.coordinate.latitude forLongitude:app.location.coordinate.longitude];
    }
    
    else
    {
        NSLog(@"used default");
        NSString *zipcode = @"90024"; // defaulted to: zipcode of UCLA
        
        if ([self.content isEqualToString:AIR_NOW_TODAY]) {
            url = [AirNowAPI URLForZipcode:zipcode];
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:@"Show Today's Air Quality (Default)" label:timestamp value:nil] build]];
        } else if ([self.content isEqualToString:AIR_NOW_TOMORROW_FORECAST])
            url = [AirNowAPI URLForDate:[[NSDate date] dateByAddingTimeInterval:SECONDS_DAY] forZipcode:zipcode];
    }
    
    dispatch_queue_t AirQueue = dispatch_queue_create("Air Queue", NULL);
    dispatch_async(AirQueue, ^{
    
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResults;
        NSError *error2;
        
        if (jsonResults) {
            
            propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:&error2];
            
            BOOL categoryExists = false;
            
            NSArray *category = [propertyListResults valueForKeyPath:AIR_NOW_RESULTS_CATEGORY_NAME];
            if (category && [category count] > 0) {
                categoryExists = true;
            }
            
            NSArray *aqi = [propertyListResults valueForKeyPath:AIR_NOW_RESULTS_AQI];
            NSNumber *max = [aqi valueForKeyPath:@"@max.intValue"];
            
            if ([max isEqualToNumber:[NSNumber numberWithInt:-1]] || [propertyListResults count] <= 0)
                max = [NSNumber numberWithInt:-1];
            
            NSArray *stateA = [propertyListResults valueForKeyPath:AIR_NOW_RESULTS_STATE_CODE];
            NSArray *locationA = [propertyListResults valueForKeyPath:AIR_NOW_RESULTS_AREA];
            NSString *state = [stateA firstObject];
            NSString *location = [locationA firstObject];
            
            NSString *maxString;
            if ([max isEqualToNumber:[NSNumber numberWithInteger:-1]] && !categoryExists)
                maxString = @"N/A";
            else if ([max isEqualToNumber:[NSNumber numberWithInteger:-1]] && categoryExists)
                maxString = @"";
            else
                maxString = [NSString stringWithFormat:@"%@", max];
            
            NSLog(@"max: %@", maxString);
            NSLog(@"state: %@", state);
            NSLog(@"location: %@", location);
            
            self.aqi = maxString;
            self.location = (state && location) ? [NSString stringWithFormat:@"%@, %@", location, state] : @"Unavailable";
            self.aq = [AirNowAPI aqForAQI:[NSString stringWithFormat:@"%@", max]];
            
        } else {
            
            self.aqi = @"N/A";
            self.location = @"Not Available";
            self.aq = AQUnavailable;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateDisplay];
        });
    });
}

- (void)setBackground
{
    NSString *imageName = [AirNowAPI aqImageNameForAQ:self.aq];
    
    UIGraphicsBeginImageContext(self.view.superview.superview.superview.superview.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:self.view.superview.superview.superview.superview.bounds];
    UIImage *bg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.bgImage = bg;
}

/* called each time view is loaded to update display */
- (void)updateDisplay
{
    self.locationLabel.text = self.location;
    [self.aqiButton setTitle: self.aqi forState:UIControlStateNormal];
    self.qualityLabel.text = [AirNowAPI aqQualityTitleForAQ:self.aq];
    [self.aqiButton setBackgroundColor:[AirNowAPI aqColorForAQ:self.aq]];
    [self.aqiButton setTitleColor:[AirNowAPI aqTextColorForAQ:self.aq] forState:UIControlStateNormal];
    [self setBackground];
    self.view.superview.superview.superview.superview.backgroundColor = [UIColor colorWithPatternImage:self.bgImage];
    
    /* Update Health Info Selection */
    HealthInfoTableViewController *vc = ((UINavigationController *)self.tabBarController.viewControllers[1]).viewControllers[0];
    AQAirQuality index = [AirNowAPI aqForAQI:self.aqi];
    if (index != AQUnavailable && index != AQHazardous) {
        if (vc.shouldDisplay && vc.displayIndex == index)
            return;
        [vc.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [vc.tableView.delegate tableView:vc.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
    } else {
        if (!vc.shouldDisplay)
            return;
        index = vc.displayIndex;
        [vc.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [vc.tableView.delegate tableView:vc.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
    }
}

/* IBAction to change tab */
- (IBAction)showHealthInfo:(UIButton *)sender
{
    self.tabBarController.selectedIndex = 1;
}

@end

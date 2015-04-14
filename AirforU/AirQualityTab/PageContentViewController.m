//
//  PageContentViewController.m
//  Air Quality
//
//  Created by QINGWEI on 2/28/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "PageContentViewController.h"
#import "HealthInfoTableViewController.h"
#import "ViewController.h"
#import "AirNowAPI.h"
#import "AppDelegate.h"

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

@end

@implementation PageContentViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    
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
    
    
    
    self.aqiButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2.0 - self.contentSize/8.0, self.contentSize/3.0, self.contentSize/4.0, self.contentSize/4.0)];
    [self.view addSubview:self.aqiButton];

    [self setButton:self.aqiButton
              title:@""
         titleColor:[UIColor clearColor]
               font:[UIFont fontWithName:@"Helvetica-Bold" size:55.0]
    backgroundColor:[UIColor clearColor]
       cornerRadius:self.contentSize/8.0];
    
    [self.aqiButton addTarget:self action:@selector(showHealthInfo:) forControlEvents:UIControlEventTouchDown];
    
    
    
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

- (void)getAirQuality
{
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    NSURL *url;

    if (app.zipcode && [app.zipcode length] == 5)
    {
        if ([self.content isEqualToString:AIR_NOW_TODAY])
            url = [AirNowAPI URLForZipcode:app.zipcode];
        else if ([self.content isEqualToString:AIR_NOW_TOMORROW_FORECAST])
            url = [AirNowAPI URLForDate:[[NSDate date] dateByAddingTimeInterval:SECONDS_DAY] forZipcode:app.zipcode];
    }
    
    else if (app.location && app.location.latitude && app.location.longitude)
    {
        if ([self.content isEqualToString:AIR_NOW_TODAY])
            url = [AirNowAPI URLForLatitute:app.location.latitude forLongitude:app.location.longitude];
        else if ([self.content isEqualToString:AIR_NOW_TOMORROW_FORECAST])
            url = [AirNowAPI URLForDate:[[NSDate date] dateByAddingTimeInterval:SECONDS_DAY] forLatitute:app.location.latitude forLongitude:app.location.longitude];
    }
    
    else
    {
        NSString *zipcode = @"90024"; // defaulted to: zipcode of UCLA
        
        if ([self.content isEqualToString:AIR_NOW_TODAY])
            url = [AirNowAPI URLForZipcode:zipcode];
        else if ([self.content isEqualToString:AIR_NOW_TOMORROW_FORECAST])
            url = [AirNowAPI URLForDate:[[NSDate date] dateByAddingTimeInterval:SECONDS_DAY] forZipcode:zipcode];
    }
    
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
    NSDictionary *propertyListResults;
    NSError *error2;
    
    if (jsonResults) {
        
        propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:&error2];
        
        BOOL categoryExists = false;
        
        NSArray *category = [propertyListResults valueForKeyPath:AIR_NOW_RESULTS_CATEGORY_NAME];
        NSString *categoryName = @"Unavailable";
        if (category && [category count] > 0) {
            categoryName = [AirNowAPI worstAQ:category];
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
}

/* IBAction to change tab */
- (IBAction)showHealthInfo:(UIButton *)sender
{
    UIColor *color = sender.backgroundColor;
    NSInteger index = [AirNowAPI aqIndexForColor:color];
    
    self.tabBarController.selectedIndex = 1;
    
    HealthInfoTableViewController *vc = ((UINavigationController *)self.tabBarController.selectedViewController).viewControllers[0];
    
    if (index != -1) {
        
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

@end

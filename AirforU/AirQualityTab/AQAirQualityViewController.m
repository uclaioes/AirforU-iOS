//
//  AQAirQualityViewController.m
//  AirforU
//
//  Created by Qingwei Lan on 6/20/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "AQAirQualityViewController.h"
#import "HealthInfoTableViewController.h"
#import "AppDelegate.h"
#import "AQUtilities.h"
#import "AQDimensions.h"

@interface AQAirQualityViewController ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *airQualityButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation AQAirQualityViewController
{
    NSString *m_location;
    NSString *m_aqi;
    NSString *m_description;
    AQAirQuality m_aq;
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AQPhoneType type = [AQDimensions phoneTypeForScreenHeight:self.view.bounds.size.height];
    self.contentLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:[AQDimensions sizeForContentLabelForPhoneType:type]];
    self.locationLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:[AQDimensions sizeForLocationLabelForPhoneType:type]];
    self.airQualityButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:[AQDimensions sizeForAQILabelForPhoneType:type]];
    self.descriptionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:[AQDimensions sizeForAirQualityDescriptionForPhoneType:type]];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.airQualityButton.layer.cornerRadius = self.airQualityButton.bounds.size.height/2.0;
    self.airQualityButton.titleLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Actions

- (void)getContent
{
    [super getContent];
    
    dispatch_queue_t AirQueue = dispatch_queue_create("Air Queue", NULL);
    dispatch_async(AirQueue, ^{
        NSArray *values = [((AppDelegate *)[[UIApplication sharedApplication] delegate]) getAirQualityWithContent:self.content];
        if (!values)
            return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            m_location = values[0];
            m_aqi = values[1];
            m_description = values[2];
            m_aq = [AQUtilities aqForAQI:m_aqi];
            [self updateDisplay];
        });
    });
}

- (void)setBackground
{
    NSString *imageName = [AQUtilities aqImageNameForAQ:m_aq];
    
    UIGraphicsBeginImageContext(self.view.superview.superview.superview.superview.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:self.view.superview.superview.superview.superview.bounds];
    UIImage *bg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.bgImage = bg;
}

- (void)updateDisplay
{
    [super updateDisplay];
    
    self.contentLabel.text = self.content;
    self.locationLabel.text = m_location;
    self.descriptionLabel.text = m_description;
    [self.airQualityButton setBackgroundColor:[AQUtilities aqColorForAQ:m_aq]];
    [self.airQualityButton setTitle:m_aqi forState:UIControlStateNormal];
    [self.airQualityButton setTitleColor:[AQUtilities aqTextColorForAQ:m_aq] forState:UIControlStateNormal];
    [self setBackground];
    self.view.superview.superview.superview.superview.backgroundColor = [UIColor colorWithPatternImage:self.bgImage];
    
    /* Update Health Info Selection */
    HealthInfoTableViewController *vc = ((UINavigationController *)self.tabBarController.viewControllers[1]).viewControllers[0];
    AQAirQuality index = [AQUtilities aqForAQI:m_aqi];
    if (index != AQUnavailable && index != AQHazardous) {
        if (vc.shouldDisplay && vc.displayIndex == index)
            return;
        [vc.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [vc.tableView.delegate tableView:vc.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
    } else {
        if (!vc.shouldDisplay)
            return;
        index = (AQAirQuality)vc.displayIndex;
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

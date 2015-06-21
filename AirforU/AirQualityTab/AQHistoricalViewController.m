//
//  AQHistoricalViewController.m
//  AirforU
//
//  Created by Qingwei Lan on 6/20/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "AQHistoricalViewController.h"
#import "AQDimensions.h"
#import "AQUtilities.h"

@interface AQHistoricalViewController ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageDescriptionLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *aqiButtons;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *dayLabels;

@end

@implementation AQHistoricalViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AQPhoneType type = [AQDimensions phoneTypeForScreenHeight:self.view.bounds.size.height];
    
    self.contentLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:[AQDimensions sizeForContentLabelForPhoneType:type]];
    self.averageLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:[AQDimensions sizeForAverageTextLabelForPhoneType:type]];
    self.averageButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:[AQDimensions sizeForLargeAQIForPhoneType:type]];
    self.disclaimerLabel.font = [UIFont fontWithName:@"Helvetica" size:[AQDimensions sizeForDisclaimerForPhoneType:type]];
    self.averageDescriptionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:[AQDimensions sizeForAverageAirQualityDescriptionForPhoneType:type]];
    
    for (UIButton *button in self.aqiButtons)
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:[AQDimensions sizeForSmallAQIForPhoneType:type]];
    for (UILabel *label in self.dayLabels)
        label.font = [UIFont fontWithName:@"Helvetica" size:[AQDimensions sizeForWeekdayLabelsForPhoneType:type]];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    for (UIButton *button in self.aqiButtons)
        button.layer.cornerRadius = button.bounds.size.height/2.0;
    
    self.averageButton.layer.cornerRadius = self.averageButton.bounds.size.height/2.0;
}

#pragma mark - Actions

- (void)getContent
{
    [super getContent];
    
    
}

- (void)updateDisplay
{
    [super updateDisplay];
    
    self.contentLabel.text = self.content;
    
//    for (UIButton *button in self.aqiButtons) {
//        button setBackgroundColor:[AQUtilities aqColorForAQ:[AQUtilities aqForAQI:<#(NSString *)#>]];
//    }
    
    NSLog(@"UPDATE DISPLAY IN HISTORICAL VC");
}

@end

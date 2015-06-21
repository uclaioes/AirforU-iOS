//
//  AQHistoricalViewController.m
//  AirforU
//
//  Created by Qingwei Lan on 6/20/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "AQHistoricalViewController.h"
#import "AppDelegate.h"
#import "AQDimensions.h"
#import "AQUtilities.h"
#import "HistoricalViewAPI.h"
#import "NSDate+AQHelper.h"

@interface AQHistoricalViewController ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UILabel *disclaimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageDescriptionLabel;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *aqiButtons;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *dayLabels;

@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) NSMutableArray *labels;

// fetched property
@property (nonatomic, strong) NSArray *history;

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
    
    for (UIButton *button in self.aqiButtons) {
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:[AQDimensions sizeForSmallAQIForPhoneType:type]];
        [self.buttons addObject:button];
    }
    for (UILabel *label in self.dayLabels) {
        label.font = [UIFont fontWithName:@"Helvetica" size:[AQDimensions sizeForWeekdayLabelsForPhoneType:type]];
        [self.labels addObject:label];
    }
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
    
    dispatch_queue_t HistoricalQueue = dispatch_queue_create("Historical Queue", NULL);
    dispatch_async(HistoricalQueue, ^{
        NSArray *values = [((AppDelegate *)[[UIApplication sharedApplication] delegate]) getAirQualityWithContent:AIR_NOW_TODAY];
        if (!values)
            return;
        
        NSString *station = values[3];

        NSURL *url = [HistoricalViewAPI urlForMonitoringStation:station];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data) {
            NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if (results) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.history = results;
                    [self updateDisplay];
                });
            }
        }
    });

}

- (void)updateDisplay
{
    [super updateDisplay];
    
    self.contentLabel.text = self.content;

    if (self.history.count > 7) {
        for (int i = 0; i < 6; i++) {
            NSInteger offset = [[self.history[i] valueForKey:@"offset"] integerValue];
            NSInteger value = [[self.history[i] valueForKey:@"value"] integerValue];
            NSString *aqi = [NSString stringWithFormat:@"%ld", value];
                        
            if (self.dayLabels && self.aqiButtons ) {
                
                UILabel *label = self.dayLabels[i];
                UIButton *button = self.aqiButtons[i];
                
                label.text = [[NSDate date] weekdayForOffset:offset];
                [button setTitle:aqi forState:UIControlStateNormal];
                
                [button setBackgroundColor:[AQUtilities aqColorForAQ:[AQUtilities aqForAQI:aqi]]];
            }
        }
        
        NSInteger average = [[self.history[6] valueForKey:@"value"] integerValue];
        NSString *averageAQI = [NSString stringWithFormat:@"%ld", average];
        
        [self.averageButton setTitle:averageAQI forState:UIControlStateNormal];
        [self.averageButton setBackgroundColor:[AQUtilities aqColorForAQ:[AQUtilities aqForAQI:averageAQI]]];
        self.averageDescriptionLabel.text = [AQUtilities aqQualityTitleForAQ:[AQUtilities aqForAQI:averageAQI]];
    }
}

- (NSMutableArray *)buttons
{
    if (!_buttons)
        _buttons = [[NSMutableArray alloc] initWithCapacity:0];
    return _buttons;
}

- (NSMutableArray *)labels
{
    if (!_labels)
        _labels = [[NSMutableArray alloc] initWithCapacity:0];
    return _labels;
}

@end

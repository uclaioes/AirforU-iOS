//
//  AQAirQualityViewController.m
//  AirforU
//
//  Created by Qingwei Lan on 6/20/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "AQAirQualityViewController.h"

@interface AQAirQualityViewController ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *airQualityButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation AQAirQualityViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    
}

#pragma mark - Actions

- (void)getContent
{
    [super getContent];
    
    NSLog(@"GET CONTENT IN AIR QUALITY VC");
}

- (void)updateDisplay
{
    [super updateDisplay];
    
    NSLog(@"UPDATE DISPLAY IN AIR QUALITY VC");
}

@end

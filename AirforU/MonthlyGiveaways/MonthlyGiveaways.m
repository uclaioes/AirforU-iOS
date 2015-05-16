//
//  MonthlyGiveaways.m
//  AirforU
//
//  Created by QINGWEI on 5/15/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "MonthlyGiveaways.h"
#import "AirNowAPI.h"

@interface MonthlyGiveaways ()

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *score;

@end

@implementation MonthlyGiveaways
{
    CGFloat totalHeight;
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.date = [NSDate date];
    
    /* Test */
    self.score = @"MEDIUM";

    totalHeight = self.view.frame.size.height - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - TOP_HEIGHT;
    CGFloat top = NAVIGATION_BAR_HEIGHT+TOP_HEIGHT;
    
    /* UI Setup */
    
    UILabel *prizeScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, top + totalHeight*(1/15.0), self.view.frame.size.width, totalHeight*(1/15.0))];
    [prizeScoreLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19.0]];
    [prizeScoreLabel setTextAlignment:NSTextAlignmentCenter];
    [prizeScoreLabel setText:@"Your daily score is:"];
    [prizeScoreLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:prizeScoreLabel];
    
    
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, top + totalHeight*(1/6.0), self.view.frame.size.width, totalHeight*(2/15.0))];
    [scoreLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:55.0]];
    [scoreLabel setTextAlignment:NSTextAlignmentCenter];
    [scoreLabel setText:self.score];
    [scoreLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:scoreLabel];
    
    
    UILabel *monthPrizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, top + totalHeight*(2/5.0), self.view.frame.size.width, totalHeight*(1/15.0))];
    [monthPrizeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19.0]];
    [monthPrizeLabel setTextAlignment:NSTextAlignmentCenter];
    [monthPrizeLabel setText:@"This month's prize is:"];
    [monthPrizeLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:monthPrizeLabel];
    
    
    UIImageView *prizeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card.jpg"]];
    [prizeImage setFrame:CGRectMake((self.view.frame.size.width/2.0) - totalHeight * (5/48.0), top + totalHeight*(1/2.0), totalHeight * (5/24.0), totalHeight * (2/15.0))];
    [self.view addSubview:prizeImage];
    
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0, top + totalHeight*(3/4.0), self.view.frame.size.width - 50.0, totalHeight*(1/6.0))];
    [textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setText:@"To increase your daily score, respond to the daily questions. Raffles will be conducted monthly among the top users."];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3]];
    [textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [textLabel setNumberOfLines:6];
    [self.view addSubview:textLabel];
    
    
    NSString *imageName = [AirNowAPI aqImageNameForAQ:AQGood];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:self.view.bounds];
    UIImage *bg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:bg];
}

@end

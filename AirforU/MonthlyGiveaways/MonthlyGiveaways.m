//
//  MonthlyGiveaways.m
//  AirforU
//
//  Created by QINGWEI on 5/15/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "MonthlyGiveaways.h"
#import "AQConstants.h"

@interface MonthlyGiveaways ()

@property (nonatomic, strong) NSDate *date;
@property (nonatomic) NSInteger score;
@property (nonatomic, strong) NSString *scoreName;

@property (nonatomic, strong) UILabel *scoreLabel;

@end

@implementation MonthlyGiveaways
{
    CGFloat totalHeight;
}

#pragma mark - View Controller Life Cycle

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.date = [NSDate date];
    
    /* Get score */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.score = [defaults integerForKey:@"currentScore"];
    self.scoreName = @"LOW";
    switch (self.score) {
        case 2: self.scoreName = @"MEDIUM"; break;
        case 3: self.scoreName = @"HIGH"; break;
        case 0:
        case 1:
        default: break;
    }

    totalHeight = self.view.frame.size.height - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - TOP_HEIGHT;
    CGFloat top = NAVIGATION_BAR_HEIGHT+TOP_HEIGHT;
    
    /* UI Setup */
    
    UILabel *prizeScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, top + totalHeight*(1/15.0), self.view.frame.size.width, totalHeight*(1/15.0))];
    [prizeScoreLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19.0]];
    [prizeScoreLabel setTextAlignment:NSTextAlignmentCenter];
    [prizeScoreLabel setText:@"Your daily score is:"];
    [prizeScoreLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:prizeScoreLabel];
    
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, top + totalHeight*(1/6.0), self.view.frame.size.width, totalHeight*(2/15.0))];
    [self.scoreLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:55.0]];
    [self.scoreLabel setTextAlignment:NSTextAlignmentCenter];
    [self.scoreLabel setText:self.scoreName];
    [self.scoreLabel setTextColor:[UIColor whiteColor]];
    [self.view addSubview:self.scoreLabel];
    
    
    UILabel *monthPrizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, top + totalHeight*(2/5.0), self.view.frame.size.width, totalHeight*(1/15.0))];
    [monthPrizeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19.0]];
    [monthPrizeLabel setTextAlignment:NSTextAlignmentCenter];
    [monthPrizeLabel setText:@"This month's prize is:"];
    [monthPrizeLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:monthPrizeLabel];
    
    
    UIImageView *prizeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card.jpg"]];
    [prizeImage setFrame:CGRectMake((self.view.frame.size.width/2.0) - totalHeight * (5/32.0), top + totalHeight*(1/2.0), totalHeight * (5/16.0), totalHeight * (1/5.0))];
    [self.view addSubview:prizeImage];
    
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(25.0, top + totalHeight*(3/4.0), self.view.frame.size.width - 50.0, totalHeight*(1/6.0))];
    [textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    [textLabel setText:@"To increase your score, respond to the daily questions. Raffles will be conducted monthly among the top users."];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3]];
    [textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [textLabel setNumberOfLines:6];
    [self.view addSubview:textLabel];
}

- (void)updateUI:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger newScore = [defaults integerForKey:@"currentScore"];
    if (newScore == self.score)
        return;
    self.score = newScore;
    switch (self.score) {
        case 2: self.scoreName = @"MEDIUM"; break;
        case 3: self.scoreName = @"HIGH"; break;
        case 0:
        case 1:
        default: break;
    }
    self.scoreLabel.text = self.scoreName;
}

@end

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

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *monthlyGift;

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

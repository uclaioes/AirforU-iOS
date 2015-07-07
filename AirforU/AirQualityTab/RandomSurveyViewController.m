//
//  RandomSurveyViewController.m
//  Air Quality
//
//  Created by QINGWEI on 3/4/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "RandomSurveyViewController.h"
#import "AQConstants.h"
#import "GASend.h"
#import "NSDate+AQHelper.h"
#import "AppDelegate.h"

@interface RandomSurveyViewController ()
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (nonatomic, strong) NSMutableArray *questions;
@property (nonatomic) NSInteger currentQuestion;
@end

@implementation RandomSurveyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.questionLabel.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    self.yesButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    self.noButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.questions = [[defaults objectForKey:@"questionNumbers"] mutableCopy];
    
    [self setQuestion];
}

- (NSMutableArray *)questions
{
    if (!_questions)
        _questions = [[NSMutableArray alloc] initWithCapacity:0];
    return _questions;
}

- (void)setQuestion
{
    NSString *question = @"";
    
    long rand;
    do {
        rand = arc4random() % 3;
    } while (![self.questions containsObject:[NSNumber numberWithInteger:rand]] &&
             [self.questions count] != 0);
    
    if ([self.questions count] == 0) {
        question = @"Thank you for your response! Check your score in the prizes tab.";
        [self.questionLabel setText:question];
        
        // set user defaults
        [self setUserDefaults];
        
        // set time to remove question view
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hide:) userInfo:nil repeats:NO];

        [self.yesButton removeFromSuperview];
        [self.noButton removeFromSuperview];
        
        return;
    }
    
    switch (rand)
    {
        case 0: question = @"Have you or will you engage in outdoor activity today?"; break;
        case 1: question = @"Did you or a household member have an asthma attack today?"; break;
        case 2: question = @"Did you talk to someone about air quality today?"; break;

        default: break;
    }
    self.currentQuestion = rand;
        
    [self.questionLabel setText:question];
}

- (IBAction)yesAnswer:(UIButton *)sender
{
    /* Update score in NSUserDefaults */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger score = [defaults integerForKey:@"currentScore"];
    score++;
    [defaults setInteger:score forKey:@"currentScore"];
    
    /* Google Analytics Report*/
    [GASend sendEventWithAction:[NSString stringWithFormat:@"BQ%ld (%@) (1)", (long)(self.currentQuestion+1), self.questionLabel.text]];
    [GASend sendEventWithAction:@"Score" withLabel:@"" withValue:1];
    
    [self.questions removeObject:[NSNumber numberWithInteger:self.currentQuestion]];
    [defaults setObject:self.questions forKey:@"questionNumbers"];
    [self setQuestion];
}

- (IBAction)noAnswer:(UIButton *)sender
{
    /* Update score in NSUserDefaults */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger score = [defaults integerForKey:@"currentScore"];
    score++;
    [defaults setInteger:score forKey:@"currentScore"];
    
    /* Google Analytics Report*/
    [GASend sendEventWithAction:[NSString stringWithFormat:@"BQ%ld (%@) (2)", (long)(self.currentQuestion+1), self.questionLabel.text]];
    [GASend sendEventWithAction:@"Score" withLabel:@"" withValue:1];
    
    [self.questions removeObject:[NSNumber numberWithInteger:self.currentQuestion]];
    [defaults setObject:self.questions forKey:@"questionNumbers"];
    [self setQuestion];
}

- (IBAction)hide:(id)sender
{
    [self.questionLabel removeFromSuperview];
}

- (void)setUserDefaults
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    NSInteger hour = [[formatter stringFromDate:[NSDate date]] integerValue];
    
    NSDate *date = [NSDate date];
    
    if (hour >= 0 && hour < 2)
        date = [date dateByAddingTimeInterval:-SECONDS_PER_DAY];
    
    NSString *dateString = [date dateID];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dateString forKey:BEHAVIORAL_QUESTION_DATE];
}

@end

//
//  RandomSurveyViewController.m
//  Air Quality
//
//  Created by QINGWEI on 3/4/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "RandomSurveyViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
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
    
    for (int i = 0; i < 4; i++)
        [self.questions addObject:[NSNumber numberWithInteger:i]];
    
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
    long rand;
    do {
        rand = arc4random() % 4;
    } while (![self.questions containsObject:[NSNumber numberWithInteger:rand]] &&
             [self.questions count] != 0);
    
    NSString *question = @"";
    
    if ([self.questions count] == 0) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *dateID = [[NSDate date] dateID];
        [defaults setValue:dateID forKey:@"behavioralQuestionDate"];
        
        question = @"Thank you for answering the questions.";
        [self.questionLabel setText:question];
        
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
        case 3: question = @"Did you seek additional information about air quality today?"; break;

        default: break;
    }
    self.currentQuestion = rand;
    [self.questionLabel setText:question];
}

- (IBAction)yesAnswer:(UIButton *)sender
{
    /* Google Analytics Report*/
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSString *identification = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).identification;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification
                                                          action:[NSString stringWithFormat:@"BQ%ld (%@) (1)", (long)(self.currentQuestion+1), self.questionLabel.text]
                                                           label:timestamp
                                                           value:nil] build]];
    
    [self.questions removeObject:[NSNumber numberWithInteger:self.currentQuestion]];
    [self setQuestion];
}

- (IBAction)noAnswer:(UIButton *)sender
{
    /* Google Analytics Report*/
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSString *identification = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).identification;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification
                                                          action:[NSString stringWithFormat:@"BQ%ld (%@) (2)", (long)(self.currentQuestion+1), self.questionLabel.text]
                                                           label:timestamp
                                                           value:[NSNumber numberWithInt:2]] build]];
    
    [self.questions removeObject:[NSNumber numberWithInteger:self.currentQuestion]];
    [self setQuestion];
}

- (IBAction)hide:(id)sender
{
    [self.questionLabel removeFromSuperview];
}

@end

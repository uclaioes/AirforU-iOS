//
//  QuestionTableViewController.m
//  Air Quality
//
//  Created by QINGWEI on 2/9/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "QuestionTableViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "AppDelegate.h"
#import "AirNowAPI.h"

@interface QuestionTableViewController ()
@property (nonatomic) BOOL warned;
@end

@implementation QuestionTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.warned = NO;
}

- (IBAction)next:(id)sender
{
    /* Google Analytics Initialize */
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSString *identification = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).identification;
    
    NSInteger questionNumber = [self.title integerValue];

    if (!self.warned) {
        self.warned = YES;
        NSString *answer = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).answers[questionNumber];
        if ([answer isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please respond to this question before moving on." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    if (questionNumber == 2) {
        
        NSString *answer = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).answers[2];
        if ([answer isEqualToString:@"1"]) {
            NSString *segueIdentifier = @"To Question 4";
            [self performSegueWithIdentifier:segueIdentifier sender:sender];
        } else if ([answer isEqualToString:@"2"] || [answer length] == 0) {
            
            /* Google Analytics Report*/
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification
                                                                  action:[NSString stringWithFormat:@"Q4 (%@)", [AirNowAPI intakeSurveyQuestionForQuestionNumber:4]]
                                                                   label:@"skp"
                                                                   value:nil] build]];
            
            NSString *segueIdentifier = @"Pass Question 4";
            [self performSegueWithIdentifier:segueIdentifier sender:sender];
        }
        
    } else if (questionNumber == 6) {
        
        NSString *answer = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).answers[6];
        if ([answer isEqualToString:@"1"]) {
            NSString *segueIdentifier = @"To Question 8";
            [self performSegueWithIdentifier:segueIdentifier sender:sender];
        } else if ([answer isEqualToString:@"2"] || [answer length] == 0) {
            
            /* Google Analytics Report*/
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification
                                                                  action:[NSString stringWithFormat:@"Q8 (%@)", [AirNowAPI intakeSurveyQuestionForQuestionNumber:8]]
                                                                   label:@"skp"
                                                                   value:nil] build]];
            
            NSString *segueIdentifier = @"Pass Question 8";
            [self performSegueWithIdentifier:segueIdentifier sender:sender];
        }
        
    } else {
        
        NSString *segueIdentifier = [NSString stringWithFormat:@"To Question %ld", (long)(questionNumber+2)];
        [self performSegueWithIdentifier:segueIdentifier sender:sender];
    }
    
    /* Google Analytics Report */
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification
                                                          action:[NSString stringWithFormat:@"Q%ld (%@)", (long)(questionNumber+1), [AirNowAPI intakeSurveyQuestionForQuestionNumber:questionNumber+1]]
                                                           label:[((AppDelegate *)[[UIApplication sharedApplication] delegate]).answers[questionNumber] isEqualToString:@""] ? @"?" : ((AppDelegate *)[[UIApplication sharedApplication] delegate]).answers[questionNumber]
                                                           value:nil] build]];
}

- (IBAction)submit:(id)sender
{
    NSInteger questionNumber = [self.title integerValue];
    
    if (!self.warned) {
        self.warned = YES;
        NSString *answer = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).answers[questionNumber];
        if ([answer isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please respond to this question before moving on." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    /* Google Analytics Initialize & Report */
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSString *identification = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).identification;
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification
                                                          action:[NSString stringWithFormat:@"Q%ld (%@)", (long)(questionNumber+1), [AirNowAPI intakeSurveyQuestionForQuestionNumber:questionNumber+1]]
                                                           label:[((AppDelegate *)[[UIApplication sharedApplication] delegate]).answers[questionNumber] isEqualToString:@""] ? @"?" : ((AppDelegate *)[[UIApplication sharedApplication] delegate]).answers[questionNumber]
                                                           value:nil] build]];
    
    NSLog(@"%@", ((AppDelegate *)[[UIApplication sharedApplication] delegate]).answers);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"hasBeenSurveyed"];
    
    NSLog(@"%@", [defaults stringForKey:@"zipcode"] ? [defaults stringForKey:@"zipcode"] : @"no zipcode entered");
    
    NSString *group;
    long rand = arc4random() % 2;
    switch (rand) {
        case 0: group = @"Control"; break;
        case 1: group = @"Treatment"; break;
        default: break;
    }
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification
                                                          action:@"Group"
                                                           label:group
                                                           value:nil] build]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewControllerDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger questionNumber = [self.title integerValue];
    
    if (!(questionNumber == 3) && !(questionNumber == 4)) {
        
        if (self.selectedIndex != NSNotFound) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        self.selectedIndex = indexPath.row;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).answers[questionNumber] = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        
        NSLog(@"%@", ((AppDelegate *)[[UIApplication sharedApplication] delegate]).answers);
        
    }
}

#pragma mark - Helper Methods

- (void)addAnswer:(NSString *)answer toAnswers:(NSString *)answers
{
    if (![answers containsString:answer]) {
        NSMutableString *mutableAnswers = [answers mutableCopy];
        [mutableAnswers appendString:answer];
        answers = mutableAnswers;
    }
}

- (void)deleteAnswer:(NSString *)answer fromAnswers:(NSString *)answers
{
    if ([answers containsString:answer]) {
        NSMutableString *mutableAnswers = [answers mutableCopy];
        NSRange answerRange = [answers rangeOfString:answer];
        [mutableAnswers deleteCharactersInRange:answerRange];
        answers = mutableAnswers;
    }
}

@end

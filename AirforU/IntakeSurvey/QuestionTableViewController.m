//
//  QuestionTableViewController.m
//  Air Quality
//
//  Created by QINGWEI on 2/9/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "QuestionTableViewController.h"
#import "GASend.h"
#import "AppDelegate.h"
#import "AQUtilities.h"

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
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];

    NSInteger questionNumber = [self.title integerValue];

    if (!self.warned) {
        self.warned = YES;
        NSString *answer = delegate.answers[questionNumber];
        if ([answer isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please respond to this question before moving on." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    if (questionNumber == 2) {
        
        NSString *answer = delegate.answers[2];
        if ([answer isEqualToString:@"1"]) {
            NSString *segueIdentifier = @"To Question 4";
            [self performSegueWithIdentifier:segueIdentifier sender:sender];
        } else if ([answer isEqualToString:@"2"] || [answer length] == 0) {
            
            /* Google Analytics Report */
            [GASend sendEventWithAction:[NSString stringWithFormat:@"Q4 (%@)", [AQUtilities intakeSurveyQuestionForQuestionNumber:4]] withLabel:@"N/A"];
            
            NSString *segueIdentifier = @"Pass Question 4";
            [self performSegueWithIdentifier:segueIdentifier sender:sender];
        }
        
    } else if (questionNumber == 6) {
        
        NSString *answer = delegate.answers[6];
        if ([answer isEqualToString:@"1"]) {
            NSString *segueIdentifier = @"To Question 8";
            [self performSegueWithIdentifier:segueIdentifier sender:sender];
        } else if ([answer isEqualToString:@"2"] || [answer length] == 0) {
            
            /* Google Analytics Repor t*/
            [GASend sendEventWithAction:[NSString stringWithFormat:@"Q8 (%@)", [AQUtilities intakeSurveyQuestionForQuestionNumber:8]] withLabel:@"N/A"];
            
            NSString *segueIdentifier = @"Pass Question 8";
            [self performSegueWithIdentifier:segueIdentifier sender:sender];
        }
        
    } else {
        
        NSString *segueIdentifier = [NSString stringWithFormat:@"To Question %ld", (long)(questionNumber+2)];
        [self performSegueWithIdentifier:segueIdentifier sender:sender];
    }
    
    /* Google Analytics Report */
    [GASend sendEventWithAction:[NSString stringWithFormat:@"Q%ld (%@)", (long)(questionNumber+1), [AQUtilities intakeSurveyQuestionForQuestionNumber:questionNumber+1]]
                      withLabel:[delegate.answers[questionNumber] isEqualToString:@""] ? @"?" : delegate.answers[questionNumber]];
}

- (IBAction)submit:(id)sender
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];

    NSInteger questionNumber = [self.title integerValue];
    
    if (!self.warned) {
        self.warned = YES;
        NSString *answer = delegate.answers[questionNumber];
        if ([answer isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please respond to this question before moving on." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
    /* Google Analytics Report */
    [GASend sendEventWithAction:[NSString stringWithFormat:@"Q%ld (%@)", (long)(questionNumber+1), [AQUtilities intakeSurveyQuestionForQuestionNumber:questionNumber+1]]
                      withLabel:[delegate.answers[questionNumber] isEqualToString:@""] ? @"?" : delegate.answers[questionNumber]];
    
    NSLog(@"%@", delegate.answers);
    
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
    
    [GASend sendEventWithAction:@"Group" withLabel:group];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewControllerDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSInteger questionNumber = [self.title integerValue];
    
    if (!(questionNumber == 3) && !(questionNumber == 4)) {
        
        if (self.selectedIndex != NSNotFound) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        self.selectedIndex = indexPath.row;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        delegate.answers[questionNumber] = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        
        NSLog(@"%@", delegate.answers);
        
    }
}

@end

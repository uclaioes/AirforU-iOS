//
//  LearnMoreTableViewController.m
//  Air Quality
//
//  Created by QINGWEI on 3/4/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "LearnMoreTableViewController.h"
#import "LearnMoreWebViewController.h"
#import "AirNowAPI.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "AppDelegate.h"

@interface LearnMoreTableViewController ()
@property (nonatomic) BOOL shouldDisplay;
@property (nonatomic) NSInteger displayIndex;
@end

@implementation LearnMoreTableViewController

#define CELL_IDENTIFIER_ORDINARY @"Ordinary Cell"
#define CELL_IDENTIFIER_FAQ_CELL @"FAQ Cell"
#define CELL_IDENTIFIER_FAQ_ANSWER_CELL @"FAQ Answer Cell"
#define CELL_IDENTIFIER_UCLA_HEALTH @"UCLA Health Cell"

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldDisplay = false;
    self.displayIndex = -1;
    
    self.tableView.separatorColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
}

#pragma mark - UITableViewControllerDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 11;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        case 1:
        case 3: return 1; break;
        case 2: return 5; break;
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        {
            if (self.shouldDisplay && self.displayIndex == section)
                return 2;
            return 1;
            break;
        }

        default: break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section)
    {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_ORDINARY];
            cell.textLabel.text = @"About Us";
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            break;
        }
            
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_ORDINARY];
            cell.textLabel.text = @"Contact Us";
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            break;
        }
            
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_FAQ_CELL];
                    cell.textLabel.text = @"Learn more about air pollution and your health";
                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                    cell.userInteractionEnabled = NO;
                    break;
                }
                case 1:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_ORDINARY];
                    cell.textLabel.text = @"     Environmental Protection Agency";
                    break;
                }
                case 2:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_ORDINARY];
                    cell.textLabel.text = @"     World Health Organization";
                    break;
                }
                case 3:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_ORDINARY];
                    cell.textLabel.text = @"     American Lung Association";
                    break;
                }
                case 4:
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_UCLA_HEALTH];
//                    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(37.0, 9.4, 120.0, 25.2)];
//                    img.image = [UIImage imageNamed:@"UCLA_HealthSystem_RGB.png"];
//                    [cell.contentView addSubview:img];
                    break;
                }
                    
                default: break;
            }
            break;
        }
            
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_FAQ_CELL];
            cell.textLabel.text = @"FAQs";
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            cell.userInteractionEnabled = NO;
            break;
        }
            
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        {
            if (self.shouldDisplay && self.displayIndex == indexPath.section && indexPath.row == 1)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_FAQ_ANSWER_CELL];
                cell.textLabel.text = [AirNowAPI faqAnswerForSection:indexPath.section];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
                cell.userInteractionEnabled = YES;
            }
            else if (indexPath.row == 0)
            {
                cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_FAQ_CELL];
                cell.textLabel.text = [AirNowAPI faqQuestionForSection:indexPath.section];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
                cell.userInteractionEnabled = YES;
            }
            
            break;
        }
            
        default: break;
    }
    
    if (cell) {
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    }
    
    return cell;
}

#pragma mark - UITableViewControllerDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* Google Analytics Initialize*/
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSString *identification = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).identification;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        /* Google Analytics Report */
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification
                                                              action:@"Show About Us"
                                                               label:timestamp
                                                               value:nil] build]];
        
        [self performSegueWithIdentifier:@"Show About Us" sender:self];
        return;
        
    } else if (indexPath.section == 1) {
        
        /* Google Analytics Report */
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification
                                                              action:@"Show Contact Us"
                                                               label:timestamp
                                                               value:nil] build]];
        
        [self performSegueWithIdentifier:@"Show Contact Us" sender:self];
        return;
        
    } else if (indexPath.section == 2) {
        
        NSString *label = @"";
        switch (indexPath.row) {
            case 1: label = @"EPA"; break;
            case 2: label = @"WHO"; break;
            case 3: label = @"ALA"; break;
            case 4: label = @"UCLA Health"; break;
            default: break;
        }
        
        if (![label isEqualToString:@""])
            /* Google Analytics Report */
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification
                                                                  action:[NSString stringWithFormat:@"Show %@", label]
                                                                   label:timestamp
                                                                   value:nil] build]];
        
        if (indexPath.row != 4) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [self performSegueWithIdentifier:@"Show Web View" sender:cell];
        } else {
            
        }
        
        return;
        
    } else if (indexPath.section >= 4 && indexPath.section <= 10) {
        
        NSUInteger index = indexPath.section - 3;
        
        if (self.shouldDisplay && self.displayIndex == indexPath.section) {
            self.shouldDisplay = NO;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:self.displayIndex] withRowAnimation:UITableViewRowAnimationFade];
        } else if (self.shouldDisplay && self.displayIndex != indexPath.section) {
            self.shouldDisplay = NO;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:self.displayIndex] withRowAnimation:UITableViewRowAnimationFade];
            
            /* Google Analytics Report */
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification
                                                                  action:[NSString stringWithFormat:@"Show FAQ%lu", (unsigned long)index]
                                                                   label:timestamp
                                                                   value:nil] build]];
            
            self.shouldDisplay = YES;
            self.displayIndex = indexPath.section;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:self.displayIndex] withRowAnimation:UITableViewRowAnimationFade];
        } else if (!self.shouldDisplay) {
            
            /* Google Analytics Report */
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification
                                                                  action:[NSString stringWithFormat:@"Show FAQ%lu", (unsigned long)index]
                                                                   label:timestamp
                                                                   value:nil] build]];
            
            self.shouldDisplay = YES;
            self.displayIndex = indexPath.section;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:self.displayIndex] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section >= 4 && section <= 10)
        return 0.01;
    return 24.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section >= 3 && section <= 10)
        return 0.001;
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 2 && indexPath.row == 0)
        return 56.0;
     else if (indexPath.section >= 4 && indexPath.section <= 10 && indexPath.row == 1)
        return 160.0;
    
    return 44.0;
}

#pragma mark - UINagivation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Web View"]) {
        NSString *title = ((UITableViewCell *)sender).textLabel.text;
        NSString *urlString = @"";
        if ([title containsString:@"Environmental Protection Agency"]) {
            urlString = @"http://www.epa.gov/region07/air/quality/health.htm";
        } else if ([title containsString:@"World Health Association"]) {
            urlString = @"http://www.who.int/mediacentre/factsheets/fs313/en/";
        } else if ([title containsString:@"American Lung Association"]) {
            urlString = @"http://www.lung.org/healthy-air/";
        }
        ((LearnMoreWebViewController *)segue.destinationViewController).nameOfWeb = title;
        ((LearnMoreWebViewController *)segue.destinationViewController).urlString = urlString;
    }
}

@end

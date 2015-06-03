//
//  HealthInfoTableViewController.m
//  Air Quality
//
//  Created by QINGWEI on 3/4/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "HealthInfoTableViewController.h"
#import "AQUtilities.h"
#import "AppDelegate.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"

@interface HealthInfoTableViewController()
@end

@implementation HealthInfoTableViewController

#define CELL_IDENTIFIER_DISPLAY @"Display Cell"
#define CELL_IDENTIFIER_EXTRA_DISPLAY @"Extra Display Cell"

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shouldDisplay = false;
    self.displayIndex = -1;
}

#pragma mark - UITableViewControllerDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.shouldDisplay)
        if (section == self.displayIndex)
            return 2;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (self.shouldDisplay && indexPath.section == self.displayIndex && indexPath.row == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_EXTRA_DISPLAY];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0]];
        NSString *detail = [AQUtilities aqPreventionDetailForAQ:(AQAirQuality)indexPath.section];
        cell.textLabel.text = detail;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_DISPLAY];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0]];
        NSString *title = [NSString stringWithFormat:@"%@ %@", [AQUtilities aqQualityTitleForAQ:(AQAirQuality)indexPath.section],
                           [AQUtilities aqRangeForAQ:(AQAirQuality)indexPath.section]];
        cell.textLabel.text = title;
    }
    
    if (cell) {
        cell.textLabel.numberOfLines = 7;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.contentView.backgroundColor = [AQUtilities aqColorForAQ:(AQAirQuality)indexPath.section];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
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
    
    if (self.shouldDisplay && self.displayIndex == indexPath.section)
    {
        self.shouldDisplay = NO;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:self.displayIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (self.shouldDisplay && self.displayIndex != indexPath.section)
    {
        self.shouldDisplay = NO;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:self.displayIndex] withRowAnimation:UITableViewRowAnimationFade];
        
        /* Google Analytics Report */
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification
                                                              action:[NSString stringWithFormat:@"Show Health Info %d", (indexPath.section+1)]
                                                               label:timestamp
                                                               value:nil] build]];
        
        self.shouldDisplay = YES;
        self.displayIndex = indexPath.section;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:self.displayIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (!self.shouldDisplay)
    {
        /* Google Analytics Report */
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification
                                                             action:[NSString stringWithFormat:@"Show Health Info %d", (indexPath.section+1)]
                                                               label:timestamp
                                                               value:nil] build]];
        
        self.shouldDisplay = YES;
        self.displayIndex = indexPath.section;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:self.displayIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 64.0;
    } else if (indexPath.row == 1) {
        return 120.0;
    }
    
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

@end

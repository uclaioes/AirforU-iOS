/*!
 * @name        HealthInfoTableViewController.m
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import "HealthInfoTableViewController.h"
#import "AQUtilities.h"
#import "GASend.h"

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
        NSString *detail = [AQUtilities aqPreventionDetailForAQ:(AQAirQuality)(indexPath.section+1)];
        cell.textLabel.text = detail;
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER_DISPLAY];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0]];
        NSString *title = [NSString stringWithFormat:@"%@ %@", [AQUtilities aqQualityTitleForAQ:(AQAirQuality)(indexPath.section+1)],
                           [AQUtilities aqRangeForAQ:(AQAirQuality)(indexPath.section+1)]];
        cell.textLabel.text = title;
    }
    
    if (cell) {
        cell.textLabel.numberOfLines = 7;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.contentView.backgroundColor = [AQUtilities aqColorForAQ:(AQAirQuality)(indexPath.section+1)];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}

#pragma mark - UITableViewControllerDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        [GASend sendEventWithAction:[NSString stringWithFormat:@"Show Health Info %ld", (long)(indexPath.section+1)]];
        
        self.shouldDisplay = YES;
        self.displayIndex = indexPath.section;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:self.displayIndex] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (!self.shouldDisplay)
    {
        /* Google Analytics Report */
        [GASend sendEventWithAction:[NSString stringWithFormat:@"Show Health Info %ld", (long)(indexPath.section+1)]];
        
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

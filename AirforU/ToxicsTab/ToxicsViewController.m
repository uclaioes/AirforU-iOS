//
//  ToxicsViewController.m
//  Air Quality
//
//  Created by QINGWEI on 3/4/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "ToxicsViewController.h"
#import "FacilityCell.h"
#import "AppDelegate.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"

@interface ToxicsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UILabel *facilitiesTitle;

@property (nonatomic, strong) NSArray *results;

@end

@implementation ToxicsViewController
{
    NSString *zipcode;
    BOOL shouldZipSearch;
}

#pragma mark - View Controller Life Cycle

#define TOXICS_KEY_NAME @"name"
#define TOXICS_KEY_TOTAL_RELEASES @"total_releases"
#define TOXICS_KEY_DISTANCE @"distance"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchField.delegate = self;
    [self.searchField setKeyboardType:UIKeyboardTypeNumberPad];
    
    /* Add Toolbar to keyboard */
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50.0)];
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.items = @[[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)],
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(search:)]];
    [toolBar sizeToFit];
    self.searchField.inputAccessoryView = toolBar;
    
    [self fetchCurrentResults];
}

#pragma mark - Actions

- (void)fetchCurrentResults
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSURL *url;
    if (shouldZipSearch && zipcode) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://engage.environment.ucla.edu/airforu_tri.php?zip=%@", zipcode]];
        self.facilitiesTitle.text = [NSString stringWithFormat:@"  Nearest facilities for %@", zipcode];
    } else if (delegate.latitude && delegate.longitude) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://engage.environment.ucla.edu/airforu_tri.php?lat=%f&long=%f", delegate.latitude, delegate.longitude]];
        self.facilitiesTitle.text = @"  Nearest facilities";
    } else {
        url = [NSURL URLWithString:@"http://engage.environment.ucla.edu/airforu_tri.php?zip=90024"];
        self.facilitiesTitle.text = @"  Nearest facilities for 90024";
    }
    
    dispatch_queue_t ToxicsQueue = dispatch_queue_create("ToxicsQueue", NULL);
    dispatch_async(ToxicsQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data) {
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if (arr) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.results = arr;
                    NSLog(@"%@", self.results);
                    [self.tableView reloadData];
                });
            }
        }
    });
}

- (void)cancel:(UIBarButtonItem *)sender
{
    self.searchField.text = @"";
    [self.searchField resignFirstResponder];
}

- (void)search:(UIBarButtonItem *)sender
{
    if ([self.searchField.text length] != 5) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Format!" message:@"The zipcode should be a 5-digit number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        zipcode = self.searchField.text;
        /* Google Analytics Report*/
        id tracker = [[GAI sharedInstance] defaultTracker];
        NSString *identification = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).identification;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *timestamp = [formatter stringFromDate:[NSDate date]];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification
                                                              action:[NSString stringWithFormat:@"Search Facilities Zipcode (%@)", zipcode]
                                                               label:timestamp value:nil] build]];
        shouldZipSearch = YES;
        [self fetchCurrentResults];
    }
    
    self.searchField.text = @"";
    [self.searchField resignFirstResponder];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.results.count > 5 ? 5 : self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Facility Cell";
    FacilityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    NSDictionary *dict = self.results[indexPath.row];
    
    /* Set cell properties */
    cell.nameLabel.text = [NSString stringWithFormat:@"%ld. %@", indexPath.row+1, [dict valueForKeyPath:TOXICS_KEY_NAME]];
    
    NSString *distance = [dict valueForKeyPath:TOXICS_KEY_DISTANCE];
    if (!distance)
        distance = @"?";
    else {
        double dis = [distance doubleValue];
        dis += 0.5;
        long cast = (long)dis;
        distance = [NSString stringWithFormat:@"%ld", cast];
    }
    
    NSString *releases = [dict valueForKeyPath:TOXICS_KEY_TOTAL_RELEASES];
    if (!releases)
        releases = @"?";
    else {
        double rls = [releases doubleValue];
        rls += 0.5;
        long cast = (long)rls;
        releases = [NSString stringWithFormat:@"%ld", cast];
    }
    
    cell.distanceLabel.text = [NSString stringWithFormat:@"Distance: %@ mi",  distance];
    cell.releaseLabel.text = [NSString stringWithFormat:@"Chemical Release (lbs): %@", releases];
    
    return cell;
}

@end

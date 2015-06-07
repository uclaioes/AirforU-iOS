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

@interface ToxicsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

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
    
    
//    NSURL *url = [NSURL URLWithString:@"http://engage.environment.ucla.edu/airforu_tri.php?lat=34.072&long=-118.444"];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    [self fetchCurrentResults];
    
}

#pragma mark - Actions

- (void)fetchCurrentResults
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSURL *url;
    if (shouldZipSearch && zipcode)
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://engage.environment.ucla.edu/airforu_tri.php?zip=%@", zipcode]];
    else if (delegate.latitude && delegate.longitude)
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://engage.environment.ucla.edu/airforu_tri.php?lat=%f&long=%f", delegate.latitude, delegate.longitude]];
    else
        url = [NSURL URLWithString:@"http://engage.environment.ucla.edu/airforu_tri.php?zip=90024"];
    
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
    /* TODO: Implement Search */
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
    cell.nameLabel.text = [dict valueForKeyPath:TOXICS_KEY_NAME];
    NSString *distance = [dict valueForKeyPath:TOXICS_KEY_DISTANCE];
    if (!distance)
        distance = @"?";
    else {
        double dis = [distance doubleValue];
        dis += 0.5;
        long cast = (long)dis;
        distance = [NSString stringWithFormat:@"%ld", cast];
    }
    cell.distanceLabel.text = [NSString stringWithFormat:@"Distance: %@ mi",  distance];
    cell.releaseLabel.text = [NSString stringWithFormat:@"Chemical Release (lbs): %@", [dict valueForKeyPath:TOXICS_KEY_TOTAL_RELEASES]];
    
    return cell;
}

@end

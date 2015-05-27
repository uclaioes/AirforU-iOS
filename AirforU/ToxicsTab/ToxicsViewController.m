//
//  ToxicsViewController.m
//  Air Quality
//
//  Created by QINGWEI on 3/4/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "ToxicsViewController.h"
#import "FacilityCell.h"

@interface ToxicsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ToxicsViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Facility Cell";
    
    FacilityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    /* Set cell properties */
    cell.nameLabel.text = @"1. UCLA";
    cell.distanceLabel.text = @"Distance: 50 mi";
    cell.releaseLabel.text = @"Chemical Release (lbs): 32";
    
    return cell;
}

#pragma mark - UITableViewDelegate

@end

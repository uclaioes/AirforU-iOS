//
//  ToxicsViewController.m
//  Air Quality
//
//  Created by QINGWEI on 3/4/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "ToxicsViewController.h"
#import "FacilityCell.h"

@interface ToxicsViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

@end

@implementation ToxicsViewController

#pragma mark - View Controller Life Cycle

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
}

#pragma mark - Actions

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

//
//  AQBaseViewController.m
//  AirforU
//
//  Created by Qingwei Lan on 6/20/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "AQBaseViewController.h"

@interface AQBaseViewController ()

@end

@implementation AQBaseViewController

#pragma mark - View Controller Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateDisplay];
}

#pragma mark - Actions

- (void)getContent
{
    NSLog(@"GET CONTENT IN BASE");
}

- (void)updateDisplay
{
    NSLog(@"UPDATE DISPLAY IN BASE");
}

@end

//
//  ToxicsViewController.m
//  Air Quality
//
//  Created by QINGWEI on 3/4/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "ToxicsViewController.h"

@interface ToxicsViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *mapWebView;
@end

@implementation ToxicsViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *calEcoMaps = @"http://www.environment.ucla.edu/ccep/calecomaps/";
    NSURL *calEcoMapsURL = [NSURL URLWithString:calEcoMaps];
    NSURLRequest *request = [NSURLRequest requestWithURL:calEcoMapsURL];
    [self.mapWebView loadRequest:request];
}

@end
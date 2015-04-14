//
//  LearnMoreWebViewController.m
//  Air Quality
//
//  Created by QINGWEI on 3/8/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "LearnMoreWebViewController.h"
#import "GAI.h"
#import "AppDelegate.h"
#import "GAIDictionaryBuilder.h"

@interface LearnMoreWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation LearnMoreWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [self.nameOfWeb substringFromIndex:5];
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

@end

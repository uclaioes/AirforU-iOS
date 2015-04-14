//
//  LicenseAgreementViewController.m
//  Air Quality
//
//  Created by QINGWEI on 2/9/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "LicenseAgreementViewController.h"

@interface LicenseAgreementViewController()
@property (weak, nonatomic) IBOutlet UITextView *licenseView;
@end

@implementation LicenseAgreementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.licenseView scrollRangeToVisible:NSMakeRange(0, 0)];
}

- (IBAction)disagree:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Accept License Agreement." message:@"You must accept the terms and conditions to proceed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end

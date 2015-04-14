//
//  BackgroundViewController.m
//  Air Quality
//
//  Created by QINGWEI on 3/14/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "BackgroundViewController.h"

@implementation BackgroundViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"good_background.png"] drawInRect:self.view.bounds];
    UIImage *bg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:bg];
}

@end

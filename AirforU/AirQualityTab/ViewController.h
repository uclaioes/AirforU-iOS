//
//  ViewController.h
//  Air Quality
//
//  Created by QINGWEI on 2/28/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface ViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

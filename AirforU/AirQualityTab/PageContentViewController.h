//
//  PageContentViewController.h
//  Air Quality
//
//  Created by QINGWEI on 2/28/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (nonatomic, strong) NSString *content; // either "today", "todayForecast", "tomorrowForecast"
@property NSUInteger pageIndex;
@property (nonatomic) CGFloat contentSize;

// Air Quality Properties

@property (nonatomic, strong) UIImage *bgImage;

- (void)getAirQuality;
- (void)updateDisplay;

//@property (nonatomic) BOOL zipSearch;

@end

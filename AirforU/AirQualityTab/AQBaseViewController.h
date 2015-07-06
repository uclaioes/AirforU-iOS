//
//  AQBaseViewController.h
//  AirforU
//
//  Created by Qingwei Lan on 6/20/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AQBaseViewController : UIViewController

@property (nonatomic, strong) NSString *content; // either "Today's Air Quality", "Tomorrow's Forecast", "Last Week AQI"
@property NSUInteger pageIndex;

- (void)getContent;
- (void)updateDisplay;

@end

//
//  QuestionTableViewController.h
//  Air Quality
//
//  Created by QINGWEI on 2/9/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewController : UITableViewController

@property (nonatomic) NSUInteger selectedIndex;

- (IBAction)next:(id)sender;
- (IBAction)submit:(id)sender;

@end

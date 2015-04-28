//
//  ViewController.m
//  Air Quality
//
//  Created by QINGWEI on 2/28/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "ViewController.h"
#import "AirNowAPI.h"
#import "LicenseAgreementViewController.h"
#import "AppDelegate.h"
#import "RandomSurveyViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAI.h"
#import "NSDate+AQHelper.h"

@interface ViewController ()

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *pages;
@property (nonatomic, strong) NSMutableArray *pageContents; // contains PageContentViewControllers
@property (nonatomic, strong) UITextField *zipcode;
@property (nonatomic) CGFloat totalHeight;
@end

@implementation ViewController

#pragma mark - View Controller Life Cycle

#define SEARCH_TEXT_WIDTH 90.0
#define SEARCH_TEXT_HEIGHT 30.0

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.totalHeight = self.view.frame.size.height - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT - TOP_HEIGHT;
    
	// Create the data model
    self.date = [NSDate date];
    self.pages = @[AIR_NOW_TODAY, AIR_NOW_TOMORROW_FORECAST];
    [self createPageContentsWithZipSearch:NO];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT + TOP_HEIGHT, self.view.frame.size.width, self.totalHeight*(2.0/3.0));
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    NSString *imageName = [AirNowAPI aqImageNameForAQ:AQGood];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:self.view.bounds];
    UIImage *bg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:bg];
    self.pageViewController.view.backgroundColor = [UIColor clearColor];
    
    [self addSurvey];
    
    self.zipcode = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - SEARCH_TEXT_WIDTH - 20.0, self.totalHeight/3.0 + TOP_HEIGHT + NAVIGATION_BAR_HEIGHT, SEARCH_TEXT_WIDTH, SEARCH_TEXT_HEIGHT)];
    self.zipcode.placeholder = @"Search Zip";
    self.zipcode.textAlignment = NSTextAlignmentRight;
    [self.zipcode setKeyboardType:UIKeyboardTypeNumberPad];
    self.zipcode.textColor = [UIColor whiteColor];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, 60.0)];
    toolbar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *zipcodeLabel = [[UIBarButtonItem alloc] initWithTitle:@"Please enter 5-digit zipcode" style:UIBarButtonItemStyleDone target:nil action:nil];
    zipcodeLabel.enabled = NO;

    toolbar.items = [NSArray arrayWithObjects:
                     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(cancelSearch:)],
                     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                     zipcodeLabel,
                     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                     [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(startSearch:)],
                     nil];
    [toolbar sizeToFit];
    self.zipcode.inputAccessoryView = toolbar;
    
    [self.view addSubview:self.zipcode];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pages count] == 0) || (index >= [self.pages count]))
        return nil;
    
    PageContentViewController *vc = [self.pageContents objectAtIndex:index];
    
    return vc;
}

#pragma mark - UITextFieldDelegate

- (IBAction)cancelSearch:(id)sender
{
    [self.zipcode resignFirstResponder];
    self.zipcode.text = @"";
}

- (IBAction)startSearch:(id)sender
{
    if ([self.zipcode.text length] != 5) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Format!" message:@"The zipcode should be a 5-digit number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        
        NSNumber *zip = [NSNumber numberWithDouble:[self.zipcode.text integerValue]];
        
        /* Google Analytics Report*/
        id tracker = [[GAI sharedInstance] defaultTracker];
        NSString *identification = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).identification;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *timestamp = [formatter stringFromDate:[NSDate date]];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification
                                                              action:[NSString stringWithFormat:@"Search Zipcode (%@)", zip]
                                                               label:timestamp
                                                               value:nil] build]];
        
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).zipcode = self.zipcode.text;
        [self.zipcode resignFirstResponder];
        [self reloadPageController];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound))
        return nil;
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound)
        return nil;
    
    index++;
    if (index == [self.pages count])
        return nil;
    
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if (finished && completed) {
        [((PageContentViewController *)pageViewController.viewControllers[0]) updateDisplay];
        UIImage *im = ((PageContentViewController *)pageViewController.viewControllers[0]).bgImage;
        self.view.backgroundColor = [UIColor colorWithPatternImage:im];
        
        /* Google Analytics Report */
        id tracker = [[GAI sharedInstance] defaultTracker];
        NSString *identification = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).identification;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        NSString *timestamp = [formatter stringFromDate:[NSDate date]];
        NSString *content = [self.pages objectAtIndex:((PageContentViewController *)pageViewController.viewControllers[0]).pageIndex];
        
        if ([content containsString:@"Today's Air Quality"])
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:@"Show Today's Air Quality" label:timestamp value:nil] build]];
        else if ([content containsString:@"Tomorrow's Forecast"])
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:@"Show Tomorrow's Forecast" label:timestamp value:nil] build]];
    }
}

#pragma mark - Ordinary Methods

- (void)reloadPageController
{
    [self.pageViewController removeFromParentViewController];
    [self.pageViewController.view removeFromSuperview];
    
    [self.pageContents removeAllObjects];
    [self createPageContentsWithZipSearch:YES];
    [self.pageViewController setViewControllers:@[[self viewControllerAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.view bringSubviewToFront:self.zipcode];
}

- (void)createPageContentsWithZipSearch:(BOOL)zipsearch
{
    for (int i = 0; i < 2; i++)
    {
        // Create a new view controller and pass suitable data.
        PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
        pageContentViewController.content = self.pages[i];
        pageContentViewController.contentSize = self.totalHeight;
        pageContentViewController.pageIndex = i;
        pageContentViewController.zipSearch = zipsearch;
        [self.pageContents addObject:pageContentViewController];
        if (zipsearch) {
            [pageContentViewController getAirQuality];
        }
    }
}

- (void)addSurvey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *date = [defaults stringForKey:@"behavioralQuestionDate"];
    if ([date isEqualToString:[[NSDate date] dateID]])
        return;
    
    RandomSurveyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Random Survey"];
    vc.view.frame = CGRectMake(0.0, NAVIGATION_BAR_HEIGHT + TOP_HEIGHT + self.totalHeight*(2.0/3.0 + 1.0/24.0), self.view.frame.size.width, self.totalHeight*(1.0/3.0 - 2.0/24.0));
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}

- (NSMutableArray *)pageContents
{
    if (!_pageContents)
        _pageContents = [[NSMutableArray alloc] initWithCapacity:0];
    return _pageContents;
}

@end

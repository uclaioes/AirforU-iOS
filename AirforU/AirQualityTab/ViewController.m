/*!
 * @name        ViewController.m
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import "ViewController.h"
#import "AQUtilities.h"
#import "AQBaseViewController.h"
#import "AQAirQualityViewController.h"
#import "GoogleGeocodingAPI.h"
#import "LicenseAgreementViewController.h"
#import "AppDelegate.h"
#import "RandomSurveyViewController.h"
#import "GASend.h"
#import "NSDate+AQHelper.h"
#import "NSString+Helper.h"

@interface ViewController () <UISearchBarDelegate>

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSArray *pages;
@property (nonatomic, strong) NSMutableArray *pageContents; // contains PageContentViewControllers
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) RandomSurveyViewController *survey;

@end

@implementation ViewController
{
    AppDelegate *delegate;
}

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    delegate = [[UIApplication sharedApplication] delegate];
    
	// Create the data model
    self.date = [NSDate date];
    self.pages = @[AIR_NOW_HISTORY, AIR_NOW_TODAY, AIR_NOW_TOMORROW_FORECAST];
    [self createPageContentsWithZipSearch:NO withCitySearch:NO];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    AQBaseViewController *startingViewController = [self viewControllerAtIndex:1];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.pageViewController didMoveToParentViewController:self];
    
    NSString *imageName = [AQUtilities aqImageNameForAQ:AQGood];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:imageName] drawInRect:self.view.bounds];
    UIImage *bg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:bg];
    self.pageViewController.view.backgroundColor = [UIColor clearColor];

    [self initRightBarButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [self.view addSubview:self.pageViewController.view];

    // Add the UIPageControl
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 10, self.view.bounds.size.width, 0)];
        [self.view addSubview:self.pageControl];
        self.pageControl.numberOfPages = 3;
        self.pageControl.currentPage = ((AQBaseViewController *)self.pageViewController.viewControllers[0]).pageIndex;
        self.pageControl.userInteractionEnabled = NO;
    }
    [[UIPageControl appearance] setBounds:CGRectMake(0, 0, self.view.frame.size.width, 10.0)];
    
    /* Add random survey */
    [self.survey.view removeFromSuperview];
    if (self.pageControl.currentPage != 0) {
        if (self.survey) {
            [self.view addSubview:self.survey.view];
        } else {
            [self addSurvey];
        }
    }
}

- (AQBaseViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pages count] == 0) || (index >= [self.pages count]))
        return nil;
    
    AQBaseViewController *vc = [self.pageContents objectAtIndex:index];
    
    return vc;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self startSearch];
    [self.searchController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (void)startSearch
{
    if ([self.searchController.searchBar.text isAllDigits]) {
        if ([self.searchController.searchBar.text length] != 5) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Format!" message:@"The zipcode should be a 5-digit number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            NSString *zipcode = self.searchController.searchBar.text;
            /* Google Analytics Report*/
            [GASend sendEventWithAction:[NSString stringWithFormat:@"Search Zipcode (%@)", zipcode]];
            delegate.zipcode = zipcode;
            [self reloadPageControllerWithZipSearch:YES withCitySearch:NO];
        }
    } else {
        delegate.city = self.searchController.searchBar.text;
        /* Google Analytics Report*/
        [GASend sendEventWithAction:[NSString stringWithFormat:@"Search City (%@)", delegate.city]];
        [self reloadPageControllerWithZipSearch:NO withCitySearch:YES];
    }
}

- (void)initRightBarButtons
{
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch:)];
    searchButton.style = UIBarButtonSystemItemDone;
    searchButton.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *locationButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LocationIcon@3x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(showCurrentLocation:)];
    locationButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItems = @[locationButton, searchButton];
}

- (IBAction)showSearch:(UIBarButtonItem *)sender
{
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Enter city name or zipcode";
    
    self.searchController.searchBar.delegate = self;
    
    [self presentViewController:self.searchController animated:YES completion:nil];
}

- (IBAction)showCurrentLocation:(UIBarButtonItem *)sender
{
    [self reloadPageControllerWithZipSearch:NO withCitySearch:NO];
}

- (void)reloadPageControllerWithZipSearch:(BOOL)zipSearch withCitySearch:(BOOL)citySearch
{
    [self.survey.view removeFromSuperview];
    
    NSInteger index = self.pageControl.currentPage;
    [self.pageViewController removeFromParentViewController];
    [self.pageViewController.view removeFromSuperview];
    
    [self.pageContents removeAllObjects];
    
    [self createPageContentsWithZipSearch:zipSearch withCitySearch:citySearch];
    
    [self.pageViewController setViewControllers:@[[self viewControllerAtIndex:index]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    self.pageControl.currentPage = index;
    
    [self addSurvey];
}

- (void)createPageContentsWithZipSearch:(BOOL)zipsearch withCitySearch:(BOOL)citySearch
{
    delegate.shouldZipSearch = zipsearch;
    delegate.shouldCitySearch = citySearch;
    
    AQBaseViewController *historicalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Historical View"];
    historicalVC.content = self.pages[0];
    historicalVC.pageIndex = 0;
    [historicalVC getContent];
    [self.pageContents addObject:historicalVC];
    
    for (int i = 1; i < 3; i++)
    {
        // Create a new view controller and pass suitable data.
        AQBaseViewController *airQualityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Air Quality"];
        airQualityVC.content = self.pages[i];
        airQualityVC.pageIndex = i;
        
        [self.pageContents addObject:airQualityVC];
        [airQualityVC getContent];
    }
}

- (void)addSurvey
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    NSString *hourString = [formatter stringFromDate:[NSDate date]];
    NSInteger hour = [hourString integerValue];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *date = [defaults stringForKey:BEHAVIORAL_QUESTION_DATE];

    if (hour >= 0 && hour < 2) {
        if ([date isEqualToString:[[[NSDate date] dateByAddingTimeInterval:-SECONDS_PER_DAY] dateID]]) {
            return;
        }
    } else if (hour >= 2 && hour < 16) {
        return;
    } else {
        if ([date isEqualToString:[[NSDate date] dateID]]) {
            return;
        }
    }
    
    if (self.survey && self.survey.view.superview) {
        return;
    }
    
    if (self.pageControl.currentPage == 0) {
        return;
    }
    
    if (self.survey) {
        [self.view addSubview:self.survey.view];
        return;
    }
    
    /* Reset score in NSUserDefaults */
    NSString *refreshDate = [defaults stringForKey:REFRESH_DATE];
    
    if (![refreshDate isEqualToString:[[NSDate date] dateID]]) {
        if (hour >= 2) {
            [defaults setInteger:0 forKey:@"currentScore"];
            [defaults setObject:[[NSDate date] dateID] forKey:REFRESH_DATE];
        }
    }
    
    NSArray *questionNumbers = @[[NSNumber numberWithInt:0],
                                 [NSNumber numberWithInt:1],
                                 [NSNumber numberWithInt:2]];
    
    [defaults setObject:questionNumbers forKey:@"questionNumbers"];
    
    _survey = [self.storyboard instantiateViewControllerWithIdentifier:@"Random Survey"];
    self.survey.view.frame = CGRectMake(0.0, self.view.bounds.size.height * (17.0/24), self.view.frame.size.width, self.view.bounds.size.height * (1.0/4));
    
    [self addChildViewController:self.survey];
    [self.view addSubview:self.survey.view];
    [self.survey didMoveToParentViewController:self];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((AQBaseViewController *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound))
        return nil;
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((AQBaseViewController *) viewController).pageIndex;
    
    if (index == NSNotFound)
        return nil;
    
    index++;
    if (index == [self.pages count])
        return nil;
    
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    AQBaseViewController *vc = [pendingViewControllers firstObject];
    if ([vc.content isEqualToString:AIR_NOW_HISTORY]) {
        if (self.survey && self.survey.view.superview) {
            [self.survey.view removeFromSuperview];
        }
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed
{
    if (finished) {
        AQBaseViewController *vc = pageViewController.viewControllers[0];
        self.pageControl.currentPage = vc.pageIndex;
        [vc updateDisplay];
        if ([vc isKindOfClass:[AQAirQualityViewController class]]) {
            AQAirQualityViewController *avc = (AQAirQualityViewController *)vc;
            UIImage *im = avc.bgImage;
            self.view.backgroundColor = [UIColor colorWithPatternImage:im];
            [self addSurvey];
        }
        
        /* Google Analytics Report */
        [GASend sendEventWithAction:[NSString stringWithFormat:@"Show %@", vc.content]];
    }
}

#pragma mark - Ordinary Methods

- (NSMutableArray *)pageContents
{
    if (!_pageContents)
        _pageContents = [[NSMutableArray alloc] initWithCapacity:0];
    return _pageContents;
}

@end

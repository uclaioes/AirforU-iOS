/*!
 * @name        AQBaseViewController.h
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import <UIKit/UIKit.h>

@interface AQBaseViewController : UIViewController

@property (nonatomic, strong) NSString *content; // either "Today's Air Quality", "Tomorrow's Forecast", "Last Week AQI"
@property NSUInteger pageIndex;

- (void)getContent;
- (void)updateDisplay;

@end

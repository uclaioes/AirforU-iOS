/*!
 * @name        QuestionTableViewController.h
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import <UIKit/UIKit.h>

@interface QuestionTableViewController : UITableViewController

@property (nonatomic) NSUInteger selectedIndex;

- (IBAction)next:(id)sender;
- (IBAction)submit:(id)sender;

@end

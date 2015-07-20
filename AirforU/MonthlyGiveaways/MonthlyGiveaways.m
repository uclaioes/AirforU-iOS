/*!
 * @name        MonthlyGiveaways.m
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import "MonthlyGiveaways.h"
#import "AQConstants.h"

@interface MonthlyGiveaways ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *monthlyGift;

@end

@implementation MonthlyGiveaways

#pragma mark - View Controller Life Cycle

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI:nil];
}

- (void)updateUI:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger score = [defaults integerForKey:@"currentScore"];
    NSString *scoreName = @"LOW";
    switch (score) {
        case 2: scoreName = @"MEDIUM"; break;
        case 3: scoreName = @"HIGH"; break;
        default: break;
    }
    self.scoreLabel.text = scoreName;
}

@end

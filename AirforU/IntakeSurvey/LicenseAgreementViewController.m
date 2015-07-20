/*!
 * @name        LicenseAgreementViewController.m
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import "LicenseAgreementViewController.h"

@interface LicenseAgreementViewController()
@property (weak, nonatomic) IBOutlet UITextView *licenseView;
@end

@implementation LicenseAgreementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.licenseView scrollRangeToVisible:NSMakeRange(0, 0)];
}

- (IBAction)disagree:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Accept License Agreement." message:@"You must accept the terms and conditions to proceed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end

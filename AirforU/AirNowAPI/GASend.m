/*!
 * @name        GASend.m
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import "GASend.h"

@interface GASend ()

@end

@implementation GASend

+ (void)sendEventWithAction:(NSString *)action
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *identification = [defaults objectForKey:@"identification"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    
    if (identification)
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:action label:timestamp value:nil] build]];
}

+ (void)sendEventWithAction:(NSString *)action withLabel:(NSString *)label
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *identification = [defaults objectForKey:@"identification"];
    
    if (identification)
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:action label:label value:nil] build]];
}

+ (void)sendEventWithAction:(NSString *)action withLabel:(NSString *)label withValue:(int)value
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *identification = [defaults objectForKey:@"identification"];
    
    if (identification)
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:identification action:action label:label value:[NSNumber numberWithInt:value]] build]];
}

@end

/*!
 * @name        HistoricalViewAPI.m
 * @version     1.1
 * @copyright   Qingwei Lan (qingweilandeveloper@gmail.com) 2015
 */

#import "HistoricalViewAPI.h"

@interface HistoricalViewAPI ()

@end

@implementation HistoricalViewAPI

+ (NSURL *)urlForMonitoringStation:(NSString *)station
{
    NSString *urlString = [NSString stringWithFormat:@"http://engage.environment.ucla.edu/airforu_get_histo.php?location=%@", station];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:urlString];
}

@end

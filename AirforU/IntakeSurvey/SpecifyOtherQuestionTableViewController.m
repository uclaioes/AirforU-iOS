//
//  SpecifyOtherQuestionTableViewController.m
//  Air Quality
//
//  Created by QINGWEI on 2/12/15.
//  Copyright (c) 2015 QINGWEI LAN. All rights reserved.
//

#import "SpecifyOtherQuestionTableViewController.h"
#import "AppDelegate.h"

@interface SpecifyOtherQuestionTableViewController () <UITextFieldDelegate>

@end

@implementation SpecifyOtherQuestionTableViewController

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSInteger questionNumber = [self.title integerValue];

    if (questionNumber == 3 || questionNumber == 4) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            if (indexPath.row == 6) {
                UITableViewCell *nCell = [self tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:indexPath.section]];
                if ([((UIView *)nCell.subviews[0]).subviews[0] isFirstResponder])
                    [((UIView *)nCell.subviews[0]).subviews[0] resignFirstResponder];
                ((UITextView *)((UIView *)nCell.subviews[0]).subviews[0]).text = @"";
            }
            
            NSString *answer = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
            NSMutableString *mutableAnswers = [delegate.answers[questionNumber] mutableCopy];
            if ([mutableAnswers containsString:answer]) {
                NSRange startRange = [mutableAnswers rangeOfString:answer];
                NSRange endRange = [mutableAnswers rangeOfString:@"]"];
                NSRange range;
                range.location = startRange.location;
                if (endRange.length != 0) {
                    range.length = endRange.location - startRange.location + 1;
                } else  {
                    range.length = startRange.length;
                }
                [mutableAnswers deleteCharactersInRange:range];
            }
            delegate.answers[questionNumber] = mutableAnswers;
            NSLog(@"%@", delegate.answers);
            
        } else if (cell.accessoryType == UITableViewCellAccessoryNone) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            if (indexPath.row == 6) {
                UITableViewCell *nCell = [self tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:indexPath.section]];
                [((UIView *)nCell.subviews[0]).subviews[0] becomeFirstResponder];
            }
            
            NSString *answer = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
            NSMutableString *mutableAnswers = [delegate.answers[questionNumber] mutableCopy];
            if (![mutableAnswers containsString:answer])
                [mutableAnswers appendString:answer];
            delegate.answers[questionNumber] = mutableAnswers;
            NSLog(@"%@", delegate.answers);
            
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        return YES;
    }
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSInteger questionNumber = [self.title integerValue];
    NSString *tempAnswer = delegate.answers[questionNumber];
    NSRange rangeOfOtherBegin = [tempAnswer rangeOfString:@"6"];
    NSRange rangeOfOtherEnd = [tempAnswer rangeOfString:@"]"];
    
    NSString *curAnswer = textField.text;
    
    if (rangeOfOtherBegin.length > 0 && rangeOfOtherEnd.length > 0) {
        
        NSRange range;
        range.location = rangeOfOtherBegin.location;
        range.length = rangeOfOtherEnd.location - rangeOfOtherBegin.location + 1;
        
        tempAnswer = [tempAnswer stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"6:[%@]", curAnswer]];
        delegate.answers[questionNumber] = tempAnswer;
        
    } else {
        
        tempAnswer = [tempAnswer stringByReplacingCharactersInRange:rangeOfOtherBegin withString:[NSString stringWithFormat:@"6:[%@]", curAnswer]];
        delegate.answers[questionNumber] = tempAnswer;
        
    }
    
    [textField resignFirstResponder];
    
    NSLog(@"%@", delegate.answers);
    
    return YES;
}

@end

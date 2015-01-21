//
//  Utilities.m
//  Sortr
//
//  Created by KrisMraz on 8/6/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "Utilities.h"
#import "Constants.h"
#import "SSCheckBoxView.h"
#import "UIHelpers.h"

@implementation Utilities

+(NSString *)documentsPath:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+(NSString *)getPresentDateTime{
    
    NSDateFormatter *dateTimeFormat = [[NSDateFormatter alloc] init];
    [dateTimeFormat setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *theDateTime = [dateTimeFormat stringFromDate:now];
    
    dateTimeFormat = nil;
    now = nil;
    
    return theDateTime;
}

#pragma mark CREATE SHOW/HIDE UIACTIVITYINDICATOR
+(void)showActivityIndicator:(UIViewController*)sender
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIView *_view = [[UIView alloc] initWithFrame:rect];
    UIActivityIndicatorView *_indicator = [[UIActivityIndicatorView alloc] initWithFrame:_view.frame];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(rect.size.width/2 - 50, rect.size.height/2 + 10, 100, 40)];
    [label setText:@"Please wait..."];
    [label setFont:[UIFont fontWithName:@"DIN Alternate" size:18]];
    [label setTextColor:SORTR_ORANGE];
                     
    [_view setBackgroundColor:[UIColor whiteColor]];
    [_view.layer setOpacity:0.75f];
    
    [_indicator setTransform:CGAffineTransformMakeScale(1.5f, 1.5f)];
    [_indicator setColor:SORTR_ORANGE];
    
    [_indicator startAnimating];
    [_view addSubview:_indicator];
    [_view addSubview:label];

    [_view setTag:ACTIVITY_INDICATOR_VIEW_TAG];
    
    UIViewController *senderView = (UIViewController*)sender;
    [senderView.view addSubview:_view];
}


+(void)hideActivityIndicator:(UIViewController*)sender
{
    for (UIView *v in [sender.view subviews]) {
        if ( [v tag] == ACTIVITY_INDICATOR_VIEW_TAG )
        {
            [v removeFromSuperview];
        }
    }
}

#pragma mark CREATE UIDATEPICKER
+ (UIDatePicker*) getDatePickerComponent
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.frame = CGRectMake(0, frame.size.height - 200, frame.size.width, 200);
    datePicker.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9f];
    
    return datePicker;
}


#pragma mark CREATE SSCHECKBOXVIEW
+ ( SSCheckBoxView *) getCheckBoxComponent: (CGRect) pframe
{
    SSCheckBoxView *cbv = nil;
    CGRect frame = pframe;
    SSCheckBoxViewStyle style =  4 ;
    BOOL checked = YES;
    
    cbv = [[SSCheckBoxView alloc] initWithFrame:frame
                                         style:style
                                       checked:checked];
    
    return cbv;
}


#pragma mark COnnection
+ (BOOL) isConnectedToInternet
{
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]];
    return ( URLString != NULL ) ? YES : NO;
}


#pragma mark UIALERTVIEW
+ (void) showAlertViewWithTitle:(NSString*) title andMessage:(NSString*) message
{
    UIAlertView *alv = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    
    [alv show];
} 

@end

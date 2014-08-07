//
//  Utilities.m
//  Sortr
//
//  Created by KrisMraz on 8/6/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "Utilities.h"
#import "Constants.h"

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


+(void)showActivityIndicator:(UIViewController*)sender
{
    UIView *_view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIActivityIndicatorView *_indicator = [[UIActivityIndicatorView alloc] initWithFrame:_view.frame];
    
    [_view setBackgroundColor:[UIColor blackColor]];
    [_view.layer setOpacity:0.75f];
    
    [_indicator setTransform:CGAffineTransformMakeScale(1.5f, 1.5f)];
    
    [_indicator startAnimating];
    [_view addSubview:_indicator];

    [_view setTag:ACTIVITY_INDICATOR_VIEW_TAG];
    
    UIViewController *senderView = (UIViewController*)sender;
    [senderView.view addSubview:_view];
}

@end

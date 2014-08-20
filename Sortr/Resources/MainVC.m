//
//  MainVC.m
//  testProject
//
//  Created by artur on 2/14/14.
//  Copyright (c) 2014 artur. All rights reserved.
//

#import "MainVC.h"
#import "LeftMenuTVC.h"
#import "RightMenuTVC.h"
#import "Constants.h"

@interface MainVC ()

@end

@implementation MainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
   /*******************************
    *     Initializing menus
    *******************************/
    self.leftMenu   = [[LeftMenuTVC alloc] initWithNibName:@"LeftMenuTVC" bundle:nil];
    self.rightMenu  = [[RightMenuTVC alloc] initWithNibName:@"RightMenuTVC" bundle:nil];
    
   /*******************************
    *     End Initializing menus
    *******************************/

    [super viewDidLoad];
    
	// COLOR NAVIGATION BAR BLUE 
    [[UINavigationBar appearance] setTintColor:SORTR_BLUE];
}

#pragma mark - Overriding methods
- (void)configureLeftMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0,0};
    frame.size = (CGSize){40,40};
    button.frame = frame;
    
    [button setImage:[UIImage imageNamed:@"LeftMenu"] forState:UIControlStateNormal];
}

- (void)configureRightMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0,0};
    frame.size = (CGSize){45,40};
    button.frame = frame;
    
    [button setImage:[UIImage imageNamed:@"RightMenu"] forState:UIControlStateNormal];
}

- (BOOL)deepnessForLeftMenu
{
    return NO;
}

- (CGFloat)maxDarknessWhileRightMenu
{
    return 0.5f;
}

@end

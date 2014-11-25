//
//  ExportSettingsVC.m
//  Sortr
//
//  Created by KrisMraz on 8/8/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "ExportSettingsVC.h"
#import "Utilities.h"
#import "SSCheckBoxView.h"

@interface ExportSettingsVC ()
{
    UIButton *selectedDateBtn;
}
@end

@implementation ExportSettingsVC

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
    [super viewDidLoad];
    [ self addCheckBoxes ];
    
    _mDatePickerComponent.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addCheckBoxes
{
    SSCheckBoxView *csvcb = [Utilities getCheckBoxComponent:_mCsvCheckbox.frame];
    SSCheckBoxView *pdfcb = [Utilities getCheckBoxComponent:_mPdfCheckbox.frame];
    
    [self.view addSubview:csvcb];
    [self.view addSubview:pdfcb];
}

- (IBAction)showDatePicker:(id)sender {

    _mDatePickerView.backgroundColor = [UIColor clearColor];
     _mDatePickerView.frame = CGRectOffset(self.navigationController.view.frame, 0, self.navigationController.view.frame.size.height);
    
    selectedDateBtn = (UIButton*)sender;
    
    [self.navigationController.view addSubview:_mDatePickerView];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _mDatePickerView.frame = self.navigationController.view.frame;
        
    } completion:^(BOOL finished) {
        
        self.navigationController.view.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.3 animations:^{
            
            _mDatePickerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
            
        } completion:^(BOOL finished) {
            
        }];
    }];
}

-(void)dismissDateSelectionViewOnCompletion:(void(^)(void))block {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _mDatePickerView.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _mDatePickerView.frame = CGRectOffset(self.navigationController.view.frame, 0, self.navigationController.view.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            [_mDatePickerView removeFromSuperview];
            
            if (block)
                block();
        }];
    }];
}


- (IBAction)dateDonePressed:(id)sender {
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM/dd/yyyy"];
    
    
    [self dismissDateSelectionViewOnCompletion:^{
        
        [selectedDateBtn setTitle:[format stringFromDate:_mDatePickerComponent.date] forState:UIControlStateNormal];
        
    }];;
}
- (IBAction)dateCancelPressed:(id)sender {
    
    [self dismissDateSelectionViewOnCompletion:nil];
}


@end

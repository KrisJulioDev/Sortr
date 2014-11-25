//
//  ExportSettingsVC.h
//  Sortr
//
//  Created by KrisMraz on 8/8/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExportSettingsVC : UIViewController
@property (weak, nonatomic)     IBOutlet UIButton *m_fromDateBtn;
@property (strong, nonatomic)   IBOutlet UIView *mDatePickerView;
@property (weak, nonatomic)     IBOutlet UIDatePicker *mDatePickerComponent;

@property (weak, nonatomic) IBOutlet UIButton *mCsvCheckbox;
@property (weak, nonatomic) IBOutlet UIButton *mPdfCheckbox;



@end

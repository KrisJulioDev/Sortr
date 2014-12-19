//
//  SortrSettingsViewController.h
//  Sortr
//
//  Created by KrisMraz on 12/17/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryPicker.h"

@interface SortrSettingsViewController : UIViewController <CountryPickerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *countryName;
@property (strong, nonatomic) IBOutlet UILabel *countryCode;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UITextField *categoryField;
@property (strong, nonatomic) IBOutlet CountryPicker *countryPicker;

@end

//
//  SortrSettingsViewController.m
//  Sortr
//
//  Created by KrisMraz on 12/17/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "SortrSettingsViewController.h"
#import "SavedSettings.h"

@interface SortrSettingsViewController () <UITextFieldDelegate>

@end

@implementation SortrSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.countryName.text = [SavedSettings settingsCountryName];
    self.countryCode.text = [SavedSettings settingsCountryCode];
    
    
    
    [self.categoryField setDelegate:self];
    [self.categoryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"QWEQ %@", [[NSUserDefaults standardUserDefaults] objectForKey:kSavedCountryCode]);
    [self.countryPicker setSelectedCountryCode:[[NSUserDefaults standardUserDefaults] objectForKey:kSavedCountryCode] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)countryPicker:(__unused CountryPicker *)picker didSelectCountryWithName:(NSString *)name code:(NSString *)code
{
    self.countryName.text = name;
    self.countryCode.text = code;
    
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:kSavedCountryName];
    [[NSUserDefaults standardUserDefaults] setObject:code forKey:kSavedCountryCode];
}

- (IBAction)doneSettings:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addCategory:(id)sender {
    if (_categoryField.text.length > 0) {
        
        [[SortrDataManager sharedInstance] saveCategoryWithName:_categoryField.text];
        
        self.categoryField.text = @"";
        
    } else
    {
        UIAlertView *alc = [[UIAlertView alloc] initWithTitle:@"Field Empty" message:@"Category field empty" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [alc show];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

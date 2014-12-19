//
//  AddClientViewController.m
//  Sortr
//
//  Created by KrisMraz on 12/18/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "AddClientViewController.h"

@interface AddClientViewController () <UITextFieldDelegate>

@end

@implementation AddClientViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.addPhoneTF.delegate   = self;
    self.clientNameTF.delegate = self;
    self.addressTF.delegate    = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addContact:(id)sender {
    [[SortrDataManager sharedInstance] saveClientWithName:_clientNameTF.text address:_addressTF.text andPhone:_addPhoneTF.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end

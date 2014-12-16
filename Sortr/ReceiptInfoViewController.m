//
//  ReceiptInfoViewController.m
//  Sortr
//
//  Created by KrisMraz on 12/10/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "ReceiptInfoViewController.h"

@interface ReceiptInfoViewController ()

@end

@implementation ReceiptInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [self.receiptImage setImage: [UIImage imageWithData:self.receiptData.image]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

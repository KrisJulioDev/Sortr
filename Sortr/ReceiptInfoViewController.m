//
//  ReceiptInfoViewController.m
//  Sortr
//
//  Created by KrisMraz on 12/10/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "ReceiptInfoViewController.h"

#import "ActionSheetCustomPickerDelegate.h"
#import "ActionSheetLocalePicker.h"
#import "ActionSheetStringPicker.h"
#import "AddClientViewController.h"
#import <pop/POP.h>


@interface ReceiptInfoViewController ()  <UIGestureRecognizerDelegate>
{
    NSMutableArray *clients;
}
@end

@implementation ReceiptInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.receiptPreviewHolder setHidden:YES];
    [self.receiptImage setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *receiptPreview = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewReceiptImage:)];
    receiptPreview.numberOfTapsRequired = 1;
    receiptPreview.delegate = self;
    
    [self.receiptImage addGestureRecognizer:receiptPreview];
    
    [self.receiptImage setImage: [UIImage imageWithData:self.receiptData.image]];
    [self.receiptPreview setImage: [UIImage imageWithData:self.receiptData.image]];
    
    self.receiptPreviewHolder.layer.borderColor = [UIColor orangeColor].CGColor;
    self.receiptPreviewHolder.layer.borderWidth = 2;
    self.receiptPreviewHolder.layer.cornerRadius = 10;
    
    self.clientNameBtn.layer.cornerRadius = 5;
    
    clients = [NSMutableArray new];
    for (ClientObject *c in [[SortrDataManager sharedInstance] getAllClients]) {
        [clients addObject:c.name];
    }
    
    [self displayData];
}

- (void) displayData {

    NSTimeInterval utcEpoc = [self.receiptData.date doubleValue] / 1000;
    NSDate *eDate = [[NSDate alloc] initWithTimeIntervalSince1970:utcEpoc];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd, yyyy"];
    
    NSString *dateString = [formatter stringFromDate:eDate];
    
    self.headerTotal.text = [NSString stringWithFormat:@"TOTAL : P%@", self.receiptData.total ];
    self.totalAmount.text = [NSString stringWithFormat:@"%@", self.receiptData.total ];

    self.receiptName.text = [NSString stringWithFormat:@"%@", self.receiptData.branch ];
    self.receiptDate.text = [NSString stringWithFormat:@"%@", dateString ];
    self.vatValue.text     = [NSString stringWithFormat:@"%@", self.receiptData.vat ];
//    self.clientName.text   = self.receiptData.client;
    self.categoryName.text = self.receiptData.category;
    [self.clientNameBtn setTitle:self.receiptData.client forState:UIControlStateNormal];
}


- (void) viewDidAppear:(BOOL)animated {
    
    [clients removeAllObjects];
    for (ClientObject *c in [[SortrDataManager sharedInstance] getAllClients]) {
        [clients addObject:c.name];
    }

}

- (IBAction)setClient:(id)sender {
    
    if (clients.count > 0 ) {
        
        [ActionSheetStringPicker showPickerWithTitle:@"Select Client" rows:clients initialSelection:0 target:self successAction:@selector(clientAdded:element:) cancelAction:nil origin:sender];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Add client problem" message:@"You don't have any client" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Client", nil];
        av.tag = 001;
        [av show];
    }
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 001) {
        if (buttonIndex != 0) {
            
            AddClientViewController *acv = [[AddClientViewController alloc] init];
            [self presentViewController:acv animated:YES completion:nil];
            
        }
        
    }
}

- (void)clientAdded:(NSNumber *)selectedIndex element:(id)element
{
    NSString * clientSelected = [clients objectAtIndex:[selectedIndex intValue]];
    [self.clientNameBtn setTitle:clientSelected forState:UIControlStateNormal];
    
    [[SortrDataManager sharedInstance] updateReceipt:_receiptData.receiptId withOfficialID:_receiptData.receiptId category:_receiptData.category withTotal:_receiptData.total vat:_receiptData.vat branch:_receiptData.branch receiptDate:_receiptData.date clientName:clientSelected receiptStatus:_receiptData.receiptStatus];
}

- (void) previewReceiptImage : (UITapGestureRecognizer *)tap {
    [self.receiptPreviewHolder setHidden:NO];
}

- (IBAction)closePreview:(id)sender {
    [self.receiptPreviewHolder setHidden:YES];
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

//
//  ReceiptInfoViewController.h
//  Sortr
//
//  Created by KrisMraz on 12/10/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiptData.h"
#import "SortrDataManager.h"

@interface ReceiptInfoViewController : UIViewController

@property (nonatomic, retain) ReceiptObject *receiptData;

//UI PROPERTIES
@property (strong, nonatomic) IBOutlet UIButton *addTaxBtn;
@property (strong, nonatomic) IBOutlet UILabel *receiptName;
@property (strong, nonatomic) IBOutlet UIImageView *receiptImage;
@property (strong, nonatomic) IBOutlet UIImageView *receiptPreview;
@property (strong, nonatomic) IBOutlet UIView *receiptPreviewHolder;

@property (strong, nonatomic) IBOutlet UILabel *headerTotal;
@property (strong, nonatomic) IBOutlet UILabel *totalAmount;
@property (strong, nonatomic) IBOutlet UILabel *storeName;
@property (strong, nonatomic) IBOutlet UILabel *receiptDate;
@property (strong, nonatomic) IBOutlet UILabel *vatValue;
@property (strong, nonatomic) IBOutlet UILabel *comment; 
@property (strong, nonatomic) IBOutlet UILabel *categoryName;
@property (strong, nonatomic) IBOutlet UIButton *clientNameBtn;

@end
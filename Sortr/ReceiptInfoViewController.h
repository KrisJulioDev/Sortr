//
//  ReceiptInfoViewController.h
//  Sortr
//
//  Created by KrisMraz on 12/10/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiptData.h"

@interface ReceiptInfoViewController : UIViewController

@property (nonatomic, retain) ReceiptData *receiptData;

//UI PROPERTIES
@property (strong, nonatomic) IBOutlet UIButton *addTaxBtn;
@property (strong, nonatomic) IBOutlet UILabel *receiptName;
@property (strong, nonatomic) IBOutlet UIImageView *receiptImage;


@end

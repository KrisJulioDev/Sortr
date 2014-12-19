//
//  CategoryViewController.h
//  Sortr
//
//  Created by KrisMraz on 12/10/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseObject.h"

@interface CategoryViewController : UIViewController

@property (strong, nonatomic) IBOutlet UICollectionView *photoContainer;
@property (strong, nonatomic) IBOutlet UITableView      *receiptTable;

@property (nonatomic        ) NSInteger             *categoryIndex;
@property (nonatomic        ) NSString              *title;
@property (nonatomic, retain) NSMutableArray        *categoryItems;

//LABELS
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UIButton *scanBtn;

- (void) receiptHTTPClient : (int) r_id didUpdateWithStatus : ( NSDictionary *) dic;
- (void) exportReceiptCallback : (id) sender success: (ResponseObject *) responseObject;
- (void) exportReceiptCallback : (id) sender failed: (NSError *) error;
@end
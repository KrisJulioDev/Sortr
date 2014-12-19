//
//  InvoiceVC.h
//  Sortr
//
//  Created by KrisMraz on 8/7/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvoiceVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *invoiceTableView;
@property (weak, nonatomic) IBOutlet UIButton *mHumanTabBtn;
@property (weak, nonatomic) IBOutlet UIButton *mGalleryTabBtn;
@property (weak, nonatomic) IBOutlet UIButton *mEmailTabBtn;
@property (weak, nonatomic) IBOutlet UIButton *mExportTabBtn;
@property (nonatomic, retain) NSManagedObjectContext *mManagedContext;
@property (strong, nonatomic) id delegate;

#pragma mark Header Properties
@property (strong, nonatomic) IBOutlet UILabel *headerTotal;
@property (strong, nonatomic) IBOutlet UILabel *headerItems;
@property (strong, nonatomic) IBOutlet UILabel *headerDate;
@property (strong, nonatomic) IBOutlet UIButton *centerCamera;


@end

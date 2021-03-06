//
//  BookVC.h
//  Sortr
//
//  Created by KrisMraz on 8/4/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesVC.h"

@interface BookVC : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView   *photoContainer;
@property (weak, nonatomic) IBOutlet UITableView        *bookTableView;
@property (strong, nonatomic)        UIViewController   *note_delegate;

#pragma mark Header Properties


- (void) processingFinished;
- (void) openReceiptOnInvoice;
@end

//
//  InvoiceImagesVC.m
//  Sortr
//
//  Created by KrisMraz on 8/7/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "InvoiceImagesVC.h"
#import "ThumbCell.h"
#import "Utilities.h"
#import "ReceiptInfoViewController.h"
#import "SortrReceipt.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface InvoiceImagesVC () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *invoiceImages;
    NSMutableArray  *receipts;
}
@end

@implementation InvoiceImagesVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    invoiceImages = [[ NSMutableArray alloc] init];
    
    [self.invoiceCollectionView registerClass:[ThumbCell class] forCellWithReuseIdentifier:@"invoiceItem"];
    
    //SHOW INDICATOR
    [self displayBookItems];
}

#pragma mark FETCH PHOTO
- (void) displayBookItems
{
    receipts = [[SortrDataManager sharedInstance] getAllReceiptData];
    
    for (ReceiptObject *receipt in receipts) {
            UIImage *image = [UIImage imageWithData:receipt.image];
            [invoiceImages addObject:image];
    }
    
}

#pragma mark UICOLLECTION DELEGATE

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return invoiceImages.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ThumbCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"invoiceItem" forIndexPath:indexPath];
    ReceiptObject *rc = [receipts objectAtIndex:indexPath.row];
    
    [cell assignThumbImage:[invoiceImages objectAtIndex:indexPath.row]];
    [cell setStatus:rc.receiptStatus];
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.shadowRadius = 2;
    
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ReceiptObject *rc = [receipts objectAtIndex:indexPath.row];
    if (rc.receiptStatus >= Audit) {
        
        ReceiptInfoViewController *rcc = [[ReceiptInfoViewController alloc] init];
        rcc.receiptData = [receipts objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:rcc animated:YES];
        
    }
}
 

#pragma mark DID RECEIVE MEMORY WARNING
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

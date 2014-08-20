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
#import <AssetsLibrary/AssetsLibrary.h>

@interface InvoiceImagesVC () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *invoiceImages;
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
    [Utilities showActivityIndicator:self];
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [self displayBookItems];
                   });
}

#pragma mark FETCH PHOTO
- (void) displayBookItems
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // Chooses the photo at the last index
        [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop)
         {
             if (alAsset) {
                 ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                 UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                 
                 // Stop the enumerations
                 *stop = YES;
                 
                 //                UIImage *latestPhotoThumbnail =  [UIImage imageWithCGImage:[alAsset thumbnail]];
                 [invoiceImages addObject:latestPhoto];
             }
         }];
        
         if (group == nil) {
             [self.invoiceCollectionView reloadData];
             [Utilities hideActivityIndicator:self];
         }
        
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
        NSLog(@"No groups");
    }];
}

#pragma mark UICOLLECTION DELEGATE

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return invoiceImages.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ThumbCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"invoiceItem" forIndexPath:indexPath];
    
    [cell assignThumbImage:[invoiceImages objectAtIndex:indexPath.row]];
    
    return cell;
}
 

#pragma mark DID RECEIVE MEMORY WARNING
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

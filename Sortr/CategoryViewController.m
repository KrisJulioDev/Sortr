//
//  CategoryViewController.m
//  Sortr
//
//  Created by KrisMraz on 12/10/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "CategoryViewController.h"
#import "ThumbCell.h"
#import "SortrDataManager.h"
#import "BookCell.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "ThumbCell.h"
#import "ReceiptData.h"
#import "ReceiptInfoViewController.h"
#import "APIClient.h"

@interface CategoryViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *thumbNailPhotos;
    NSMutableArray *thumbNailCells;
    NSMutableArray *receiptItems;
    NSArray         *receipts;
    SortrDataManager *sortrDataMgr;
    
    ThumbCell *cell;
    ThumbCell *savedCell;
    ThumbCell *selectedCell;
    
    BOOL *hasSelectedCell;
}
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sortrDataMgr = [SortrDataManager sharedInstance];
    [self.photoContainer registerClass:[ThumbCell class] forCellWithReuseIdentifier:@"item"];
    [self modifyNavBar];
    
    receiptItems    = [NSMutableArray new];
    thumbNailPhotos = [NSMutableArray new];
    thumbNailCells  = [NSMutableArray new];
    receipts        = [sortrDataMgr getAllReceiptData];
    
    [self.scanBtn setEnabled:NO];
    [self refreshData];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = self.title;
    self.totalLabel.text = @"TOTAL : P0.00";
    
    [self.scanBtn setEnabled:NO];
}

- (void) refreshData {
    
    for (ReceiptData *receipt in receipts) {
        if ([receipt.category isEqualToString:self.title]) {
            
            if (![receiptItems containsObject:receipt]) {
                [receiptItems addObject:receipt];
                
                UIImage *image = [UIImage imageWithData:receipt.image];
                [thumbNailPhotos addObject:image];
            }
            
        }
    }
    [thumbNailCells removeAllObjects];
    
    [self.photoContainer reloadData];
    [self.receiptTable reloadData];
}

- (void) modifyNavBar
{
    //add Camera on right menu
    UIBarButtonItem *camera = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(actionLaunchAppCamera:)];
    
    [camera setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = camera;
}

#pragma mark UICOLLECTION DELEGATE

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return thumbNailPhotos.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    [cell assignThumbImage: [thumbNailPhotos objectAtIndex:indexPath.row]];
    
    if ( savedCell.thumbStatus == Scan)
    {
        //[[OCRManager sharedInstance] processImage:cell withDelegate:self];
        //[[SortrSessionManager sharedInstance] uploadPhotoToServer:cell];
    }
    
    [thumbNailCells addObject:cell];
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    for (ThumbCell *_cell in thumbNailCells) {
        [_cell setStatus:Done];
    }
    
    ThumbCell *_cell = [thumbNailCells objectAtIndex:indexPath.row];
    [_cell setStatus:Inquiry];
    
    [self.scanBtn setEnabled:YES];
    
    selectedCell = _cell;
    
}

#pragma mark CAMERA DELEGATE
-(void)actionLaunchAppCamera : (id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Camera Unavailable"
                                                       message:@"Unable to find a camera on your device."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imageCaptured = [info objectForKey:UIImagePickerControllerOriginalImage];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    ThumbCell *itemcell = [[ThumbCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    [library writeImageToSavedPhotosAlbum:[imageCaptured CGImage] orientation:(ALAssetOrientation)[imageCaptured imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            // TODO: error handling[self addAssetURL: assetURL
        } else {
            // TODO: success handling
            itemcell.imageUrl = assetURL;
            
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSData *imageData = UIImageJPEGRepresentation(imageCaptured, 0.0f);
 
                dispatch_async( dispatch_get_main_queue(), ^{
                    
                    //*code to hide the loading view here*
                    [sortrDataMgr saveTotalData:nil
                                       category:self.title
                                          image:imageData
                                      withTotal:@""
                                            vat:@""
                                         branch:@""
                                    receiptDate:@""];
                    
                    
                });
                
            });
            
            
            [library addAssetURL:assetURL toAlbum:kJobPhotoGroup withCompletionBlock:^(NSError *error) {
                if (error!=nil) {
                    NSLog(@"Big error: %@", [error description]);
                }
            }];
        }
    }];
    
    itemcell.thumbName = @"hello_image";
    itemcell.thumbImage = imageCaptured;
    itemcell.thumbStatus = Scan;
    
    [[sortrDataMgr bookItems] addObject:itemcell];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        receipts = [sortrDataMgr getAllReceiptData];
        [self refreshData];
        
    });
    
    // Remove lines of cell without data
    self.receiptTable.tableFooterView = [UIView new];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark UITABLEVIEW DELEGATES
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookCell *cell_ = [tableView dequeueReusableCellWithIdentifier:@"bookCell"];
    
    if (cell_ == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BookCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell_ = [topLevelObjects objectAtIndex:0];
        
    }
    
    ReceiptData *rdata = [receiptItems objectAtIndex:indexPath.row];
    cell_.receiptName.text  = rdata.branch;
    cell_.receiptPrice.text = rdata.total;
    
    UIImage *photoImg = [UIImage imageWithData:rdata.image];
    [cell_ updateStatusWithPhoto:photoImg];
    
    return cell_;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return receiptItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70; ///HEIGHT OF BOOKCELL
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReceiptInfoViewController *rivc = [[ReceiptInfoViewController alloc] init];
    rivc.receiptData = [receipts objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:rivc animated:YES];
    
}

- (IBAction)scanReceipt:(id)sender {
    
    APIClient *client = [APIClient sharedInstance];
    client.delegate   = self;
    
    if ( selectedCell != nil) {
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        [client exportImageData:selectedCell andBlock: ^(ResponseObject *response){
            
            NSLog(@"RESPONSE OBJ : %@", response);
            
        }];
    }
}

- (void) exportReceiptCallback : (id) sender success: (ResponseObject *) responseObject {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void) exportReceiptCallback : (id) sender failed: (NSError *) error {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void) receiptHTTPClient : (id)sender didUpdateWithStatus : ( NSString *) status {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

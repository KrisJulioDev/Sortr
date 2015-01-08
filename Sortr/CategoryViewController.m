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
#import "UIImage+fixOrientation.h"
#import "ThumbCell.h"
#import "ReceiptData.h"
#import "ReceiptInfoViewController.h"
#import "Utilities.h"
#import "APIClient.h"
#import "SortrReceipt.h"
#import "PostPhotoViewController.h"
#import <Realm/Realm.h>

@interface CategoryViewController () <UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    NSMutableArray *thumbNailPhotos;
    NSMutableArray *thumbNailCells;
    NSMutableArray *receiptItems;
    NSMutableArray  *receipts;
    RLMArray        *rlmReceipts;
    SortrDataManager *sortrDataMgr;
    
    ThumbCell *cell;
    ThumbCell *savedCell;
    BookCell *selectedCell;
    
    BOOL *hasSelectedCell;
    BOOL isRefreshing;
    
    UIRefreshControl *refreshControl;

    NSTimer *uploadScheduler;
    NSTimer *updateScheduler;
}
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sortrDataMgr = [SortrDataManager sharedInstance]; 
    [self modifyNavBar];
    
    receiptItems    = [NSMutableArray new];
    thumbNailPhotos = [NSMutableArray new];
    thumbNailCells  = [NSMutableArray new];
    receipts        = [sortrDataMgr getAllReceiptData];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [self.receiptTable addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(fetchReceiptData) forControlEvents:UIControlEventValueChanged];
   
        /* LATER IMPLEMENTATION
    uploadScheduler = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scheduledUploadFire:) userInfo:nil repeats:YES];
    updateScheduler = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(fetchReceiptData) userInfo:nil repeats:YES];
    
    [uploadScheduler fire];
    [updateScheduler fire];
     */
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = self.title;
    
    [self.scanBtn setEnabled:NO];
    [self.scanBtn setAlpha:0.5f];
    
    [self refreshData];
}

- (void) fetchReceiptData
{
    [APIClient sharedInstance].delegate = self;
    
    for (ReceiptObject *receipt in receiptItems) {
        
        if (receipt.receiptStatus < Audit) {
            [[APIClient sharedInstance] getReceiptStatus:[receipt.receiptId intValue]];
        }
        
    }

    [refreshControl endRefreshing];
}

- (void) refreshData {
    
    if (!isRefreshing) {
        isRefreshing = YES;
        
        [receiptItems removeAllObjects];
        [thumbNailPhotos removeAllObjects];
        
        receipts = [sortrDataMgr getAllReceiptData];
        
        float totalPerCell = 0;
        
        for (ReceiptObject *receipt in receipts) {
            if ([receipt.category isEqualToString:self.title]) {
                
                totalPerCell += [receipt.total intValue];
                
                [receiptItems addObject:receipt];
                
                    UIImage *image = [UIImage imageWithData:receipt.image];
                [thumbNailPhotos addObject:image];
                
            }
        }
        
        [self.totalLabel setText:[NSString stringWithFormat:@"Total : P %.2f", totalPerCell]];
        
         [self.photoContainer reloadData];
         [self.receiptTable reloadData];
 
    }
    
    if (receiptItems.count > 0) {
        [self.receiptTutorial setHidden:YES];
    }
    
    isRefreshing = NO;
}

- (void) proximityChanged : (id) sender
{
    
}

- (void) modifyNavBar
{
    //add Camera on right menu
    UIBarButtonItem *camera = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(actionLaunchAppCamera:)];
    
    [camera setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = camera;
}

#pragma mark UICOLLECTION DELEGATE
/*
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return thumbNailPhotos.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    
    [cell assignThumbImage: [thumbNailPhotos objectAtIndex:indexPath.row]];
    ReceiptObject *cellReceipt = [receiptItems objectAtIndex:indexPath.row];
    
    [cell setReceiptObject:cellReceipt];
    [cell setStatus:cellReceipt.receiptStatus];
    
    
//    cell setStatus:
    
    if ( savedCell.thumbStatus == Scan)
    {
        //[[OCRManager sharedInstance] processImage:cell withDelegate:self];
        //[[SortrSessionManager sharedInstance] uploadPhotoToServer:cell];
    }
    
//    [thumbNailCells addObject:cell];
    
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"INDEXPATH : %i", indexPath.row);
    
    ThumbCell *pcell = (ThumbCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (pcell.thumbStatus == Waiting) {
        
        for (ThumbCell *cel in collectionView.visibleCells) {
            if (cel.thumbStatus == Inquiry) {
                [cel setStatus:Waiting];
            }
        }
        
        [pcell setStatus:Inquiry];
        
        [self.scanBtn setEnabled:YES];
        [self.scanBtn setAlpha:1.0];
        
        selectedCell = pcell;
        
    } else if (pcell.thumbStatus == Inquiry ) {
        
        [pcell setStatus:Waiting];
        
        [self.scanBtn setEnabled:NO];
        [self.scanBtn setAlpha:0.5f];
        
        selectedCell = nil;
        
    }
}
*/
#pragma mark CAMERA DELEGATE
-(void)actionLaunchAppCamera : (id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.navigationBarHidden = YES;
        imagePicker.delegate = self;
          
        [self.receiptTutorial setHidden:YES];
        
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
    UIImage *sourceImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    NSData *data = UIImageJPEGRepresentation(sourceImage, 1.0f);
    UIImage *tmp = [UIImage imageWithData:data];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        PostPhotoViewController *ppv = [[PostPhotoViewController alloc] init];
        ppv.imageTaken = tmp;
        [self.navigationController presentViewController:ppv animated:YES completion:nil];
        
    }];
    
    /*
    UIImage *imageCaptured = [info objectForKey:UIImagePickerControllerOriginalImage];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    ThumbCell *itemcell = [[ThumbCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    imageCaptured = [SortrReceipt doBinarize:imageCaptured];
    
    [Utilities showActivityIndicator:self];
    
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
                    NSLog(@"TEMP : %i", receiptItems.count);
                    
                    [sortrDataMgr saveTotalData:[NSString stringWithFormat:@"temp_%i", receiptItems.count]
                                       category:self.title
                                          image:imageData
                                      withTotal:@""
                                            vat:@""
                                         branch:@""
                                    receiptDate:@""
                                     clientName:@"None"
                                  receiptStatus:(int)Waiting];
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
         
        [self refreshData];
            
            
        // Hide activity indicator
        [Utilities hideActivityIndicator:self];
    });
    
    // Remove lines of cell without data
    self.receiptTable.tableFooterView = [UIView new];
    
    [self dismissViewControllerAnimated:YES completion:nil];
     */
}

#pragma mark UITABLEVIEW DELEGATES
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"bookCell";
    BookCell *cell_ = (BookCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell_ == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BookCell" owner:self options:nil];
        cell_.selectionStyle = UITableViewCellSelectionStyleNone;
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell_ = [topLevelObjects objectAtIndex:0];
    }
    
     
    int index = (receiptItems.count - 1 ) - indexPath.row;
    ReceiptObject *rdata = [receiptItems objectAtIndex:index];
    cell_.receiptName.text  = rdata.branch;
    cell_.receiptPrice.text = [NSString stringWithFormat:@"%@", rdata.total];
    cell_.receiptObject = rdata;
    
    UIImage *photoImg = [UIImage imageWithData:rdata.image];
    
    [cell_.receiptImageDone setImage:photoImg];
    [cell_ updateStatus:(int)cell_.receiptObject.receiptStatus withPhoto:photoImg];
    
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
    
    
    BookCell *cellTapped = (BookCell*)[self.receiptTable cellForRowAtIndexPath:indexPath];
    selectedCell = cellTapped;
    
    
    if( (int)cellTapped.receiptObject.receiptStatus < Audit) {
        
        //Disable tap
        cellTapped.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ((int)cellTapped.receiptObject.receiptStatus == Waiting) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle: @"Process receipt"  otherButtonTitles: @"Delete receipt", nil];
            
            [actionSheet showInView:self.view];
        }
        
        return;
    }
    
    
    ReceiptInfoViewController *rivc = [[ReceiptInfoViewController alloc] init];
    rivc.receiptData = cellTapped.receiptObject;
    [self.navigationController pushViewController:rivc animated:YES];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"You have pressed the %@ button", [actionSheet buttonTitleAtIndex:buttonIndex]);
    
    if (buttonIndex == 0) {
        APIClient *client = [APIClient sharedInstance];
        client.delegate   = self;
        
        if ( selectedCell != nil) {
            
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            [Utilities showActivityIndicator:self];
            
            NSDictionary *parameter = @{@"country": [SavedSettings settingsCountryCode], @"category": self.title, @"uuid" : selectedCell.receiptObject.receiptUUID};
            [client exportImageData:selectedCell withParamter:parameter andBlock:^(ResponseObject *response){
                
            }];
        }
    }
    else if (buttonIndex == 1) {
        [sortrDataMgr deleteReceipt:selectedCell.receiptObject];
        [self refreshData];
    }
    
}

#pragma mark SCHEDULED UPLOAD
- (void) scheduledUploadFire : (id) sender
{
    APIClient *client = [APIClient sharedInstance];
    client.delegate   = self;
    
    if ([_receiptTable numberOfRowsInSection:0] == 0) {
        return;
    }
    
    for (int x = 0; x < [_receiptTable numberOfRowsInSection:0]; x++) {
            BookCell *bc = (BookCell*)[_receiptTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:x inSection:0]];
            
            if (bc.receiptObject.receiptStatus < Scan) {
                
                    NSDictionary *parameter = @{@"country": [SavedSettings settingsCountryCode], @"category": self.title};
                
                    [client exportImageData:bc withParamter:parameter andBlock:^(ResponseObject *response){
                    
                }];
            }
    }
    
    if ([Utilities isConnectedToInternet]) {
        [uploadScheduler invalidate];
        uploadScheduler = nil;
    }
}

#pragma mark SCHEDULED UPDATE


- (IBAction)scanReceipt:(id)sender {
    
    APIClient *client = [APIClient sharedInstance];
    client.delegate   = self;
    
    if ( selectedCell != nil) {
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [Utilities showActivityIndicator:self];
    }
}

#pragma mark EXPORT METHOD DELEGATE
- (void) exportReceiptCallback : (id) sender success: (ResponseObject *) responseObject {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BookCell *bcell = selectedCell;
        //[bcell updateStatus:Done withPhoto:bcell.receiptImage.image];
        
        NSDictionary *response = (NSDictionary*) responseObject;
        NSDictionary *data = [response objectForKey:@"data"];
        
        //Handle Responses
        bcell.receiptName = [data objectForKey:@"store"];
        bcell.receiptPrice = [data objectForKey:@"total"];
        
        int status = [SortrReceipt receiptStatusWithString:[data objectForKey:@"status"]];
        NSString *responseID = [[data objectForKey:@"id"] stringValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[SortrDataManager sharedInstance] updateReceipt:selectedCell.receiptObject.receiptId
                                              withOfficialID:responseID
                                                    category:self.title
                                                   withTotal:@""
                                                         vat:@""
                                                      branch:@""
                                                 receiptDate:@""
                                                  clientName:@"None"
                                               receiptStatus:status];
            
            [self refreshData];
            
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [Utilities hideActivityIndicator:self];
        });
        
    });
}

- (void) exportReceiptCallback : (id) sender failed: (NSError *) error {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [Utilities hideActivityIndicator:self];
}

- (void) receiptHTTPClient : (int) r_id didUpdateWithStatus : ( NSDictionary *) dic {
    
    NSLog(@"Receipt ID : %i and status %@", r_id, dic );
    NSMutableArray *receiptCopy = [receiptItems copy];
        for (ReceiptObject *receipt in receiptCopy) {
            if ( r_id > 0 && [receipt.receiptId intValue] == r_id) {
                
                NSString *fetchStatus = [dic objectForKey:@"status"];
                if ([SortrReceipt receiptStatusWithString:fetchStatus] > receipt.receiptStatus) {
                    
                    NSLog(@"change status and add data");
                    NSString *total;
                    NSString *date;
                    NSString *store;
                    NSString *vat;
                    
                    if (![[dic objectForKey:@"total"] isKindOfClass:[NSNull class]]) {
                        total = [[dic objectForKey:@"total"] stringValue];
                    }
                    if (![[dic objectForKey:@"date"] isKindOfClass:[NSNull class]]) {
                        date = [[dic objectForKey:@"date"] stringValue];
                    }
                    if (![[dic objectForKey:@"store"] isKindOfClass:[NSNull class]]) {
                        store = [dic objectForKey:@"store"] ;
                    }
                    if (![[dic objectForKey:@"vat"] isKindOfClass:[NSNull class]]) {
                        vat = [[dic objectForKey:@"vat"] stringValue];
                    }
                    
                    [sortrDataMgr updateReceipt:receipt.receiptId
                                 withOfficialID:receipt.receiptId
                                       category:self.title
                                      withTotal:total
                                            vat:vat
                                         branch:store
                                    receiptDate:date
                                     clientName:receipt.client
                                  receiptStatus:[SortrReceipt receiptStatusWithString:fetchStatus]];
                    
                    [self refreshData];
                }
            }
        }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) dealloc
{
    [uploadScheduler invalidate];
}

@end

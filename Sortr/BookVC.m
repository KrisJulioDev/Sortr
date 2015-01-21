//
//  BookVC.m
//  Sortr
//
//  Created by KrisMraz on 8/4/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "APIClient.h"
#import "Constants.h"
#import "BookVC.h"
#import "ThumbCell.h"
#import "BookCell.h"
#import "BookDetailVC.h"
#import "Utilities.h"
#import "OCRManager.h"
#import "SortrDataManager.h"
#import "SortrSessionManager.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "SortrDataManager.h"
#import <AFHTTPRequestOperationManager.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "SortrSettingsViewController.h"

@interface BookVC () <UICollectionViewDataSource,
                        UICollectionViewDelegate,
                        UIImagePickerControllerDelegate,
                        UINavigationControllerDelegate,
                        UITableViewDataSource,
                        UITableViewDelegate >
{
    NSMutableArray *thumbNailPhotos;
    NSMutableArray *thumbNailCells;
    
    ThumbCell *cell;
    ThumbCell *savedCell;
    ThumbCell *selectedCell;
    
    SortrDataManager *sortrDataMgr;
}
@end

@implementation BookVC

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
    [self modifyNavBar];
    
    thumbNailPhotos = [NSMutableArray new];
    thumbNailCells = [NSMutableArray new];
    //Initialize bookItems in SortrDataMngr
    sortrDataMgr = [SortrDataManager sharedInstance];
}

- (void) modifyNavBar
{
     //Register class thumbcell and cell
     [self.photoContainer registerClass:[ThumbCell class] forCellWithReuseIdentifier:@"bookItem"];
    
    //add Camera on right menu
    UIBarButtonItem *camera = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(showAppSettingsPage:)];
    
    [camera setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = camera;
}

- (IBAction)exportImageData:(id)sender {
     
    
    //SHOW ACTIVITY INDICATOR
    [Utilities showActivityIndicator:self];
    
    /* EXPORT IMAGE TO CLOUD SERVER FOR CHECKING */
    [[OCRManager sharedInstance] processImage:selectedCell withDelegate:self];
}

- (void) openReceiptOnInvoice {
    [(NotesVC*)self.note_delegate showInvoice];
    [Utilities hideActivityIndicator:self];
}
 
#pragma mark UICOLLECTION DELEGATE

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return sortrDataMgr.bookItems.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bookItem" forIndexPath:indexPath];
    savedCell = [[sortrDataMgr bookItems] objectAtIndex:indexPath.row];
    
    [cell assignThumbImage: savedCell.thumbImage];
    [cell setStatus:savedCell.thumbStatus];
    
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
    
    selectedCell = _cell;
    
}

#pragma mark OCRCALLBACK DELEGATE METHODS
- (void) processingFinished
{
    [cell setStatus:Done];
    savedCell.thumbStatus = Done;
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
    
    ThumbCell *bookCell = [[ThumbCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    [library writeImageToSavedPhotosAlbum:[imageCaptured CGImage] orientation:(ALAssetOrientation)[imageCaptured imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            // TODO: error handling[self addAssetURL: assetURL
        } else {
            // TODO: success handling
            bookCell.imageUrl = assetURL;
            
            //        [[SortrSessionManager sharedInstance] requestPhotoUploadTask:assetURL];
            
            [library addAssetURL:assetURL toAlbum:kJobPhotoGroup withCompletionBlock:^(NSError *error) {
                if (error!=nil) {
                    NSLog(@"Big error: %@", [error description]);
                }
            }];
        }
    }]; 
    
    bookCell.thumbName = @"hello_image";
    bookCell.thumbImage = imageCaptured;
    bookCell.thumbStatus = Scan;
    
    [[sortrDataMgr bookItems] addObject:bookCell];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [self.photoContainer reloadData];
        [self.bookTableView reloadData];
        
    });
    
    // Remove lines of cell without data
    self.bookTableView.tableFooterView = [UIView new];
    
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
    
    return cell_;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sortrDataMgr.bookItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70; ///HEIGHT OF BOOKCELL
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

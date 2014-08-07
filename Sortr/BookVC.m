//
//  BookVC.m
//  Sortr
//
//  Created by KrisMraz on 8/4/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "Constants.h"
#import "BookVC.h"
#import "ThumbCell.h"
#import "BookCell.h"
#import "BookDetailVC.h"
#import "Utilities.h"
#import "Tesseract.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface BookVC () <UICollectionViewDataSource,
                        UICollectionViewDelegate,
                        UIImagePickerControllerDelegate,
                        UINavigationControllerDelegate,
                        UITableViewDataSource,
                        UITableViewDelegate>
{
    NSMutableArray *thumbNailPhotos;
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
    
    thumbNailPhotos = [[NSMutableArray alloc] init];
    
    //Show UIactivity
    [Utilities showActivityIndicator:self];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self displayBookItems];
    });
}

- (void) modifyNavBar
{
    //Register class thumbcell and cell
    [self.photoContainer registerClass:[ThumbCell class] forCellWithReuseIdentifier:@"bookItem"];
    
    //add Camera on right menu
    UIBarButtonItem *camera = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(actionLaunchAppCamera:)];
    
    [camera setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = camera;
}

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
                [thumbNailPhotos addObject:latestPhoto];
            }
        }];
        
        if (group == nil) {
            [self.photoContainer reloadData];
            [self.bookTableView reloadData];
            
            for (UIView *v in [self.view subviews]) {
                if ( [v tag] == ACTIVITY_INDICATOR_VIEW_TAG )
                {
                    [v removeFromSuperview];
                }
            }
        }
        
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
        NSLog(@"No groups");
    }];
}

#pragma mark UICOLLECTION DELEGATE

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return thumbNailPhotos.count;
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ThumbCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bookItem" forIndexPath:indexPath];
   
    [cell setImage:[thumbNailPhotos objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark CAMERA DELEGATE
-(void)actionLaunchAppCamera : (id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        
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
    UIImage *imageCaptured = [info objectForKey:UIImagePickerControllerEditedImage];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library writeImageToSavedPhotosAlbum:[imageCaptured CGImage] orientation:(ALAssetOrientation)[imageCaptured imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            // TODO: error handling
        } else {
            // TODO: success handling
        }
    }];
    
    //Scan image
    Tesseract *tesseractScanner = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    [tesseractScanner setImage:imageCaptured];
    [tesseractScanner recognize];
    
    NSLog(@"TEXT IS : %@", [tesseractScanner recognizedText]);
    
    //Reload Photo Container after capture image
    [thumbNailPhotos removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self displayBookItems];
    });
    
    // Remove lines of cell without data
    self.bookTableView.tableFooterView = [UIView new];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITABLEVIEW DELEGATES
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookCell"];
    
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"BookCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    BookDetailVC *detailView = [BookDetailVC alloc] ini
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return thumbNailPhotos.count;
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

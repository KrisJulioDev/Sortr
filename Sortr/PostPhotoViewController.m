//
//  PostPhotoViewController.m
//  Sortr
//
//  Created by KrisMraz on 12/19/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "PostPhotoViewController.h"

#import "ActionSheetCustomPickerDelegate.h"
#import "ActionSheetLocalePicker.h"
#import "ActionSheetStringPicker.h"
#import "SortrReceipt.h"
#import "Utilities.h"
#import "ThumbCell.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "AddClientViewController.h"
#import "SortrSettingsViewController.h"
#import "GPUImage.h"
#import "CategoryViewController.h"
#import "AwesomeMenu.h"
#import "AwesomeMenuItem.h" 

@interface PostPhotoViewController () <UIAlertViewDelegate,  UIScrollViewDelegate, UIScrollViewAccessibilityDelegate, UIGestureRecognizerDelegate >
{
    NSMutableArray *clientLists;
    NSMutableArray *clientName;
    NSMutableArray *receipts;
    NSMutableArray *categories;
    NSMutableArray *categoryLists;

    NSString *categorySelected;
    NSString *clientSelected;
    
    UIRotationGestureRecognizer *rotationGesture;
    UIPinchGestureRecognizer *pinchGesture;
    UIPanGestureRecognizer *panGesture;
    
    BOOL isProcessing;
    
    UIPinchGestureRecognizer *zoomGesture;
    
    GPUImagePicture *imageSource;
    GPUImageView *filterView;
    GPUImageAdaptiveThresholdFilter *stillImageFilter ;
    
    
    UIButton *doneEdtingBtn;

    CGFloat threshold;
    CGFloat previousScale;
    CGFloat rotation;
}
@end

@implementation PostPhotoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addGestureRecognizersToPiece];
    
    //[self addPhotoTools];
    
    clientName = [NSMutableArray new];
    categoryLists   = [NSMutableArray new];
    categories = [NSMutableArray new];
    receipts = [NSMutableArray new];
    threshold = 25;
    
    receipts = [[SortrDataManager sharedInstance] getAllReceiptData];
    
    imageSource = [[GPUImagePicture alloc] initWithImage:_imageTaken smoothlyScaleOutput:YES];
    stillImageFilter = [[GPUImageAdaptiveThresholdFilter alloc] init];
    stillImageFilter.blurRadiusInPixels = threshold;
    [stillImageFilter useNextFrameForImageCapture];
    
    [imageSource addTarget:stillImageFilter];
    [imageSource processImage];
    
    [_receiptImage setImage:[stillImageFilter imageFromCurrentFramebuffer]];
    [_receiptImage convertRect:_receiptImage.frame fromContentSize:_receiptImage.image.size];
    
    
    //     [_receiptImage setImage:_imageTaken];
    
    //self.thresholdSlider.minimumValue = 0;
    //self.thresholdSlider.maximumValue = 40;
    //[self.thresholdSlider addTarget:self action:@selector(thresholdChanged:) forControlEvents:UIControlEventTouchUpInside];
}


- (void) viewDidAppear:(BOOL)animated
{
    clientLists = [[SortrDataManager sharedInstance] getAllClients];
    [clientName removeAllObjects];
    [categories removeAllObjects];
    
    [clientName addObject:@"None"];
    
    for (ClientObject *c in clientLists) {
        [clientName addObject:c.name];
    }
    
    categoryLists = [[SortrDataManager sharedInstance] getAllCategories];
    for (CategoryObject *c in categoryLists) {
        [categories addObject:c.name];
    }
 
    if (categories.count > 0) {
        categorySelected = [categories objectAtIndex:0];
        [self.setCategoryBtn setTitle:categorySelected forState:UIControlStateNormal];
    }
    
    if (clientName.count > 0) {
         clientSelected = [clientName objectAtIndex:0];
        [self.setClientBtn setTitle:clientSelected forState:UIControlStateNormal];
       
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addPhotoTools
{
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    UIImage *starImage = [UIImage imageNamed:@"icon-star.png"];
    
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem5 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5, nil];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-addbutton.png"]
                                                       highlightedImage:[UIImage imageNamed:@"bg-addbutton-highlighted.png"]
                                                           ContentImage:[UIImage imageNamed:@"icon-plus.png"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon-plus-highlighted.png"]];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds startItem:startItem optionMenus:menus];
    menu.delegate = self;
    
    menu.menuWholeAngle = M_PI_2   ;
    menu.farRadius = 110.0f;
    menu.endRadius =  100.0f;
    menu.nearRadius = 90.0f;
    menu.animationDuration = 0.3f;
    menu.startPoint = CGPointMake( 50, 330);
    
    doneEdtingBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 320, 120, 30)];
    [doneEdtingBtn setTitle:@"Done editing" forState:UIControlStateNormal];
    [doneEdtingBtn.titleLabel setFont:[UIFont fontWithName:@"DIN Alternate" size:17]];
    [doneEdtingBtn setBackgroundImage:[UIImage imageNamed:@"red_button"] forState:UIControlStateNormal];
    [doneEdtingBtn addTarget:self action:@selector(doneEditing) forControlEvents:UIControlEventTouchUpInside];
 
    [self.view addSubview:menu];
    [self.view addSubview:doneEdtingBtn];
    
    [doneEdtingBtn setHidden:YES];
}

- (IBAction)setCategory:(id)sender {
    
    if (categories.count > 0 ) {
     [ActionSheetStringPicker showPickerWithTitle:@"Select Category" rows:categories initialSelection:0 target:self successAction:@selector(categoryAdded:element:) cancelAction:nil origin:sender];
        
        [self.doneBtn setEnabled:YES];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Add category problem" message:@"You don't have any category" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Category", nil];
        av.tag = 002;
        [av show];
    }
}

- (IBAction)setClient:(id)sender {
    
    if (clientName.count > 0 ) {
    
        [ActionSheetStringPicker showPickerWithTitle:@"Select Client" rows:clientName initialSelection:0 target:self successAction:@selector(clientAdded:element:) cancelAction:nil origin:sender];
    }
     else
     {
         UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Add client problem" message:@"You don't have any client" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add Client", nil];
         av.tag = 001;
         [av show];
     }

}

- (void)categoryAdded:(NSNumber *)selectedIndex element:(id)element
{
    UIButton *sender = (UIButton*) element;
    categorySelected = [categories objectAtIndex:[selectedIndex intValue]];
    
    [sender setTitle:categorySelected forState:UIControlStateNormal];
}

- (void)clientAdded:(NSNumber *)selectedIndex element:(id)element
{
    UIButton *sender = (UIButton*) element;
    
    clientSelected = [clientName objectAtIndex:[selectedIndex intValue]];
    [sender setTitle:clientSelected forState:UIControlStateNormal];
}

- (IBAction)captureAgain:(id)sender
{
    if ([self.setCategoryBtn.titleLabel.text isEqualToString:@"Set Category"]) {
        [[[UIAlertView alloc] initWithTitle:@"Saving Error" message:@"Please provide a category" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        
        return;
    }
    
    
    UIImage *imageCaptured;
    imageCaptured =  _receiptImage.image ;
    
    ThumbCell *itemcell = [[ThumbCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [Utilities showActivityIndicator:self];
    
    //itemcell.imageUrl = assetURL;
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *imageData = UIImageJPEGRepresentation(imageCaptured, 0.0f);
        NSString *generatedUUID = [[NSUUID UUID] UUIDString];
        dispatch_async( dispatch_get_main_queue(), ^{
            
            //*code to hide the loading view here*
            [[SortrDataManager sharedInstance] saveTotalData:[NSString stringWithFormat:@"temp_%i", receipts.count]
                                                        uuid:generatedUUID
                                                    category:categorySelected
                                                       image:imageData
                                                   withTotal:@""
                                                         vat:@""
                                                      branch:@""
                                                 receiptDate:@""
                                                  clientName:clientSelected
                                               receiptStatus:(int)Waiting];
        });
        
    });

    /*
    [library writeImageToSavedPhotosAlbum:[imageCaptured CGImage] orientation:(ALAssetOrientation)UIImageOrientationRight completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            // TODO: error handling[self addAssetURL: assetURL
        } else {
            // TODO: success handling
            
     
            [library addAssetURL:assetURL toAlbum:kJobPhotoGroup withCompletionBlock:^(NSError *error) {
                if (error!=nil) {
                    NSLog(@"Big error: %@", [error description]);
                }
            }];
        }
    }];*/
    
    itemcell.thumbName = @"hello_image";
    itemcell.thumbImage = imageCaptured;
    itemcell.thumbStatus = Scan;
    
    [[[SortrDataManager sharedInstance] bookItems] addObject:itemcell];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        // Hide activity indicator
        [Utilities hideActivityIndicator:self];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        if ([self.delegate isKindOfClass:[CategoryViewController class]]) {
            
            CategoryViewController *del = (CategoryViewController*) self.delegate;
            [del actionLaunchAppCamera:self];
            
        }
    }); 
}

- (IBAction)dismissVC:(id)sender {
    
    if ([self.setCategoryBtn.titleLabel.text isEqualToString:@"Set Category"]) {
        [[[UIAlertView alloc] initWithTitle:@"Saving Error" message:@"Please provide a category" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        
        return;
    }
    
    
    UIImage *imageCaptured;
    imageCaptured =  _receiptImage.image ;
    
    ThumbCell *itemcell = [[ThumbCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [Utilities showActivityIndicator:self];
    
    [library writeImageToSavedPhotosAlbum:[imageCaptured CGImage] orientation:(ALAssetOrientation)UIImageOrientationRight completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            // TODO: error handling[self addAssetURL: assetURL
        } else {
            // TODO: success handling
            itemcell.imageUrl = assetURL;
            
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSData *imageData = UIImageJPEGRepresentation(imageCaptured, 0.0f);
                NSString *generatedUUID = [[NSUUID UUID] UUIDString];
                dispatch_async( dispatch_get_main_queue(), ^{
                    
                    //*code to hide the loading view here*
                    [[SortrDataManager sharedInstance] saveTotalData:[NSString stringWithFormat:@"temp_%i", receipts.count]
                                           uuid:generatedUUID
                                       category:categorySelected
                                          image:imageData
                                      withTotal:@""
                                            vat:@""
                                         branch:@""
                                    receiptDate:@""
                                    clientName:clientSelected
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
    
    [[[SortrDataManager sharedInstance] bookItems] addObject:itemcell];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        // Hide activity indicator
        [Utilities hideActivityIndicator:self];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (IBAction)binarizeImageChange:(id)sender {
    
    if (isProcessing) {
        return;
    }
    NSLog(@"PROCESSING %i", isProcessing);
    isProcessing = true;
    
    UIButton *btn = (UIButton*)sender;
    if (btn.tag == 1) {
        threshold--;
    } else {
        threshold++;
    }
    
    threshold = CLAMP(threshold, 1, 40);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [stillImageFilter setBlurRadiusInPixels:threshold];
        [stillImageFilter useNextFrameForImageCapture];
        [imageSource processImage];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_receiptImage setImage:[ stillImageFilter imageFromCurrentFramebuffer ] ];
            
            isProcessing = false;
            
            NSLog(@"PROCESSING %i", isProcessing);
        });
        
    });
}
- (IBAction)sliderChanged:(id)sender {
    
    UISlider *slider = (UISlider*)sender;
    threshold = slider.value;
    
}

- (void) thresholdChanged : (id) sender
{
    UISlider *slider = (UISlider*)sender;
    threshold = slider.value;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [stillImageFilter setBlurRadiusInPixels:threshold];
        [stillImageFilter useNextFrameForImageCapture];
        [imageSource processImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_receiptImage setImage:[ stillImageFilter imageFromCurrentFramebuffer ] ];
            
            isProcessing = false;
            
            NSLog(@"PROCESSING %i", isProcessing);
        });
        
    });
    
    NSLog(@"Editing Changed:");
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 001) {
        if (buttonIndex != 0) {
            
            AddClientViewController *acv = [[AddClientViewController alloc] init];
            [self presentViewController:acv animated:YES completion:nil];
            
        }
        
    }
    
    else if ( alertView.tag == 002) {
         if (buttonIndex != 0) {
             SortrSettingsViewController *acv = [[SortrSettingsViewController alloc] init];
             [self presentViewController:acv animated:YES completion:nil];
         }
    }
}
 

- (IBAction)cancelEditing:(id)sender { 
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIIMage Scale

// adds a set of gesture recognizers to one of our piece subviews
- (void)addGestureRecognizersToPiece
{
    
    rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
    [rotationGesture setDelegate:self];
    [_receiptImage addGestureRecognizer:rotationGesture];
    /*
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPiece:)];
    [tapGesture setDelegate:self];
    [_receiptImage addGestureRecognizer:tapGesture];
    */
    
    pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
    [_receiptImage addGestureRecognizer:pinchGesture];
    
    
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [_receiptImage addGestureRecognizer:panGesture];
    
}

- (void) removeGestureRecognizers
{
    [_receiptImage removeGestureRecognizer:rotationGesture];
    [_receiptImage removeGestureRecognizer:pinchGesture];
    [_receiptImage removeGestureRecognizer: panGesture];
}

#pragma mark -
#pragma mark === Utility methods  ===
#pragma mark

// scale and rotation transforms are applied relative to the layer's anchor point
// this method moves a gesture recognizer's view's anchor point between the user's fingers
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}


#pragma mark -
#pragma mark === Touch handling  ===
#pragma mark

// shift the piece's center by the pan amount
// reset the gesture recognizer's translation to {0, 0} after applying so the next callback is a delta from the current position
- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (!_receiptImage.isEditingModeOn ) {
        
        UIView *piece = [gestureRecognizer view];
        
        [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
        
        if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
            CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
            
            [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
            [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
        }
    
    }
}

// rotate the piece by the current rotation
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current rotation
- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer
{
    if (!_receiptImage.isEditingModeOn ) {
    
        [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
        
        if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
            [gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
            rotation += [gestureRecognizer rotation];
            [gestureRecognizer setRotation:0];
        }
        
    }
}

// scale the piece by the current scale
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current scale
- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
    if (!_receiptImage.isEditingModeOn ) {
        
        [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
        
        if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
            [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
            [gestureRecognizer setScale:1];
        }
    }
}

// ensure that the pinch, pan and rotate gesture recognizers on a particular view can all recognize simultaneously
// prevent other gesture recognizers from recognizing simultaneously
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view)
        return NO;
    
    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
    return YES;
}
- (void) awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    switch (idx) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
    
    [doneEdtingBtn setHidden:NO];
    [self removeGestureRecognizers];
    
    _receiptImage.isEditingModeOn = YES;
}

#pragma mark DRAWING 

- (void) doneEditing  {
    [doneEdtingBtn setHidden:YES];
    [self addGestureRecognizersToPiece];
    
    _receiptImage.isEditingModeOn = NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

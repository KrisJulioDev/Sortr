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

@interface PostPhotoViewController () <UIAlertViewDelegate>
{
    NSMutableArray *clientLists;
    NSMutableArray *clientName;
    NSMutableArray *receipts;
    NSMutableArray *categories;
    NSMutableArray *categoryLists;

    NSString *categorySelected;
    NSString *clientSelected;
}
@end

@implementation PostPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    clientName = [NSMutableArray new];
    categoryLists   = [NSMutableArray new];
    categories = [NSMutableArray new];
    receipts = [NSMutableArray new];
    
    receipts = [[SortrDataManager sharedInstance] getAllReceiptData];
    [_receiptImage setImage:_imageTaken];
}

- (void) viewDidAppear:(BOOL)animated
{
    clientLists = [[SortrDataManager sharedInstance] getAllClients];
    [clientName removeAllObjects];
    [categories removeAllObjects];
    
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

- (IBAction)dismissVC:(id)sender {
    
    UIImage *imageCaptured;
    imageCaptured = [SortrReceipt doBinarize:_receiptImage.image];
    
    ThumbCell *itemcell = [[ThumbCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
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
                    [[SortrDataManager sharedInstance] saveTotalData:[NSString stringWithFormat:@"temp_%i", receipts.count]
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
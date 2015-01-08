//
//  InvoiceVC.m
//  Sortr
//
//  Created by KrisMraz on 8/7/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "InvoiceVC.h"
#import "NoteTVC.h"
#import "InvoiceImagesVC.h"
#import "ClientListVC.h"
#import "DownloadTabVC.h"
#import "ExportSettingsVC.h"
#import "SortrDataManager.h"
#import "ReceiptData.h"
#import "ReceiptInfoViewController.h"
#import "CategoryViewController.h"
#import "ActionSheetCustomPickerDelegate.h"
#import "ActionSheetLocalePicker.h"
#import "ActionSheetStringPicker.h"
#import "APIClient.h"
#import "BookCell.h"
#import "SortrSettingsViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "PostPhotoViewController.h"
#import "Utilities.h"

@interface InvoiceVC () <UIImagePickerControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>
{
    NSMutableArray *invoiceItemLists;
    NSArray *m_categories;
    NSMutableArray *m_tableItems;
    
    NSMutableArray *clientLists;
    NSMutableArray *clientName;
    
    SortrDataManager *sortrDataMgr;
    id barButtonAppearanceInSearchBar ;
    
    float headerTotalAmt;
}
@end

@implementation InvoiceVC

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
    
    //initiliaze
    invoiceItemLists = [[NSMutableArray alloc] init];
    m_tableItems     = [[NSMutableArray alloc] init];
    
    m_categories     = [NSArray new];
    sortrDataMgr     = [SortrDataManager sharedInstance];
    
    if ( !sortrDataMgr.categoryLists ) {
        sortrDataMgr.categoryLists = [NSMutableArray new];
    }
    
    float totalValue = 0;
    for (ReceiptObject *r in [sortrDataMgr getAllReceiptData]) {
        totalValue += [r.total floatValue];
    }
    
    [SavedSettings setInvoiceTotal:totalValue];
    [self  refreshData];
    
    // Tint white navigation buttons
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    [self.searchBar setBackgroundColor:SORTR_BLUE];
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchBar.placeholder = @"Category";
    [self.searchBar setDelegate:self];
    
    [self.searchBar setImage:[UIImage imageNamed:@"category_icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    barButtonAppearanceInSearchBar = [UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil];
    [barButtonAppearanceInSearchBar setTitle:@"Add"];
    
    self.searchBar.returnKeyType = UIReturnKeyDone;
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"RECEIPTS";
    [self updateHeaderValues];
}

- (void) viewDidAppear:(BOOL)animated {
    
    clientLists = [[SortrDataManager sharedInstance] getAllClients];
    clientName  = [NSMutableArray new];
    
    for (ClientObject *c in clientLists) {
        [clientName addObject:c.name];
    }
    
    [self  refreshData];
    
    if (m_tableItems.count > 0) {
        [_categoryTutorial setHidden:YES];
    }
}

- (void) refreshData {
    
    m_categories = [sortrDataMgr getAllCategories];
    
    for (CategoryObject *data in m_categories) {
        if (![m_tableItems containsObject:data.name]) {
            [m_tableItems addObject:data.name];
        }
    }
    
    [self.invoiceTableView reloadData];
}

#pragma mark - Search controller

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    
    
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    NSString *categoryAdded = controller.searchBar.text;
    
    if (categoryAdded.length > 0) {
        [sortrDataMgr saveCategoryWithName:categoryAdded];
        [self refreshData];
    }
    
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.searchBar removeFromSuperview];
}


- (void)toggleSearch :(id) sender
{
    [self.view addSubview:self.searchBar];
    [self.searchController setActive:YES animated:YES];
    [self.searchBar becomeFirstResponder];
    
    [_categoryTutorial setHidden:YES];
}

- (void) modifyNavBar
{
    //add Camera on right menu
    UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toggleSearch:)];
    
    //tint camera icon color
    [settings setTintColor:[UIColor whiteColor]];
    settings.style = UIBarButtonSystemItemAdd;
    
    //add rightbutton UI
    self.navigationItem.rightBarButtonItem = settings;
    
    // Remove lines of cell without data
    self.invoiceTableView.tableFooterView = [UIView new];
}

#pragma mark SHOW SETTINGS
- (void) showAppSettingsPage : (id) sender
{
    SortrSettingsViewController *settingsPage = [[SortrSettingsViewController alloc] init];
    [self presentViewController:settingsPage animated:YES completion:nil];
}


#pragma mark CAMERA DELEGATE
-(IBAction)actionLaunchAppCamera : (id)sender
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
    UIImage *sourceImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    NSData *data =   UIImagePNGRepresentation(sourceImage) ;
    UIImage *tmp = [UIImage imageWithData:data];
    
    UIImage *afterFixingOrientation = [UIImage imageWithCGImage:tmp.CGImage
                                                          scale:sourceImage.scale
                                                    orientation:sourceImage.imageOrientation];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        PostPhotoViewController *ppv = [[PostPhotoViewController alloc] init];
        ppv.imageTaken = afterFixingOrientation;
        [self.navigationController presentViewController:ppv animated:YES completion:nil];
        
    }];
    
}

#pragma mark UITABLEVIEW DELEGATES
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"invoiceCell"];
    
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NoteTVC" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    NSString *title= [m_tableItems objectAtIndex:indexPath.row];
    cell.Title.text = title;
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryViewController *cvc = [[CategoryViewController alloc] init];
    cvc.title = [m_tableItems objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:cvc animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_tableItems.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70; ///HEIGHT OF BOOKCELL
}

#pragma mark TAB BUTTON CALLBACKS
- (IBAction) openViewByThisTab : ( UIButton* ) tab
{
    UIViewController *presentingVC = nil;
    switch ([tab tag]) {
        case 1:
            presentingVC = [[ClientListVC alloc] initWithNibName:@"ClientListVC" bundle:nil];
            presentingVC.title = @"CLIENT LIST";
            
            break;
            
        case 2:
            presentingVC = [[InvoiceImagesVC alloc] initWithNibName:@"InvoiceImagesVC" bundle:nil];
            presentingVC.title = @"Receipts Images";
            
            break;
            
        case 3:
            presentingVC = [[DownloadTabVC alloc] initWithNibName:@"DownloadTabVC" bundle:nil];
            presentingVC.title = @"EMAIL DOWNLOAD";
            
            break;
            
        case 4:
            presentingVC = [[ExportSettingsVC alloc] initWithNibName:@"ExportSettingsVC" bundle:nil];
            presentingVC.title = @"EXPORT SETTINGS";
            
            break;
            
        default:
            break;
        
    }
    
    if (presentingVC) {
        self.navigationItem.title = @"Back";
        [self.navigationController pushViewController:presentingVC animated:YES];
    }
}

- (void) updateHeaderValues {
    
        self.headerTotal.text =  [NSString stringWithFormat:@"TOTAL : %.2f", [SavedSettings getInvoiceTotal]];
//    self.headerItems.text =  [NSString stringWithFormat:@"%i items", receipts.count];
 }

- (void)categoryAdded:(NSNumber *)selectedIndex element:(id)element
{
    [m_tableItems addObject:[clientName objectAtIndex:[selectedIndex intValue]]];
    [self.invoiceTableView reloadData];
}

- (IBAction)addCategory:(id)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"Select Client" rows:clientName initialSelection:0 target:self successAction:@selector(categoryAdded:element:) cancelAction:nil origin:sender];
    
    /*
    if ( NSClassFromString(@"UIAlertController") )  {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Add Category"
                                              message:@"Type category"
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
         {
             textField.placeholder = NSLocalizedString(@"Category", @"categoryPlaceHolder");
             [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
         }];
        
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       UITextField *categoryField = alertController.textFields.firstObject;
                                       
                                       if (![m_tableItems containsObject:categoryField.text]) {
                                           [m_tableItems addObject:categoryField.text];
                                           [self.invoiceTableView reloadData];
                                       }
                                   }];
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    } else
    {
        [m_tableItems addObject:@"Entertainment"];
        [self.invoiceTableView reloadData];
    }
     */
}

- (void)alertTextFieldDidChange:(NSNotification *)notification
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController)
    {
        UITextField *category = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = category.text.length > 2;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

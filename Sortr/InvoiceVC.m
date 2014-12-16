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

@interface InvoiceVC () <UIImagePickerControllerDelegate>
{
    NSMutableArray *invoiceItemLists;
    NSArray *m_categories;
    NSMutableArray *m_tableItems;
    
    SortrDataManager *sortrDataMgr;
    
    NSArray *receipts;
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
    self.mManagedContext        = [[SortrDataManager sharedInstance] managedObjectContext];
    
    
    
    if ( !sortrDataMgr.categoryLists ) {
        sortrDataMgr.categoryLists = [NSMutableArray new];
        
    }
    
    NSFetchRequest *request     = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ReceiptData" inManagedObjectContext:self.mManagedContext];
    [request setEntity:entity];
    
    NSError *error;
    receipts = [self.mManagedContext executeFetchRequest:request error:&error];
    
    [self  extractData];
}

- (void) extractData {
    
    m_categories = [sortrDataMgr getAllReceiptData];
    
    for (ReceiptData *data in m_categories) {
        if (![m_tableItems containsObject:data.category]) {
            [m_tableItems addObject:data.category];
        }
    }
    
    [self.invoiceTableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"INVOICE";
}

- (void) modifyNavBar
{
    //add Camera on right menu
    UIBarButtonItem *camera = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(actionLaunchAppCamera:)];
    
    //tint camera icon color
    [camera setTintColor:[UIColor whiteColor]];
    
    //add rightbutton UI
    self.navigationItem.rightBarButtonItem = camera;
    
    // Remove lines of cell without data
    self.invoiceTableView.tableFooterView = [UIView new];
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
    return 95; ///HEIGHT OF NOTETVC
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
            presentingVC.title = @"INVOICE IMAGES";
            
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
    self.headerTotal.text =  [NSString stringWithFormat:@"TOTAL : %f", headerTotalAmt];
    self.headerItems.text =  [NSString stringWithFormat:@"%i items", receipts.count];
 }

- (IBAction)addCategory:(id)sender {
    
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

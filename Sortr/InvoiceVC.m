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

@interface InvoiceVC () <UIImagePickerControllerDelegate>
{
    NSMutableArray *invoiceItemLists;
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
    [invoiceItemLists addObject:@""];
    [invoiceItemLists addObject:@""];
    
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
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    BookDetailVC *detailView = [BookDetailVC alloc] ini
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return invoiceItemLists.count;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

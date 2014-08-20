//
//  NotesVC.m
//  Sortr
//
//  Created by KrisMraz on 8/4/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "NotesVC.h"
#import "NoteTVC.h"
#import "NoteItem.h"
#import "BookVC.h"
#import "InvoiceVC.h"
#import "SortrDataManager.h"
#import "ThumbCell.h"
#import "Utilities.h"
#import "OCRManager.h"

@interface NotesVC () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *mNoteItems;
}
@end

@implementation NotesVC 

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
    
    //SET TITLE COLOR
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // Remove lines of cell without data
    self.mTableView.tableFooterView = [UIView new];
    
    
    // Tint white navigation buttons
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    mNoteItems = [self parseList:[ self noteLists ]];
    
    [self.mTableView reloadData];
    //Show UIactivity
    [Utilities showActivityIndicator:self];
    
    //Get Photo Library Data's
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [[OCRManager sharedInstance] fetchPhotoLibToApp:self];
    });
}

- (void) viewWillAppear:(BOOL)animated
{
    //RETURN MAIN SCREEN TITLE FROM BACK TO SORTR
    self.navigationItem.title = @"SORTR";
}

#pragma mark JSON DATA's
-(NSDictionary *)noteLists {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"noteLists" ofType:@"json"];
    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:myData options:0 error:&localError];
    
    if (!localError) {
        return parsedObject;
    }
    return nil;
}

-(NSMutableArray*)parseList:(NSDictionary *)dict
{
    NSMutableArray *result=[[NSMutableArray alloc] init];
    @try {
        NSArray *arrObj=[dict objectForKey:@"NoteList"];
        if(arrObj)
            for (NSInteger i=0; i<[arrObj count]; i++) {
                [result addObject:[self parseToNoteItem:[arrObj objectAtIndex:i]]];
            }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return result;
}

- (NoteItem*) parseToNoteItem : (NSDictionary*) dict {
    
    NoteItem *item  =    [NoteItem new];
    item.Title      =    [dict objectForKey:@"Title"];
    item.ItemCount  =    [dict objectForKey:@"ItemCount"];
    item.Date       =    [dict objectForKey:@"Date"];
    item.Price      =    [dict objectForKey:@"Price"];
    
    return item;
}



#pragma mark TABLE VIEW DELEGATES

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteTVC"];
    
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NoteTVC" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
        
        NoteItem *n = (( NoteItem* )mNoteItems [ indexPath.row ]);
        cell.Title.text     = n.Title;
        cell.Date.text      = n.Date;
        cell.ItemCount.text = n.ItemCount;
        cell.Price.text     = n.Price;
        
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *presentingVC;
    
    switch (indexPath.row) {
        case 0:
        {
            presentingVC = [[BookVC alloc] initWithNibName:@"BookVC" bundle:nil];
            presentingVC.title = @"BOOKS";
            
            self.navigationItem.title = @"Back";
            [self.navigationController pushViewController:presentingVC animated:YES];
        }
            break;
        case 2:
        {
            presentingVC = [[InvoiceVC alloc] initWithNibName:@"InvoiceVC" bundle:nil];
            presentingVC.title = @"INVOICE";
            
            self.navigationItem.title = @"Back";
            [self.navigationController pushViewController:presentingVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark UITABLEVIEW PROPERTIES
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mNoteItems count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

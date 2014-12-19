//
//  ClientListVC.m
//  Sortr
//
//  Created by KrisMraz on 8/7/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "ClientListVC.h"
#import "AddClientViewController.h"

@interface ClientListVC () <UITableViewDataSource, UITableViewDelegate>
{
    
    NSArray *tableSections;
    NSMutableArray *clientLists;
    NSMutableArray *clients;
}
@end

@implementation ClientListVC

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
    
    tableSections = [NSArray arrayWithObjects:@"#", @"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [self refreshData];
}

- (void) refreshData
{
    clientLists = [NSMutableArray new];
    clientLists = [[SortrDataManager sharedInstance] getAllClients];
    
    clients = [NSMutableArray array];
    
    for (int x = 0; x < tableSections.count; x++) {
        
        NSMutableArray *newArray = [NSMutableArray new];
        [clients addObject:newArray];
    }
    
    for (ClientObject *c in clientLists) {
        
        int index = [self indexOfFirstCharacter:c.name];
        [[clients objectAtIndex:index] addObject:c];
        
    }
    
    [self.clientListTableView reloadData];
}

#pragma mark UITABLEVIEW DELEGATES
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[clients objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 27;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return tableSections;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [tableSections objectAtIndex:section];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"clientcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
    }

    NSMutableArray *clientOnArray = [clients objectAtIndex:indexPath.section];
    ClientObject *client          = (ClientObject*)[clientOnArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:client.name];
    
    return cell;
}

- (IBAction)addClient:(id)sender {
    AddClientViewController *clvc = [[AddClientViewController alloc] init];
    [self presentViewController:clvc animated:YES completion:nil];
}

- (int) indexOfFirstCharacter : (NSString*) clientName {
    
    if (clientName.length == 0) {
        return 0;
    }
    
     NSString *firstLetter = [clientName substringToIndex:1];
    int count = 0;
    
    for (NSString *letter in tableSections) {
        if ([[letter lowercaseString] isEqualToString: [firstLetter lowercaseString]]) {
            return count;
        }
        count++;
    }
    
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

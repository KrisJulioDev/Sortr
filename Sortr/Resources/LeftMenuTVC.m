//
//  LeftMenuTVC.m
//  testProject
//
//  Created by artur on 2/14/14.
//  Copyright (c) 2014 artur. All rights reserved.
//

#import "LeftMenuTVC.h"
#import "NotesVC.h"
#import "SecondVC.h"
#import "ThirdVC.h"
#import "Constants.h"

@interface LeftMenuTVC ()
{
    
}
@end

@implementation LeftMenuTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Initilizing data souce
    self.tableData = [@[@"", @"NOTES",@"TAGS",@"SEARCHES"] mutableCopy];
    
    // Remove lines of cell without data
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (indexPath.row == 0 ) {
        [cell setBackgroundColor:SORTR_BLUE];
        
        UILabel *menuTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 50)];
        [menuTitle setText:@"MENU"];
        [menuTitle setTextColor:[UIColor whiteColor]];
        [menuTitle setFont:BOLD_FONT_WITH_SIZE(20)];
        
        [cell.contentView addSubview:menuTitle];
        
        //Disable Cell selection on first cell
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }else {
        
        cell.textLabel.font = BOLD_FONT_WITH_SIZE(15);
        cell.textLabel.textColor = SORTR_GRAY;
        cell.textLabel.text = self.tableData[indexPath.row];
        
    }
    
    return cell;
}
#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *nvc;
    UIViewController *rootVC;
    
    switch (indexPath.row) {
        case 0: case 1:
        {
            rootVC = [[NotesVC alloc] initWithNibName:@"NotesVC" bundle:nil];
            rootVC.title = @"SORTR";
        }
        break;
        case 2:
        {
            rootVC = [[SecondVC alloc] initWithNibName:@"SecondVC" bundle:nil];
        }
            break;
        case 3:
        {
            rootVC = [[ThirdVC alloc] initWithNibName:@"ThirdVC" bundle:nil];
        }
            break;
        
        default:
            break;
    }
    nvc = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    [self openContentNavigationController:nvc];
}

@end

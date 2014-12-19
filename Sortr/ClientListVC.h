//
//  ClientListVC.h
//  Sortr
//
//  Created by KrisMraz on 8/7/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientListVC : UIViewController

@property (nonatomic, strong) IBOutlet UITableView *clientListTableView;
- (void) refreshData;

@end

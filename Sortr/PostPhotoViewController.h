//
//  PostPhotoViewController.h
//  Sortr
//
//  Created by KrisMraz on 12/19/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <UIKit/UIKit.h>"
#import "AwesomeMenu.h"
#import "ReceiptImageview.h"

@interface PostPhotoViewController : UIViewController <AwesomeMenuDelegate>

@property (nonatomic) UIImage *imageTaken;
@property (strong, nonatomic) IBOutlet ReceiptImageview *receiptImage;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UIButton *setCategoryBtn;
@property (strong, nonatomic) IBOutlet UIButton *setClientBtn; 
@property (strong, nonatomic) IBOutlet UISlider *thresholdSlider;
@property (strong, nonatomic) IBOutlet UILabel *blurinessAmount;
@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic) UIViewController *delegate;

@end

//
//  PostPhotoViewController.h
//  Sortr
//
//  Created by KrisMraz on 12/19/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <UIKit/UIKit.h>"

@interface PostPhotoViewController : UIViewController

@property (nonatomic) UIImage *imageTaken;
@property (strong, nonatomic) IBOutlet UIImageView *receiptImage;
@property (strong, nonatomic) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) IBOutlet UIButton *setCategoryBtn;
@property (strong, nonatomic) IBOutlet UIButton *setClientBtn;

@end

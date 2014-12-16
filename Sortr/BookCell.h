//
//  BookCell.h
//  Sortr
//
//  Created by KrisMraz on 8/6/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *receiptName;
@property (strong, nonatomic) IBOutlet UILabel *receiptPrice;

//PROCESSING UI'S
@property (strong, nonatomic) IBOutlet UIView      *processingView;
@property (strong, nonatomic) IBOutlet UIImageView *receiptImage;
@property (strong, nonatomic) IBOutlet UILabel     *receiptStatus;
@property (strong, nonatomic) IBOutlet UIImageView *statusIcon;

- (void) updateStatusWithPhoto : (UIImage*) img;

@end

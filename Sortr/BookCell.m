//
//  BookCell.m
//  Sortr
//
//  Created by KrisMraz on 8/6/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "BookCell.h"
#import "ThumbCell.h"

@implementation BookCell

- (void)awakeFromNib
{
    // Initialization code
    
}

/**
 *  Update status of cell under categoryViewController
 *
 *  @param status status such as Waiting, Scan, Queue, Done and Audit
 *  @param img    Image to use on update
 */
- (void) updateStatus:(int)status withPhoto : (UIImage*) img {
    
    NSString *statusName = @"";
    UIImage *photoImage = img;
    UIImage *iconImage;
    
    switch (status) {
        case (int)Waiting: case (int)Scan:  case (int)Queue:
            
            statusName = @"PROCESSING...";
            iconImage = [UIImage imageNamed:@"magnifying_icon"];
            
            break;
        case (int)Done: case (int)Audit:
        
              [self.processingView setHidden:YES];
            
            break;
            
        default:
            break;
    }
    
    [self.receiptStatus setText: statusName ];
    [self.receiptImage  setImage: photoImage];
    [self.statusIcon    setImage: iconImage];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

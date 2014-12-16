//
//  BookCell.m
//  Sortr
//
//  Created by KrisMraz on 8/6/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "BookCell.h"

@implementation BookCell
{
    enum Status {
      
        Waiting = 0,
        Scanning,
        Done
        
    };
    
    int cellStatus;
}
- (void)awakeFromNib
{
    // Initialization code
    
    cellStatus = 0;
}

- (void) updateStatusWithPhoto : (UIImage*) img {
    
    NSString *statusName = @"";
    UIImage *photoImage = img;
    UIImage *iconImage;
    
    switch (cellStatus) {
        case (int)Waiting:
            
            statusName = @"WAITING TO SCAN";
            iconImage = [UIImage imageNamed:@"inquiry_icon"];
            
              break;
        case (int)Scanning:
            
            statusName = @"SCANNING...";
            iconImage = [UIImage imageNamed:@"scanning_icon"];
            
            break;
        case (int)Done:
            
              [self.processingView setHidden:YES];
            
            break;
            
        default:
            break;
    }
    
    [self.receiptStatus setText: statusName ];
    [self.receiptImage  setImage: photoImage];
    [self.statusIcon    setImage: iconImage];
    
    cellStatus++;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

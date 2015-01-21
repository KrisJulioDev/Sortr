//
//  ThumbCell.m
//  Sortr
//
//  Created by KrisMraz on 8/6/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "ThumbCell.h"
#import "Constants.h"

@implementation ThumbCell
{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
/**
 *  Set Thumb Image of receipt
 *
 *  @param img image of receipt taken
 */
- (void) assignThumbImage : ( UIImage*) img
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,100)];
  
    imgView.clipsToBounds = YES;
    imgView.image = img ; 
    self.thumbImage = img;
    
    [self.contentView addSubview:imgView];
    
    UIView *dark = [[UIView alloc] init];
    
    [dark setBackgroundColor:[UIColor blackColor]];
    [dark setAlpha:0.5f];
    
}

/**
 *  Update status of receipt
 *
 *  @param status ThumbStatus
 */
- (void) setStatus:(ThumbStatus ) status
{
    NSString *imageName;
    
    for (UIView *blackV in [self.contentView subviews]) {
        if (blackV.tag == BLACK_VIEW_TAG) {
            [blackV removeFromSuperview];
        }
    }
    
    switch ((int)status) {
            
        case Scan: case Waiting: case Queue:
            
                imageName = @"cross_icon";
            
            break;
            
        case Inquiry:
            
                imageName = @"upload_icon" ;
            
            break;
            
        case Done: case Audit:
            
            self.thumbStatus = status;
            imageName = @"approved_icon" ;
            
            break;
            
        default:
            break;
    }
    
    self.thumbStatus = status;
    
    UIView *blackV = [UIView new];
    [blackV setFrame:CGRectMake(0, 0, 100, 100)];
    [blackV setBackgroundColor:[UIColor whiteColor]];
    [blackV.layer setOpacity:0.7f];
    [blackV setTag:BLACK_VIEW_TAG];
    
    UIImageView *imageV = [UIImageView new];
    [imageV setFrame:CGRectMake(30, 25, 40, 40)];
    [imageV setImage:[UIImage imageNamed:imageName ]];
    
    //[self.contentView addSubview:blackV];
    [self.contentView addSubview:imageV];
}


@end

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

- (void) assignThumbImage : ( UIImage*) img
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,100)];
    //imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.clipsToBounds = YES;
    imgView.image = img ; 
    self.thumbImage = img;
    
    [self.contentView addSubview:imgView];
    
    UIView *dark = [[UIView alloc] init];
    
    [dark setBackgroundColor:[UIColor blackColor]];
    [dark setAlpha:0.5f];
    
}

- (void) setStatus:(ThumbStatus ) status
{
    NSString *imageName;
    
    switch ((int)status) {
        case Scan:
            
                imageName = @"scanning_icon";
            
            break;
            
        case Inquiry:
            
                imageName = @"inquiry_icon" ;
            
            break;
            
        case Done:
            
            for (UIView *blackV in [self.contentView subviews]) {
                if (blackV.tag == BLACK_VIEW_TAG) {
                    [blackV removeFromSuperview];
                }
            }
                return;
            
            break;
            
        default:
            break;
    }
    
    UIView *blackV = [UIView new];
    [blackV setFrame:CGRectMake(0, 0, 100, 100)];
    [blackV setBackgroundColor:[UIColor blackColor]];
    [blackV.layer setOpacity:0.5f];
    [blackV setTag:BLACK_VIEW_TAG];
    
    UIImageView *imageV = [UIImageView new];
    [imageV setFrame:CGRectMake(25, 20, 50, 50)];
    [imageV setImage:[UIImage imageNamed:imageName ]];
    
    [blackV addSubview:imageV];
    [self.contentView addSubview:blackV];
}


@end

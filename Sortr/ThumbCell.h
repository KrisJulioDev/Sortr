//
//  ThumbCell.h
//  Sortr
//
//  Created by KrisMraz on 8/6/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface ThumbCell : UICollectionViewCell
{
}

@property (nonatomic) ThumbStatus           thumbStatus;
@property (nonatomic, retain) UIImage       *thumbImage;
@property (nonatomic, retain) NSURL         *imageUrl;

- (void) assignThumbImage   : ( UIImage*) img; 
- (void) setStatus:(ThumbStatus ) status;

@end

//
//  ThumbCell.h
//  Sortr
//
//  Created by KrisMraz on 8/6/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "SortrDataManager.h"

@interface ThumbCell : UICollectionViewCell
{
}

@property (nonatomic) ThumbStatus           thumbStatus;
@property (nonatomic, retain) NSString      *thumbName;
@property (nonatomic, retain) UIImage       *thumbImage;
@property (nonatomic, retain) NSURL         *imageUrl;
@property (nonatomic, retain) NSIndexPath   *indexPath;
@property (nonatomic, retain) ReceiptObject *receiptObject;

- (void) assignThumbImage   : ( UIImage*) img; 
- (void) setStatus:(ThumbStatus ) status;

@end

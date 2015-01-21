//
//  ReceiptImageview.h
//  Sortr
//
//  Created by KrisMraz on 1/14/15.
//  Copyright (c) 2015 TheCoapperative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptImageview : UIImageView

@property (nonatomic) BOOL isEditingModeOn;
- (CGRect)convertRect:(CGRect)sourceRect fromContentSize:(CGSize)sourceSize;
@end

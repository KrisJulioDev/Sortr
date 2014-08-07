//
//  LatoBold.m
//  Sortr
//
//  Created by KrisMraz on 8/5/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "LatoBold.h"
#import "Constants.h"

@implementation LatoBold

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    [self setFont:[UIFont fontWithName:@"Lato-Bol" size:self.font.pointSize]];
    
    
}

@end

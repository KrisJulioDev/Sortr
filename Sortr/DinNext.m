//
//  DinNext.m
//  Sortr
//
//  Created by KrisMraz on 8/5/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "DinNext.h"

@implementation DinNext

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.font = [UIFont fontWithName:@"DINNextLTPro-Light" size:self.font.pointSize];
    }
    
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

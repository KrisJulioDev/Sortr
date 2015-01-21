//
//  ReceiptImageview.m
//  Sortr
//
//  Created by KrisMraz on 1/14/15.
//  Copyright (c) 2015 TheCoapperative. All rights reserved.
//

#import "ReceiptImageview.h"

@implementation ReceiptImageview
{
    CGPoint  startingPoint;
    CGPoint  endPoint;
    
    CGRect      totalRect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_isEditingModeOn) {
        
//        startingPoint = [[touches anyObject] locationInView:self];
        startingPoint = [self convertPoint:[[touches anyObject] locationInView:self] fromContentSize:self.image.size];
        
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent*)event
{
    // We only take care of a single touch
  
        UITouch *touch = [touches anyObject];
        // Find the width and height of the rect
        //drawnFrame.size.width = [touch locationInView:parentView].x - startingPoint.x
        //drawnFrame.size.height = [touch locationInView:parentView].y - startingPoint.y
        
        totalRect.size.width    = [touch locationInView:self.superview].x - startingPoint.x;
        totalRect.size.height   = [touch locationInView:self.superview].y - startingPoint.y;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_isEditingModeOn) {
        NSLog(@"IMAGE TAPPED DONE");
        totalRect = CGRectMake(startingPoint.x, startingPoint.y, totalRect.size.width, totalRect.size.height);
        [self setImage:[ self imageByDrawingCircleOnImage:self.image]];
    }
    
}

- (UIImage *)imageByDrawingCircleOnImage:(UIImage *)image
{
    // begin a graphics context of sufficient size
    UIGraphicsBeginImageContext(image.size);
    
    // draw original image into the context
    [image drawAtPoint:CGPointZero];
    
    // get the context for CoreGraphics
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // set stroking color and draw circle
    [[UIColor redColor] setStroke];
    
    // make circle rect 5 px from border
    
    CGRect circleRect = totalRect;  
    circleRect = CGRectInset(circleRect, 15, 15);
    
    // draw circle
    CGContextStrokeEllipseInRect(ctx, circleRect);
    
    // make image out of bitmap context
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // free the context
    UIGraphicsEndImageContext();
    
    return retImage;
}

- (CGPoint)convertPoint:(CGPoint)sourcePoint fromContentSize:(CGSize)sourceSize {
    CGPoint targetPoint = sourcePoint;
    CGSize  targetSize  = self.bounds.size;
    
    CGFloat ratioX = targetSize.width / sourceSize.width;
    CGFloat ratioY = targetSize.height / sourceSize.height;
    
    if (self.contentMode == UIViewContentModeScaleToFill) {
        targetPoint.x *= ratioX;
        targetPoint.y *= ratioY;
    }
    else if(self.contentMode == UIViewContentModeScaleAspectFit) {
        CGFloat scale = MIN(ratioX, ratioY);
        
        targetPoint.x *= scale;
        targetPoint.y *= scale;
        
        targetPoint.x += (self.frame.size.width - sourceSize.width * scale) / 2.0f;
        targetPoint.y += (self.frame.size.height - sourceSize.height * scale) / 2.0f;
    }
    else if(self.contentMode == UIViewContentModeScaleAspectFill) {
        CGFloat scale = MAX(ratioX, ratioY);
        
        targetPoint.x *= scale;
        targetPoint.y *= scale;
        
        targetPoint.x += (self.frame.size.width - sourceSize.width * scale) / 2.0f;
        targetPoint.y += (self.frame.size.height - sourceSize.height * scale) / 2.0f;
    }
    
    return targetPoint;
}

- (CGRect)convertRect:(CGRect)sourceRect fromContentSize:(CGSize)sourceSize {
    CGRect targetRect = sourceRect;
    CGSize targetSize  = self.bounds.size;
    
    CGFloat ratioX = targetSize.width / sourceSize.width;
    CGFloat ratioY = targetSize.height / sourceSize.height;
    
    if (self.contentMode == UIViewContentModeScaleToFill) {
        targetRect.origin.x *= ratioX;
        targetRect.origin.y *= ratioY;
        
        targetRect.size.width *= ratioX;
        targetRect.size.height *= ratioY;
    }
    else if(self.contentMode == UIViewContentModeScaleAspectFit) {
        CGFloat scale = MIN(ratioX, ratioY);
        
        targetRect.origin.x *= scale;
        targetRect.origin.y *= scale;
        
        targetRect.origin.x += (self.frame.size.width - sourceSize.width * scale) / 2.0f;
        targetRect.origin.y += (self.frame.size.height - sourceSize.height * scale) / 2.0f;
        
        targetRect.size.width *= scale;
        targetRect.size.height *= scale;
    }
    else if(self.contentMode == UIViewContentModeScaleAspectFill) {
        CGFloat scale = MAX(ratioX, ratioY);
        
        targetRect.origin.x *= scale;
        targetRect.origin.y *= scale;
        
        targetRect.origin.x += (self.frame.size.width - sourceSize.width * scale) / 2.0f;
        targetRect.origin.y += (self.frame.size.height - sourceSize.height * scale) / 2.0f;
        
        targetRect.size.width *= scale;
        targetRect.size.height *= scale;
    }
    
    return targetRect;
}


@end

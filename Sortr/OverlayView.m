//
//  OverlayView.m
//  OverlayViewTester
//
//  Created by Jason Job on 09-12-10.
//  Copyright 2009 Jason Job. All rights reserved.
//

#import "OverlayView.h"
#import "ScanButton.h"


@implementation OverlayView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		// Clear the background of the overlay:
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		
        //Add UI Button
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 450, 60, 30)];
        [closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
        
        
		// Load the image to show in the overlay:
		UIImage *overlayGraphic = [UIImage imageNamed:@"overlaygraphic.png"];
		UIImageView *overlayGraphicView = [[UIImageView alloc] initWithImage:overlayGraphic];
		overlayGraphicView.frame = CGRectMake(30, 70, 260, 350);
		[self addSubview:overlayGraphicView];
 		
		ScanButton *scanButton = [[ScanButton alloc] initWithFrame:CGRectMake(130, 450, 60, 30)];
		
		// Add a target action for the button:
		[scanButton addTarget:self action:@selector(scanButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:scanButton];
        
        [closeBtn addTarget:self action:@selector(closeCamera) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }
    return self;
}

/**
 *  Close camera callback
 */
- (void) closeCamera
{
    [_delegate dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  Customized Button callback
 */
- (void) scanButtonTouchUpInside {
	UILabel *scanningLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 120, 30)];
	scanningLabel.backgroundColor = [UIColor clearColor];
	scanningLabel.font = [UIFont fontWithName:@"Courier" size: 18.0];
	scanningLabel.textColor = [UIColor redColor]; 
	scanningLabel.text = @"Scanning...";
	
	[self addSubview:scanningLabel];
	
	[self performSelector:@selector(clearLabel:) withObject:scanningLabel afterDelay:2];
    
    if ([_delegate isKindOfClass:[UIImagePickerController class]]) {
        
        UIImagePickerController *delegate = (UIImagePickerController*)_delegate;
        [delegate takePicture];
        
    }
 }

- (void)clearLabel:(UILabel *)label {
	label.text = @"";
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
 }


@end

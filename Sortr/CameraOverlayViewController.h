//
//  CameraOverlayViewController.h
//  Sortr
//
//  Created by KrisMraz on 1/8/15.
//  Copyright (c) 2015 TheCoapperative. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreMotion/CoreMotion.h>

@interface CameraOverlayViewController : UIViewController
{
    double currentMaxAccelX;
    double currentMaxAccelY;
    double currentMaxAccelZ;
    double currentMaxRotX;
    double currentMaxRotY;
    double currentMaxRotZ;
    
    CMMotionManager *motionManager;
}
@end

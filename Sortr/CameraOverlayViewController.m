//
//  CameraOverlayViewController.m
//  Sortr
//
//  Created by KrisMraz on 1/8/15.
//  Copyright (c) 2015 TheCoapperative. All rights reserved.
//

#import "CameraOverlayViewController.h"
#import "PostPhotoViewController.h"

@interface CameraOverlayViewController () < UIImagePickerControllerDelegate >

@end

@implementation CameraOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.opaque = NO;
    self.view.backgroundColor = [UIColor clearColor];
    
    //MOTION MANAGER ----
    motionManager = [[CMMotionManager alloc] init];
    
    motionManager.accelerometerUpdateInterval = .2;
    motionManager.gyroUpdateInterval = .2;
    
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                        withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                            [self outputAccelertionData:accelerometerData.acceleration];
                                            if(error){
                                                NSLog(@"%@", error);
                                            }
                                        }];
    
    [motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                               withHandler:^(CMGyroData *gyroData, NSError *error) {
                                   
                                   [self outputRotationData:gyroData.rotationRate];
                                   
                               }];
 
    
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *sourceImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    NSData *data = UIImageJPEGRepresentation(sourceImage, 1.0f);
    UIImage *tmp = [UIImage imageWithData:data];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        PostPhotoViewController *ppv = [[PostPhotoViewController alloc] init];
        ppv.imageTaken = tmp;
        [self.navigationController presentViewController:ppv animated:YES completion:nil];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    
    //self.accX.text = [NSString stringWithFormat:@" %.2fg",acceleration.x];
    if(fabs(acceleration.x) > fabs(currentMaxAccelX))
    {
        currentMaxAccelX = acceleration.x;
    }
    //self.accY.text = [NSString stringWithFormat:@" %.2fg",acceleration.y];
    if(fabs(acceleration.y) > fabs(currentMaxAccelY))
    {
        currentMaxAccelY = acceleration.y;
    }
    //self.accZ.text = [NSString stringWithFormat:@" %.2fg",acceleration.z];
    if(fabs(acceleration.z) > fabs(currentMaxAccelZ))
    {
        currentMaxAccelZ = acceleration.z;
    }
    
    //self.maxAccX.text = [NSString stringWithFormat:@" %.2fg",currentMaxAccelX];
    //self.maxAccY.text = [NSString stringWithFormat:@" %.2fg",currentMaxAccelY];
    //self.maxAccZ.text = [NSString stringWithFormat:@" %.2fg",currentMaxAccelZ];
    
//    NSLog(@"X: %.2f Y: %.2f Z: %.2f", currentMaxAccelX, currentMaxAccelY, currentMaxAccelZ);
}
-(void)outputRotationData:(CMRotationRate)rotation
{
    
    //self.rotX.text = [NSString stringWithFormat:@" %.2fr/s",rotation.x];
    if(fabs(rotation.x) > fabs(currentMaxRotX))
    {
        currentMaxRotX = rotation.x;
    }
    //self.rotY.text = [NSString stringWithFormat:@" %.2fr/s",rotation.y];
    if(fabs(rotation.y) > fabs(currentMaxRotY))
    {
        currentMaxRotY = rotation.y;
    }
    //self.rotZ.text = [NSString stringWithFormat:@" %.2fr/s",rotation.z];
    if(fabs(rotation.z) > fabs(currentMaxRotZ))
    {
        currentMaxRotZ = rotation.z;
    }
    
    //self.maxRotX.text = [NSString stringWithFormat:@" %.2f",currentMaxRotX];
    //self.maxRotY.text = [NSString stringWithFormat:@" %.2f",currentMaxRotY];
    //self.maxRotZ.text = [NSString stringWithFormat:@" %.2f",currentMaxRotZ];
    
    // NSLog(@"X: %.2f Y: %.2f Z: %.2f", currentMaxRotX, currentMaxRotY, currentMaxRotZ);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

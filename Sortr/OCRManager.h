//
//  OCRManager.h
//  Sortr
//
//  Created by KrisMraz on 8/8/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Client.h"
#import "ThumbCell.h"

@interface OCRManager : NSObject <ClientDelegate>

+ (instancetype) sharedInstance;
- (void) processImage : (ThumbCell*) thumbCell withDelegate:(UIViewController*) del;
- (void) fetchPhotoLibToApp : ( UIViewController*) sender;

@end

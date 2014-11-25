//
//  SortrSessionManager.h
//  Sortr
//
//  Created by KrisMraz on 9/9/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThumbCell.h"

@interface SortrSessionManager : NSObject


+(instancetype)sharedInstance;
- (void) requestPhotoUploadTask     : (NSURL*) filePathUrl;
//- (void) uploadPhotoToServer        : (NSURL*) filePathUrl;
- (void) uploadPhotoToServer         : (ThumbCell*) cell;

@end

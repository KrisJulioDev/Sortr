//
//  SortrDataManager.h
//  Sortr
//
//  Created by KrisMraz on 8/13/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortrDataManager : NSObject


+(instancetype)sharedInstance;


@property (retain) NSMutableArray *bookItems;

@end

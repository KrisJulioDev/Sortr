//
//  SortrDataManager.m
//  Sortr
//
//  Created by KrisMraz on 8/13/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "SortrDataManager.h"

@implementation SortrDataManager

+(instancetype)sharedInstance
{
    static dispatch_once_t  once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [[self alloc] init];
                  });
    
    return sharedInstance;
}

@end

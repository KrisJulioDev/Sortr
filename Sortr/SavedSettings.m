//
//  SavedSettings.m
//  Sortr
//
//  Created by KrisMraz on 12/17/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "SavedSettings.h"
#import "Constants.h"


@implementation SavedSettings

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

+ (NSString*) settingsCountryName {
    return [ [NSUserDefaults standardUserDefaults] stringForKey: kSavedCountryName ];
}

+ (NSString*) settingsCountryCode {
    return [ [NSUserDefaults standardUserDefaults] stringForKey: kSavedCountryCode ];
}

+ (void) setInvoiceTotal:(float) value
{
    [[NSUserDefaults standardUserDefaults] setFloat:value forKey:kSavedInvoiceTotal];
}

+ (float) getInvoiceTotal {
    return [[NSUserDefaults standardUserDefaults] floatForKey: kSavedInvoiceTotal ];
}

@end

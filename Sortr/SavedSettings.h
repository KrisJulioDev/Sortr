//
//  SavedSettings.h
//  Sortr
//
//  Created by KrisMraz on 12/17/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>


@interface SavedSettings : NSObject

+(instancetype)sharedInstance;
+ (NSString*) settingsCountryName;
+ (NSString*) settingsCountryCode;

+ (void) setInvoiceTotal:(float) value;
+ (float) getInvoiceTotal;
@end

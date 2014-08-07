//
//  Utilities.h
//  Sortr
//
//  Created by KrisMraz on 8/6/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+(NSString *)getPresentDateTime;
+(NSString *)documentsPath:(NSString *)fileName;

+(void)showActivityIndicator:(UIViewController*)sender;

@end

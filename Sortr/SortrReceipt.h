//
//  SortrReceipt.h
//  Sortr
//
//  Created by KrisMraz on 12/2/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortrReceipt : NSObject


@property (nonatomic) NSString  *receipt_name;
@property (nonatomic) NSString  *receipt_date;
@property (nonatomic) UIImage   *receipt_image;

+ (NSString*) lookFor:(NSString*)searchOption onThis: (NSString*) stringData;

@end

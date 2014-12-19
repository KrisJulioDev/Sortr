//
//  ReceiptData.h
//  Sortr
//
//  Created by KrisMraz on 12/4/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Realm/Realm.h>

@interface ReceiptData : RLMObject

@property  NSString  *receiptId;
@property  NSData    *image;
@property  NSString  *category;
@property  NSString  *branch;
@property  NSString  *total;
@property  NSString  *vat;
@property  NSString   *date;

@end

//
//  ReceiptData.h
//  Sortr
//
//  Created by KrisMraz on 12/4/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface ReceiptData : NSManagedObject


@property (nonatomic, retain)   NSString  *id;
@property (nonatomic, retain)   NSData    *image;
@property (nonatomic, retain)   NSString  *category;
@property (nonatomic, retain)   NSString  *branch;
@property (nonatomic)           NSString  *total;
@property (nonatomic)           NSString  *vat;
@property (nonatomic, retain)   NSString   *date;

@end

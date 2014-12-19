//
//  SortrDataManager.h
//  Sortr
//
//  Created by KrisMraz on 8/13/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "Constants.h"

@interface ReceiptObject : RLMObject

@property  NSString  *receiptId;
@property  NSData    *image;
@property  NSString  *category;
@property  NSString  *branch;
@property  NSString  *total;
@property  NSString  *vat;
@property  NSString  *date;
@property  NSString  *client;
@property  int        receiptStatus;

@end


@interface ClientObject : RLMObject

@property NSString *name;
@property NSString *address;
@property NSString *phone;

@end

@interface CategoryObject : RLMObject
@property NSString *name;
@end
  

@interface SortrDataManager : NSObject


@property (retain           ) NSMutableArray *bookItems;
@property (nonatomic, retain) NSMutableArray *categoryLists;

+(instancetype)sharedInstance;

- (void) saveTotalData:(NSString*)rid
              category:(NSString*)category
                 image:(NSData*) imageData
             withTotal:(NSString*)total
                   vat:(NSString*)value
                branch:(NSString*)name
           receiptDate:(NSString*)date
            clientName:(NSString*)clientName
         receiptStatus:(int)status;

- (void) updateReceipt : (NSString*) tempId
         withOfficialID:(NSString*)officialID
               category:(NSString*)category
              withTotal:(NSString*)total
                    vat:(NSString*)value
                 branch:(NSString*)name
            receiptDate:(NSString*)date
             clientName:(NSString*)clientName
          receiptStatus:(int)status;

- (void) saveClientWithName:(NSString*) name address:(NSString*)address andPhone:(NSString*)phone;

- (void) saveNewStatus:(NSString*)receiptId withStatus: (int) status;
- (void) saveCategoryWithName:(NSString*) name;

- (NSMutableArray*) getAllReceiptData;
- (NSMutableArray*) getAllClients;
- (NSMutableArray*) getAllCategories;

@end

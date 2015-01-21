//
//  SortrDataManager.m
//  Sortr
//
//  Created by KrisMraz on 8/13/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "SortrDataManager.h"
#import "ReceiptData.h"
#import <Realm/Realm.h>

@implementation ReceiptObject
//NO IMPLEMENTATION
@end

@implementation ClientObject
//NO IMPLEMENTATION
@end

@implementation CategoryObject
//NO IMPLEMENTATION
@end

RLM_ARRAY_TYPE(ReceiptObject)

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

#pragma RECEIPTS OBJECT
- (void) saveTotalData:(NSString*)rid
                  uuid:(NSString*)uuid
              category:(NSString*)category
                 image:(NSData*) imageData
             withTotal:(NSString*)total
                   vat:(NSString*)value
                branch:(NSString*)name
           receiptDate:(NSString*)date
            clientName:(NSString*)clientName
         receiptStatus:(int)status{
    
    ReceiptObject *receiptobj =  [[ReceiptObject alloc] init];
    
    receiptobj.receiptId     = rid;
    receiptobj.receiptUUID   = uuid;
    receiptobj.image         = imageData;
    receiptobj.category      = category;
    receiptobj.total         = total;
    receiptobj.vat           = value;
    receiptobj.branch        = name;
    receiptobj.date          = date;
    receiptobj.client        = clientName;
    receiptobj.receiptStatus = status;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:receiptobj];
    [realm commitWriteTransaction];
}

- (void) saveNewStatus:(NSString*)receiptId withStatus: (int) status {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    RLMResults *results =  [ReceiptObject objectsWhere:[NSString stringWithFormat:@"receiptId contains '%@'", receiptId]];
    if (results) {
        ReceiptObject *object   = (ReceiptObject*)[results objectAtIndex:0];
        object.receiptStatus    = status;
    }
    
    [realm commitWriteTransaction];
    
}

- (void) updateReceipt : (NSString*) tempId
         withOfficialID:(NSString*)officialID
               category:(NSString*)category
              withTotal:(NSString*)total
                    vat:(NSString*)value
                 branch:(NSString*)name
            receiptDate:(NSString*)date
             clientName:(NSString*)clientName
          receiptStatus:(int)status  {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *results =  [ReceiptObject objectsInRealm:realm where:[NSString stringWithFormat:@"receiptId contains '%@'", tempId]];
    
    if ([ results count ] > 0) {
            [realm beginWriteTransaction];
            
            ReceiptObject *receiptobj = (ReceiptObject*)results[0];
            
            receiptobj.receiptId     = officialID;
            receiptobj.category      = category;
            receiptobj.total         = total;
            receiptobj.vat           = value;
            receiptobj.branch        = name;
            receiptobj.date          = date;
            receiptobj.client        = clientName;
            receiptobj.receiptStatus = status;
            
            [realm commitWriteTransaction];
        
    }
    else {
        results =  [ReceiptObject objectsInRealm:realm where:[NSString stringWithFormat:@"receiptId contains '%@'", officialID]];
        
        if ([results count] > 0) {
            [realm beginWriteTransaction];
            
            ReceiptObject *receiptobj = (ReceiptObject*)results[0];
            
            receiptobj.receiptId     = officialID;
            receiptobj.category      = category;
            receiptobj.total         = total;
            receiptobj.vat           = value;
            receiptobj.branch        = name;
            receiptobj.date          = date;
            receiptobj.receiptStatus = status;
            
            [realm commitWriteTransaction];
        }
    }
    
}

- (NSMutableArray*) getAllReceiptData {
     
    NSMutableArray *arrayOfReceipts =  [NSMutableArray new];
    for (ReceiptObject *receipt in [ReceiptObject allObjects]) {
        [arrayOfReceipts addObject:receipt];
    }
    
    return arrayOfReceipts;
}

#pragma mark CLIENT OBJECT
- (void) saveClientWithName:(NSString*) name address:(NSString*)address andPhone:(NSString*)phone
{
    if (name.length == 0) {
        NSLog(@"FAILED TO SAVE, NAME IS NULL");
        return;
    }
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *results =  [ClientObject objectsInRealm:realm where:[NSString stringWithFormat:@"name contains '%@'", name]];
    
    if (results.count > 0) {
        return;
    }
    
    ClientObject *newClient = [[ClientObject alloc] init];
    
    newClient.name = name;
    newClient.address = address;
    newClient.phone = phone;
    
    [realm beginWriteTransaction];
    [realm addObject:newClient];
    [realm commitWriteTransaction];
}

- (NSMutableArray*) getAllClients
{
    NSMutableArray *arrayOfClients = [NSMutableArray new];
    
    for (ClientObject *receipt in [ClientObject allObjects]) {
        [arrayOfClients addObject:receipt];
    }
    
    return arrayOfClients;
}

#pragma mark CATEGORY
- (void) saveCategoryWithName:(NSString*) name
{
    if (name.length == 0) {
        NSLog(@"FAILED TO SAVE, NAME IS NULL");
        return;
    }
    
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *results =  [CategoryObject objectsInRealm:realm where:[NSString stringWithFormat:@"name contains '%@'", name]];
    
    if (results.count > 0) {
        return;
    }
    
    CategoryObject  *newCategory = [[CategoryObject alloc] init];
    newCategory.name = name;
    
    
    [realm beginWriteTransaction];
    [realm addObject:newCategory];
    [realm commitWriteTransaction];
}

- (NSMutableArray*) getAllCategories
{
    NSMutableArray *arrayOfCategories = [NSMutableArray new];
    
    for (CategoryObject *cat in [CategoryObject allObjects]) {
        [arrayOfCategories addObject:cat];
    }
    
    return arrayOfCategories;
}

#pragma mark DELETE REALM OBJECT
- (void) deleteReceipt: ( ReceiptObject* ) receipt
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults *results =  [ReceiptObject objectsInRealm:realm where:[NSString stringWithFormat:@"receiptUUID contains '%@'", receipt.receiptUUID]];
    
    if (results.count == 0) {
        return;
    }
    
    [realm beginWriteTransaction];
    [realm deleteObject:[results objectAtIndex:0]];
    [realm commitWriteTransaction];
}

- (void) deleteCategory: (NSString*) category {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    RLMResults *results = [CategoryObject objectsInRealm:realm where:[NSString stringWithFormat:@"name contains '%@'", category]];
    
    if (results.count == 0) {
        return;
    }
    
    /**
     *  Delete receipt under this deleted category
     */
    for (ReceiptObject *receipt in [ReceiptObject allObjects]) {
        if ([receipt.category isEqualToString:category]) {
            [self deleteReceipt:receipt];
        }
    }
    
    [realm beginWriteTransaction];
    [realm deleteObject:[results objectAtIndex:0]];
    [realm commitWriteTransaction];
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

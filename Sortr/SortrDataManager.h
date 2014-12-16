//
//  SortrDataManager.h
//  Sortr
//
//  Created by KrisMraz on 8/13/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SortrDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext       *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel         *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (retain           ) NSMutableArray *bookItems;
@property (nonatomic, retain) NSMutableArray *categoryLists;

+(instancetype)sharedInstance;

- (void) saveTotalData:(NSString*)rid
              category:(NSString*)category
                 image:(NSData*) imageData
             withTotal:(NSString*)total
                   vat:(NSString*)value
                branch:(NSString*)name
           receiptDate:(NSString*)date;

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *) manageObjectModel;
- (NSManagedObjectContext *)managedObjectContext;
- (NSArray*) getAllReceiptData;
@end

//
//  OCRManager.m
//  Sortr
//
//  Created by KrisMraz on 8/8/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "OCRManager.h"
#import "Constants.h"
#import "SortrDataManager.h"
#import "ThumbCell.h"
#import "Utilities.h"
#import "BookVC.h"
#import "SortrReceipt.h"

#import <AssetsLibrary/AssetsLibrary.h>

@implementation OCRManager 
{
    SortrDataManager *sortrMngr;
    ThumbCell *processingCell;
    
    UIViewController *senderDelegate;
}

+ (instancetype) sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once ( &once, ^{
        sharedInstance = [[self alloc] init];
        
        [sharedInstance initialize];
    });
    return sharedInstance;
}

- (void) initialize
{
    sortrMngr               = [SortrDataManager sharedInstance];
    sortrMngr.bookItems     = (sortrMngr.bookItems == nil) ? [NSMutableArray new] : sortrMngr.bookItems;
    
}

#pragma mark Photo Library Fetch
/**** :::: FETCH ALL IMAGES FROM PHONE LIBRARY ::::: ****/
- (void) fetchPhotoLibToApp : ( UIViewController*) sender
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        NSString * groupName = [group valueForProperty:ALAssetsGroupPropertyName];
        NSLog(@"GROUP NAME %@", groupName);
        
        if( [groupName isEqualToString:kJobPhotoGroup] ) {
            
            // Within the group enumeration block, filter to enumerate just photos.
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            
            // Chooses the photo at the last index
            [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop)
             {
                 if (alAsset) {
                     ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                     UIImage *latestPhoto = [UIImage imageWithCGImage:[representation fullScreenImage]];
                     
                     // Stop the enumerations
                     *stop = YES;
                     
                     ThumbCell *bookCell = [[ThumbCell alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                     
                     bookCell.thumbImage    = latestPhoto;
                     bookCell.thumbStatus        = Done;
                     
                     [sortrMngr.bookItems addObject:bookCell];
                     
                 }
             }];
            
            if (group == nil) {
                [Utilities hideActivityIndicator:sender];
            }
        }
        
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
        NSLog(@"No groups");
    }];
}

- (void) processImage : (ThumbCell*) thumbCell withDelegate:(UIViewController*) del
{ 
	Client *client = [[Client alloc] initWithApplicationID:MyApplicationID password:MyPassword];
	[client setDelegate:self]; 
    
    senderDelegate = del;
    processingCell = thumbCell;
    
	if(     [[NSUserDefaults standardUserDefaults] objectForKey:@"installationID"] == nil
       ||   [[[NSUserDefaults standardUserDefaults] objectForKey:@"installationID"] isKindOfClass:[NSNull class]]
       )
    {
		NSString* deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
		
		NSLog(@"First run: obtaining installation ID..");
		NSString* installationID = [client activateNewInstallation:deviceID];
		NSLog(@"Done. Installation ID is \"%@\"", installationID);
		
		[[NSUserDefaults standardUserDefaults] setValue:installationID forKey:@"installationID"];
	}
	
	NSString* installationID = [[NSUserDefaults standardUserDefaults] stringForKey:@"installationID"];
	
	client.applicationID = [client.applicationID stringByAppendingString:installationID];
	
	ProcessingParams* params = [[ProcessingParams alloc] init];
    
	[client processImage:thumbCell.thumbImage withParams:params];
}

#pragma mark OCR CLIENT DELEGATES
- (void)clientDidFinishUpload:(Client *)sender
{
	NSLog(@"Processing image...");
}

- (void)clientDidFinishProcessing:(Client *)sender
{
	NSLog(@"Downloading result...");
}

- (void)client:(Client *)sender didFinishDownloadData:(NSData *)downloadedData
{
    NSString* result = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
    
    [(BookVC*)senderDelegate processingFinished];
    
    NSLog(@"Finish download... \n%@", result);
    
    NSString *totalAmount   = [SortrReceipt lookFor:kSearchTotal onThis:result];
    NSString *vatAmount     = [SortrReceipt lookFor:kSearchVat onThis:result];
    NSString *date          = [SortrReceipt lookFor:kSearchDate onThis:result];
    NSString *branch        = [SortrReceipt lookFor:kSearchBranch onThis:result];
    
    NSLog(@"TOTAL AMOUNT IS :       %@", totalAmount);
    NSLog(@"VAT AMOUNT IS :         %@", vatAmount  );
    NSLog(@"DATE IS :               %@", date       );
    NSLog(@"BRANCH IS :             %@", branch     );
    
    if ([totalAmount intValue] > 0) {
        
//        [[SortrDataManager sharedInstance] saveTotalData:@"Entertainment" withTotal:totalAmount vat:vatAmount branch:date receiptDate:branch];
        [(BookVC*)senderDelegate openReceiptOnInvoice];
        
    } else {
        NSLog(@"VALUE NOT FOUND ...");
        [Utilities hideActivityIndicator:(BookVC*)senderDelegate];
    }
}

- (void)client:(Client *)sender didFailedWithError:(NSError *)error
{
	NSLog(@"ERROR ...");
    [Utilities hideActivityIndicator:(BookVC*)senderDelegate];
}

@end

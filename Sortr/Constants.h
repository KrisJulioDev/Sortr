//
//  Constants.h
//  Sortr
//
//  Created by KrisMraz on 8/4/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kJobPhotoGroup @"Job Photo"

/** SERVER URL ADDRESS FOR UPLOAD / DOWNLOAD**/
#define UPLOAD_URL                  @"http://dev.asksortr.com:8080/uploadImage"
#define GET_STATUS_URL              @"http://dev.asksortr.com:8080/getStatus/"

/* COLORS */
#define SORTR_BLUE                  [UIColor colorWithRed:90/255.0f green:206/255.0f blue:255/255.0f alpha:1.0f]
#define SORTR_ORANGE                [UIColor colorWithRed:249/255.0f green:155/255.0f blue:14/255.0f alpha:1.0f]
#define SORTR_GRAY                  [UIColor colorWithRed:99/255.0f green:99/255.0f blue:99/255.0f alpha:1.0f]

/* FONTS */
#define REGULAR_FONT_WITH_SIZE(ss)   [UIFont fontWithName:@"Helvetica Neue" size:ss]
#define LIGHT_FONT_WITH_SIZE(ss)     [UIFont fontWithName:@"ProximaNova-Light" size:ss]
#define BOLD_FONT_WITH_SIZE(ss)      [UIFont fontWithName:@"DINNextLTPro-Bold" size:ss]
#define SEMIBOLD_FONT_WITH_SIZE(ss)  [UIFont fontWithName:@"ProximaNova-Semibold" size:ss]
#define ITALIC_FONT_WITH_SIZE(ss)    [UIFont fontWithName:@"ProximaNova-RegularIt" size:ss]

/* RESOLUTION */
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0f)
#define IS_IOS7 ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 7)

/* TAGS */
#define ACTIVITY_INDICATOR_VIEW_TAG     1001
#define BLACK_VIEW_TAG                  1002

/* CLIENT ID */
static NSString* MyApplicationID = @"helloocr123";
// Password should be sent to your e-mail after application was created
static NSString* MyPassword =   @"YhdtrudBX+//NgBvhX9P8LdL";

/* SEARCH STRINGS from PLIST */ 
#define kSearchTotal    @"Total"
#define kSearchVat      @"Vat"
#define kSearchDate     @"Date"
#define kSearchBranch   @"Branch"

#define kSavedCountryName @"c_name"
#define kSavedCountryCode @"c_code"
#define kSavedInvoiceTotal @"invoice_total"

#define APP_DELEGATE    (SortrAppDelegate*)[[UIApplication sharedApplication] delegate]

typedef enum {
    
    Waiting = 0,
    Scan,
    Queue,
    Audit,
    Done,
    Inquiry,
    
}ThumbStatus;

@protocol Constants <NSObject>

@end

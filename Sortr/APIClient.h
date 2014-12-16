//
//  APIClient.h
//  Sortr
//
//  Created by KrisMraz on 12/2/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperationManager.h>
#import "ResponseObject.h"
#import "ThumbCell.h"

//JSON Keys
#define kJSONSuccess					200
#define kJSONInternalNetworkError       500
#define kJSONParseError					-1
#define kJSONUnauthorizedError			401
#define kJSONForbiddenError				403
#define kJSONPaymentRequiredError		402
#define kJSONPreconditionFailedError	412
#define kJSONRequestTimeoutError		408
#define kJSONConflictError				409
#define kJSONBadRequestError			400
#define kJSONNotFoundError				404
#define kJSONNoInternetConnection       0

#define kJSONErrorKey					@"errors"
#define kJSONMessageKey					@"message"
#define kJSONDataKey					@"data"

@interface APIClient : NSObject

@property (nonatomic, retain) id delegate;

+ (instancetype)sharedInstance;
- ( void ) exportImageData : ( ThumbCell* ) photoData andBlock:(void (^)(ResponseObject *responseObject))block;
- (void)processOperation:(AFHTTPRequestOperation *)operation withData:(id)responseObject block:(void (^)(ResponseObject *))block;

@end

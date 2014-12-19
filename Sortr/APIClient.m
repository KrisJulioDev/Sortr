//
//  APIClient.m
//  Sortr
//
//  Created by KrisMraz on 12/2/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "APIClient.h"
#import "BookCell.h"
#import "ResponseObject.h"
#import "CategoryViewController.h"
#import <AFHTTPRequestOperationManager.h>

@implementation APIClient

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- ( void ) exportImageData : ( BookCell* ) photoData withParamter:(NSDictionary*)parameter andBlock:(void (^)(ResponseObject *responseObject))block {
    
    NSData *imageData = UIImageJPEGRepresentation(photoData.receiptImageDone.image, 1);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:UPLOAD_URL parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData
                                    name:@"files"
                                fileName:@"image_name.jpeg"
                                mimeType:@"image/jpeg"];
        
        // etc.
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        
        if ([self.delegate respondsToSelector:@selector(exportReceiptCallback:success:)]) {
            [self.delegate exportReceiptCallback:self success:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if ([self.delegate respondsToSelector:@selector(exportReceiptCallback:failed:)]) {
            [self.delegate exportReceiptCallback:self failed:error];
        }
    }];
}

/*
 * Process response
 */
- (void) processOperation:(AFHTTPRequestOperation *)operation withData:(id)responseObject block:(void (^)(ResponseObject *))block {
    //If response code != 200 --> Failed
    NSLog(@"API: [%@]. Status code: [%d]", operation.request.URL.absoluteString, [operation.response statusCode]);
    
    if ([operation.response statusCode] != kJSONSuccess) {
        NSError *errorParser = nil;
        NSDictionary *responseDict;
        if (operation.responseData) {
            responseDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&errorParser];
        } else {
            responseDict = nil;
        }
        
        NSLog(@"Server response dict: %@", responseDict);
        NSString *message = @"";
        if (responseDict && !errorParser) {
            message = [responseDict objectForKey:@"message"];
        } else {
            message = operation.responseString;
        }
        
        NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, @"message", nil];
        
        NSError *error = [[NSError alloc] initWithDomain:operation.request.URL.absoluteString code:operation.response.statusCode userInfo:userInfo];
        [self handleFailed:error block:block];
        return;
    }
    [self handleSuccess:responseObject block:block];
}

/*
 * Handle Success Operation
 */
- (void)handleSuccess:(id)responseData block:(void (^)(ResponseObject *responseObject))block
{
    if (block) {
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"Server response string: %@", responseString);
        
        NSError *error = nil;
        NSDictionary *responseDict;
        if (responseData) {
            
            responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
            
        } else {
            responseDict = nil;
        }
        
        NSLog(@"Server response dict: %@", responseDict);
        
        ResponseObject *responseObject = [[ResponseObject alloc] init];
        
        if (error) {
            NSLog(@"Parse Error: %@",[error description]);
            //			responseObject.errorCode = kJSONParseError; //Error code for decode error
            //			responseObject.data = nil;
            //			responseObject.message = @"Server error!";
            
            responseObject.errorCode = kJSONSuccess;
            responseObject.data = nil;
            responseObject.message = responseString;
        } else {
            responseObject.errorCode = kJSONSuccess;
            //			responseObject.data = [responseDict objectForKey:kJSONDataKey];
            responseObject.data=responseDict;
            responseObject.message = @"Success!";
        }
        
        block(responseObject);
    }
}

/*
 * Handle Failed Operation
 */
- (void)handleFailed:(NSError *)error block:(void (^)(ResponseObject *responseObject))block
{
    if (block) {
        ResponseObject *responseObject = [[ResponseObject alloc] init];
        
        responseObject.errorCode = error.code;
        responseObject.data = nil;
        responseObject.message = [error.userInfo objectForKey:@"message"];
        
        NSLog(@"API Error: \n{\n\tURL: %@\n\tError: %d\n\tResponse: %@\n}",error.domain, error.code, responseObject.message);
        block(responseObject);
    }
}

- (void) getReceiptStatus : ( int ) r_id {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSString *requestUrl = [NSString stringWithFormat:@"%@%i", GET_STATUS_URL, r_id];
    
    [manager GET:requestUrl  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dictResponse = (NSDictionary*)responseObject;
        
        if ([self.delegate respondsToSelector:@selector(receiptHTTPClient:didUpdateWithStatus:)]) {
            [self.delegate receiptHTTPClient:r_id didUpdateWithStatus:[dictResponse objectForKey:@"data"]];
             
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ERROR ON GET :%@ ", error);
        
    }];
    
    
}
@end

//
//  ResponseObject.h

//  Created by Mr Lemon.
//  Copyright (c) 4Gsecure. All rights reserved.

//

#import <Foundation/Foundation.h>

@interface ResponseObject : NSObject

@property (nonatomic, strong) id data;
@property (nonatomic, assign) int errorCode;
@property (nonatomic, strong) NSString *message;

@end

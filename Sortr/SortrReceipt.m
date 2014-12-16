//
//  SortrReceipt.m
//  Sortr
//
//  Created by KrisMraz on 12/2/14.
//  Copyright (c) 2014 TheCoapperative. All rights reserved.
//

#import "SortrReceipt.h"
#import "Constants.h"

@implementation SortrReceipt

+(NSDictionary*) getPlist {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SearchLists" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    return dict;
}

+ (NSString*) lookFor:(NSString*)searchOption onThis: (NSString*) stringData {
    NSString *valueFound;
    
    NSArray         *lookInto = (NSArray*)[[self getPlist] objectForKey:searchOption];
    NSMutableArray  *appendedValue = [NSMutableArray new];
    
    bool foundStartPos = false;
    
    for (NSString *lookStr in lookInto) {
        if ( [stringData rangeOfString:lookStr].location != NSNotFound ) {
            
            NSRange range = [stringData rangeOfString:lookStr];
            NSUInteger location = range.location;
            
            for (int x = location; x < stringData.length; x++) {
                
                unichar c = [ stringData characterAtIndex:x ];

                /**
                 *  Special condition for searching of brach, since this must be all alphabets 
                 *  VAT, Total and Date is combined Special characters ('/', '.', '-') and numerics
                 */
                if ([searchOption isEqualToString:kSearchBranch]) {
                    
                    if ( [self isAlphabet: c ] )   {
                        
                        foundStartPos = true;
                        [appendedValue addObject: [NSString stringWithFormat:@"%C", c]];
                        
                    } else {
                        
                        if (foundStartPos == true) {
                            break;
                        }
                    }
                    
                } else {
                    if ( [self isNumeric: c ] )   {
                        
                        foundStartPos = true;
                        [appendedValue addObject: [NSString stringWithFormat:@"%C", c]];
                        
                    } else {
                        
                        if (foundStartPos == true) {
                            break;
                        }
                    }
                }
            }
            
            if (foundStartPos == true) {
                break;
            }
            
            NSLog(@"DATA Contains %@", lookStr);
        }
    }
    
    NSString * combinedStuff = [appendedValue componentsJoinedByString:@""];
    valueFound = combinedStuff;
    
    return valueFound;
}


+ (BOOL) isNumeric :(unichar) charac {
    
    NSCharacterSet *numericSet = [NSCharacterSet decimalDigitCharacterSet];
    BOOL isDigit = NO;
    
    if ([numericSet characterIsMember:charac] || charac == '.' || charac == '/') {
        isDigit = YES;
    }
    
    return isDigit;
}

+ (BOOL) isAlphabet : (unichar) charac {
    NSCharacterSet *alphabetSet = [NSCharacterSet letterCharacterSet];
    BOOL isCharacter = NO;
    
    if ( [alphabetSet characterIsMember:charac]  ) {
        isCharacter = YES;
    }
    
    return isCharacter;
}
@end

//
//  KeypadGenerator.h
//  Readback
//
//  Created by Santiago Borja on 2/17/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadbackKeypad.h"

//Keypad Unique Identifier:
#define STANDARD_KEYPAD 1
#define OCEANIC_KEYPAD  2
#define QWERTY_KEYPAD   3

@interface KeypadGenerator : NSObject

//Main Keypad Source
+ (NSArray *)getAvailableKeypadsIdentifiers;

//(Array of ReadbackKeypads):Array of NSNumber
+(NSArray *)getKeypadsForIdentifiers:(NSArray *)identifiers;

//Static information of each keypad
+ (ReadbackKeypad *)generateKeypadWithIdentifier:(int)identifier;

@end

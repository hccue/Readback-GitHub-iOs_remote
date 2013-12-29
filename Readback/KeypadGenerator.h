//
//  KeypadGenerator.h
//  Readback
//
//  Created by Santiago Borja on 2/17/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadbackKeypad.h"

//Itunes Connect and Application unique Keypad identifiers:
#define STANDARD_KEYPAD_IDENTIFIER      @"standardkeypad"
#define CLEARANCE_KEYPAD_IDENTIFIER     @"com.cuesoft.readback.clearancekeypad"
#define QWERTY_KEYPAD_IDENTIFIER        @"com.cuesoft.readback.qwertykeypad"
#define AZERTY_KEYPAD_IDENTIFIER       @"com.cuesoft.readback.azertykeypad"

#define STRING_DOT @"."
#define STRING_SLASH @"/"

@interface KeypadGenerator : NSObject

//Main Keypad Source
+ (NSSet *)getAvailableKeypadsIdentifiers;

//(Array of ReadbackKeypads):Array of NSString
+(NSArray *)getKeypadsForIdentifiers:(NSArray *)identifiers;

//Static information of each keypad
+ (ReadbackKeypad *)generateKeypadWithIdentifier:(NSString *)identifier;

@end

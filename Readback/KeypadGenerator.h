//
//  KeypadGenerator.h
//  Readback
//
//  Created by Santiago Borja on 2/17/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//


/*
 ADD KEYPAD STEPS:
 1. Define constant identifier below
 2. Add png preview image sized 493x244
 3. Create new inapp with full screenshot and identifier from this page
 4. To test: the itunes connect new not submittd keypad works instantly on sandbox
 */


#import <Foundation/Foundation.h>
#import "ReadbackKeypad.h"

//Itunes Connect and Application unique Keypad identifiers:
#define STANDARD_KEYPAD_IDENTIFIER      @"standardkeypad"
#define CLEARANCE_KEYPAD_IDENTIFIER     @"com.cuesoft.readback.clearancekeypad"
#define QWERTY_KEYPAD_IDENTIFIER        @"com.cuesoft.readback.qwertykeypad"
#define AZERTY_KEYPAD_IDENTIFIER        @"com.cuesoft.readback.azertykeypad"
#define FMC_KEYPAD_IDENTIFIER           @"com.cuesoft.readback.cdukeypad"

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

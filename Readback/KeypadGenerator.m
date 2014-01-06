//
//  KeypadGenerator.m
//  Readback
//
//  Created by Santiago Borja on 2/17/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//


/*
 ADD KEYPAD STEPS:
 1. Add file, new VC targeted for ipad with XIB
 2. Copy Standard Keypad
 3. Set properties, set preview image png file - what properties?
 4. Set File's owner on xib
 5. Delete VC m and h files
 6. Uncheck first tab > use autolayout
 7. Add identifier to getAvailableKeypadsIdentifiers
 8. Add info to generateKeypadWithIdentifier
 5. Add png preview image sized 493x244
 
 5. add image sized 2048x1013 ??? dleete
*/
 
 
#import "KeypadGenerator.h"

@implementation KeypadGenerator


//TODO GET THIS FROM A PLIST
+ (NSSet *)getAvailableKeypadsIdentifiers
{
    return [NSSet setWithObjects:
            STANDARD_KEYPAD_IDENTIFIER,
            CLEARANCE_KEYPAD_IDENTIFIER,
            QWERTY_KEYPAD_IDENTIFIER,
            AZERTY_KEYPAD_IDENTIFIER,
            nil];
}

+(NSArray *)getKeypadsForIdentifiers:(NSArray *)identifiers
{
    NSMutableArray *keypads = [NSMutableArray arrayWithCapacity:[identifiers count]];
    for (NSString *identifier in identifiers) {
        [keypads addObject:[KeypadGenerator generateKeypadWithIdentifier:identifier]];
    }
    return keypads;
}

+(ReadbackKeypad *)generateKeypadWithIdentifier:(NSString *)identifier
{
    ReadbackKeypad *keypad = [[ReadbackKeypad alloc] init];
    keypad.identifier = identifier;
    
    NSString *keypadPlistFileName = [[identifier stringByReplacingOccurrencesOfString:STRING_DOT withString:STRING_SLASH] lastPathComponent];
    [keypad loadDataFromPlistNamed:keypadPlistFileName];
    
    return keypad;
}

@end

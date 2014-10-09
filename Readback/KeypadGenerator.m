//
//  KeypadGenerator.m
//  Readback
//
//  Created by Santiago Borja on 2/17/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

 
 
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
            FMC_KEYPAD_IDENTIFIER,
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

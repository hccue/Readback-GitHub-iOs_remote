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
 3. Set properties, CAUTION: set identifier to corresponding (switch) case!
 3. Uncheck first tab > use autolayout
 4. Add identifier to getAvailableKeypadsIdentifiers
*/
 
 
#import "KeypadGenerator.h"

@implementation KeypadGenerator


//TODO REMOVE THIS WITH IAP
+ (NSArray *)getAvailableKeypadsIdentifiers
{
    return [NSArray arrayWithObjects:
            [NSNumber numberWithInt:STANDARD_KEYPAD_IDENTIFIER],
            [NSNumber numberWithInt:CLEARANCE_KEYPAD_IDENTIFIER],
            [NSNumber numberWithInt:OCEANIC_KEYPAD_IDENTIFIER],
            [NSNumber numberWithInt:QWERTY_KEYPAD_IDENTIFIER], nil];
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
    
    //TODO init with plist
    //NSDictionary *properties = [[NSDictionary alloc] initWithContentsOfFile:@"StandardKeypad.plist"];
    
    if ([identifier isEqualToString:STANDARD_KEYPAD_IDENTIFIER]) {
        keypad.name = @"StandardKeypadVC";
        keypad.title = @"Standard Keypad";
        keypad.subtitle = @"Suits any pilot, anywhere.";
        keypad.imageURL = @"standard.png";
        keypad.detail = @"This is the standard keypad, excellent as a handy tool in any phase of flight for short notes and simple clearances, however you may want to get a custom keypad for better performance in critical phases of flight";
    }
    
    if ([identifier isEqualToString:CLEARANCE_KEYPAD_IDENTIFIER]) {
        keypad.name = @"ClearanceKeypadVC";
        keypad.title = @"Clearance Keypad";
        keypad.subtitle = @"Designed to catch even those light speed clearances.";
        keypad.imageURL = @"standard.png";
        keypad.detail = @"A keypad carefully designed to copy ATC Clearances. Key sorting follows standard Clearance format making it very useful.";
    }
    
    if ([identifier isEqualToString:QWERTY_KEYPAD_IDENTIFIER]) {
        keypad.name = @"QwertyKeypadVC";
        keypad.title = @"Qwerty Keypad";
        keypad.subtitle = @"A worldwide favourite.";
        keypad.imageURL = @"standard.png";
        keypad.detail = @"It doesn't need an introduction. The worldwide favourite set of keys is now available for those moments when all you need is a comfortable place to write down that clearance.";
    }
    
    if ([identifier isEqualToString:OCEANIC_KEYPAD_IDENTIFIER]) {
        keypad.name = @"OceanicKeypadVC";
        keypad.title = @"Oceanic Keypad";
        keypad.subtitle = @"Extended Range Package.";
        keypad.imageURL = @"standard.png";
        keypad.detail = @"This keypad was carefully designed to be your best ally while enroute on Extended Range flights. Werther you are inside the NAT getting New York's Oceanic Clearance or perhaps a SIGMET in the NOPAC, you won't miss a thing.";
    }
   
    return keypad;
}

@end

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
 3. Set properties, set preview image png file
 3. Uncheck first tab > use autolayout
 4. Add identifier to getAvailableKeypadsIdentifiers
 5. add image sized 2048x1013
*/
 
 
#import "KeypadGenerator.h"

@implementation KeypadGenerator

+ (NSSet *)getAvailableKeypadsIdentifiers
{
    return [NSSet setWithObjects:
            STANDARD_KEYPAD_IDENTIFIER,
            CLEARANCE_KEYPAD_IDENTIFIER,
            QWERTY_KEYPAD_IDENTIFIER,
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
    
    //TODO init with plist
    //NSDictionary *properties = [[NSDictionary alloc] initWithContentsOfFile:@"StandardKeypad.plist"];
    
    if ([identifier isEqualToString:STANDARD_KEYPAD_IDENTIFIER]) {
        keypad.name = @"StandardKeypadVC";
        keypad.title = @"Standard Keypad";
        keypad.subtitle = @"Suits any pilot, anywhere.";
        keypad.imageURL = @"standard.png";//this will never show up.
        keypad.description = @"This is the standard keypad, excellent as a handy tool in any phase of flight for short notes and simple clearances, however you may want to get a custom keypad for better performance in critical phases of flight";
    }
    
    if ([identifier isEqualToString:CLEARANCE_KEYPAD_IDENTIFIER]) {
        keypad.name = @"ClearanceKeypadVC";
        keypad.title = @"Clearance Keypad";
        keypad.subtitle = @"For light speed clearances.";
        keypad.imageURL = @"clearance.png";
        keypad.description = @"A keypad carefully designed to copy ATC Clearances. Key sorting follows standard Clearance format making it very useful.";
        
        keypad.marketingKeys = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"SID, there is also a STAR.", @"sid.png",
                                @"Vectors to FIX", @"vectors.png",
                                @"Expect FL 10 min after", @"10-min.png",
                                @"Call, Report, Switch to my Frequency, Contact...", @"call.png",
                                @"Sqwawk code, Transponder.", @"xpdr.png",
                                @"Altimeter Setting/QNH", @"altimeter.png",
                                @"Intercept, join.", @"intc.png",
                                      nil];
    }
    
    if ([identifier isEqualToString:QWERTY_KEYPAD_IDENTIFIER]) {
        keypad.name = @"QwertyKeypadVC";
        keypad.title = @"Qwerty Keypad";
        keypad.subtitle = @"A worldwide favourite.";
        keypad.imageURL = @"qwerty.png";
        keypad.description = @"It doesn't need an introduction. The worldwide favourite set of keys is now available when all you need is a comfortable way to write things down.";
        
        keypad.marketingKeys = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"Direct to FIX", @"direct.png",
                                @"Hold Short of...", @"hold-short.png",
                                @"Intercept, join.", @"intc.png",
                                @"Holding instructions", @"holding.png",
                                @"Call, Report, Switch to my Frequency, Contact...", @"call.png",
                                @"Cross a FIX, a Runway...", @"cross.png",
                                @"Direction Signs, very useful.", @"up.png",
                                nil];
    }
    
    if ([identifier isEqualToString:OCEANIC_KEYPAD_IDENTIFIER]) {
        keypad.name = @"OceanicKeypadVC";
        keypad.title = @"Oceanic Keypad";
        keypad.subtitle = @"Extended Range Tools.";
        keypad.imageURL = @"standard.png";
        keypad.description = @"This keypad was carefully designed to be your best ally while enroute on Extended Range flights. Werther you are inside the NAT getting New York's Oceanic Clearance or perhaps a SIGMET in the NOPAC, you won't miss a thing.";
    }
   
    return keypad;
}

@end

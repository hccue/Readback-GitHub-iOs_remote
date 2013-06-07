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

+ (NSSet *)getAvailableKeypadsIdentifiers
{
    return [NSSet setWithObjects:
            STANDARD_KEYPAD_IDENTIFIER,
            CLEARANCE_KEYPAD_IDENTIFIER,
            QWERTY_KEYPAD_IDENTIFIER,
            OCEANIC_KEYPAD_IDENTIFIER,
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
    
    //Future implementation: init with plist
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
    
    
    if ([identifier isEqualToString:AZERTY_KEYPAD_IDENTIFIER]) {
        keypad.name = @"AzertyKeypadVC";
        keypad.title = @"Azerty Keypad";
        keypad.subtitle = @"As simple as Qwerty.";
        keypad.imageURL = @"azerty.png";
        keypad.description = @"Here we present the Azerty keypad, another useful keypad.";
        
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
    
    //TODO REPLACE OCEANIC_KEYPAD_IDENTIFIER
    if ([identifier isEqualToString:CLEARANCE_KEYPAD_IDENTIFIER]) {
        keypad.name = @"OceanicKeypadVC";
        keypad.title = @"Oceanic Keypad";
        keypad.subtitle = @"Extended Range Tools.";
        keypad.imageURL = @"oceanic.png";
        keypad.description = @"Use this keypad to copy your Oceanic Clearances, SIGMETs, Reroutes and all other important ATC comms during your flight through the NAT, NOPAC or any oceanic area. Keep your clearances logged by time. Avoid Gross Navigation Errors, Large Height Deviations, Erosion of Longitudinal Separation and improove your situational awareness.";
    }
   
    return keypad;
}

@end

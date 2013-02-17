//
//  KeypadGenerator.m
//  Readback
//
//  Created by Santiago Borja on 2/17/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "KeypadGenerator.h"

@implementation KeypadGenerator

+ (NSArray *)getAvailableKeypadsIdentifiers
{
    return [NSArray arrayWithObjects:
            [NSNumber numberWithInt:STANDARD_KEYPAD],
            [NSNumber numberWithInt:OCEANIC_KEYPAD],
            [NSNumber numberWithInt:QWERTY_KEYPAD], nil];
}

+(NSArray *)getKeypadsForIdentifiers:(NSArray *)identifiers
{
    NSMutableArray *keypads = [NSMutableArray arrayWithCapacity:[identifiers count]];
    for (NSNumber *identifier in identifiers) {
        [keypads addObject:[KeypadGenerator generateKeypadWithIdentifier:identifier.intValue]];
    }
    return keypads;
}

+(ReadbackKeypad *)generateKeypadWithIdentifier:(int)identifier
{
    ReadbackKeypad *keypad = [[ReadbackKeypad alloc] init];
    
    switch (identifier) {
        case STANDARD_KEYPAD:
            keypad.identifier = [NSNumber numberWithInt:STANDARD_KEYPAD];
            keypad.name = @"StandardKeypadVC";
            keypad.title = @"Standard Keypad";
            keypad.subtitle = @"Suits any pilot, anywhere.";
            keypad.priority = [NSNumber numberWithInt:1];
            keypad.imageURL = @"standard.png";
            keypad.price = [NSNumber numberWithFloat:0.00];
            keypad.detail = @"This is the standard keypad, excellent as a handy tool in any phase of flight for short notes and simple clearances, however you may want to get a custom keypad for better performance in critical phases of flight";
            break;
            
            
        case OCEANIC_KEYPAD:
            keypad.identifier = [NSNumber numberWithInt:OCEANIC_KEYPAD];
            keypad.name = @"OceanicKeypadVC";
            keypad.title = @"Oceanic Keypad";
            keypad.subtitle = @"Extended Range Package.";
            keypad.priority = [NSNumber numberWithInt:2];
            keypad.imageURL = @"standard.png";
            keypad.price = [NSNumber numberWithFloat:2.99];
            keypad.detail = @"This keypad was carefully designed to be your best ally while enroute on Extended Range flights. Werther you are inside the NAT getting New York's Oceanic Clearance or perhaps a SIGMET in the NOPAC, you won't miss a thing.";
            break;
            
        case QWERTY_KEYPAD:
            keypad.identifier = [NSNumber numberWithInt:QWERTY_KEYPAD];
            keypad.name = @"QwertyKeypadVC";
            keypad.title = @"Qwerty Keypad";
            keypad.subtitle = @"A worldwide favourite.";
            keypad.priority = [NSNumber numberWithInt:3];
            keypad.imageURL = @"qwerty.png";
            keypad.price = [NSNumber numberWithFloat:3.99];
            keypad.detail = @"It doesn't need an introduction. The worldwide favourite set of keys is now available for those moments when all you need is a comfortable place to write down that clearance.";
            break;
            
        default:
            break;
    }
    
    return keypad;
}

@end

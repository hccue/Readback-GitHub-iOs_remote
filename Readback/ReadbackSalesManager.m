//
//  ReadbackSalesManager.m
//  Readback
//
//  Created by Santiago Borja on 1/29/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackSalesManager.h"

@implementation ReadbackSalesManager

//standard keypad is always already purchased.
//Array of ReadbackKeypads
+ (NSArray *)getPurchasedKeypads
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *purchasedKeypads = [[defaults objectForKey:USER_KEY_KEYPADS] mutableCopy];
    
    //First App use:
    if(!purchasedKeypads){
        //manually unlock keypad and ask again
        NSLog(@"purchasing standard");
        
        //TODO change back to standard!!!!!
        
        purchasedKeypads = [NSMutableArray arrayWithCapacity:2];
        [purchasedKeypads addObject:[ReadbackSalesManager getDictionaryFromKeypad:[ReadbackSalesManager getKeypadWithIdentifier:STANDARD_KEYPAD]]];
        [purchasedKeypads addObject:[ReadbackSalesManager getDictionaryFromKeypad:[ReadbackSalesManager getKeypadWithIdentifier:OCEANIC_KEYPAD]]];
        [ReadbackSalesManager saveUserKeypads:purchasedKeypads];
    }
    //Replacing dictionaries for objects
    for (int i = 0; i < [purchasedKeypads count]; i++) {
        [purchasedKeypads setObject:[ReadbackSalesManager getKeypadFromDictionary:[purchasedKeypads objectAtIndex:i]] atIndexedSubscript:i];
    }
    
    return purchasedKeypads;
}

+ (void)performPurchaseOfKeypad:(ReadbackKeypad *)keypad
{
    //Perform purchase with apple and then
    [ReadbackSalesManager unlockKeypad:keypad];
}


+ (void)unlockKeypad:(ReadbackKeypad *)keypad
{
    NSLog(@"Unlocking %@", keypad.title);
    //TODO check purchasing same item again?
    NSMutableArray *purchasedKeypads = [[ReadbackSalesManager getPurchasedKeypads] mutableCopy];
    [purchasedKeypads addObject:keypad];
    
    //Convert into Dictionary:
    for (int i = 0; i < [purchasedKeypads count]; i++) {
        [purchasedKeypads setObject:[ReadbackSalesManager getDictionaryFromKeypad:[purchasedKeypads objectAtIndex:i]] atIndexedSubscript:i];
    }
    
    [ReadbackSalesManager saveUserKeypads:purchasedKeypads];
}


+ (void)saveUserKeypads:(NSArray *)keypads
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:keypads forKey:USER_KEY_KEYPADS];
    [defaults synchronize];
}

+ (NSArray *)getStoreKeypads
{
    return [NSArray arrayWithObjects:[ReadbackSalesManager getKeypadWithIdentifier:STANDARD_KEYPAD], [ReadbackSalesManager getKeypadWithIdentifier:OCEANIC_KEYPAD], nil];
}

+ (ReadbackKeypad *)getKeypadWithIdentifier:(int)identifier
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
            keypad.price = [NSNumber numberWithFloat:3.99];
            keypad.detail = @"This keypad was carefully designed to be your best ally while enroute on Extended Range flights. Werther you are inside the NAT getting New York's Oceanic Clearance or perhaps a SIGMET in the NOPAC, you won't miss a thing.";
            break;
            
        default:
            break;
    }
    
    return keypad;
}


+ (void)restoreAllPurchases
{
    
}

+ (BOOL)keypadIsPurchased:(ReadbackKeypad *)keypad
{
    NSMutableArray *purchasedKeypads = [[ReadbackSalesManager getPurchasedKeypads] mutableCopy];

    for (ReadbackKeypad *pk in purchasedKeypads) {
        if (pk.identifier == keypad.identifier) {
            return YES;
        }
    }
    return NO;
}

+ (NSDictionary *)getDictionaryFromKeypad:(ReadbackKeypad *)keypad
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       keypad.identifier, KEY_IDENTIFIER,
                                       keypad.name, KEY_NAME,
                                       keypad.title, KEY_TITLE,
                                       keypad.subtitle, KEY_SUBTITLE,
                                       keypad.detail, KEY_DETAIL,
                                       keypad.imageURL, KEY_IMAGE,
                                       keypad.price, KEY_PRICE,
                                       keypad.priority, KEY_PRIORITY,
                                       nil];
    
    return dictionary;
}

+(ReadbackKeypad *)getKeypadFromDictionary:(NSDictionary *)dictionary
{
    ReadbackKeypad *keypad = [[ReadbackKeypad alloc] init];
    
    keypad.identifier = [dictionary objectForKey:KEY_IDENTIFIER];
    keypad.name = [dictionary objectForKey:KEY_NAME];
    keypad.title = [dictionary objectForKey:KEY_TITLE];
    keypad.subtitle = [dictionary objectForKey:KEY_SUBTITLE];
    keypad.detail = [dictionary objectForKey:KEY_DETAIL];
    keypad.imageURL = [dictionary objectForKey:KEY_IMAGE];
    keypad.price = [dictionary objectForKey:KEY_PRICE];
    keypad.priority = [dictionary objectForKey:KEY_PRIORITY];
        
    return keypad;
}

@end

//
//  ReadbackSalesManager.m
//  Readback
//
//  Created by Santiago Borja on 1/29/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackSalesManager.h"
#import "KeypadGenerator.h"

@interface ReadbackSalesManager ()
@end

@implementation ReadbackSalesManager

+ (ReadbackSalesManager *)sharedInstance {
    static dispatch_once_t once;
    static ReadbackSalesManager * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      CLEARANCE_KEYPAD_IDENTIFIER,
                                      QWERTY_KEYPAD_IDENTIFIER,
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}


#pragma mark Purchasing API

+ (void)performPurchaseOfKeypad:(ReadbackKeypad *)keypad
{
    //TODO: Perform purchase with apple
    
    [ReadbackSalesManager unlockKeypadIdentifier:keypad.identifier];
}

+ (void)unlockKeypadIdentifier:(NSString *)identifier
{
    NSLog(@"Unlocking %@", identifier);
    //TODO check purchasing same item again?
    
    NSMutableArray *purchasedKeypadsIdentifiers = [[ReadbackSalesManager getPurchasedKeypadsIdentifiers] mutableCopy];
    [purchasedKeypadsIdentifiers addObject:identifier];
    [ReadbackSalesManager savePurchasedKeypads:purchasedKeypadsIdentifiers];
}


//TODO implement IAP
+ (NSArray *)getStoreKeypadIdentifiers
{
    NSArray *keypadsIdentifiers = [KeypadGenerator getAvailableKeypadsIdentifiers];
    NSMutableArray *keypadsArray = [NSMutableArray arrayWithCapacity:[keypadsIdentifiers count]];
    
    for (NSString *identifier in keypadsIdentifiers) {
        [keypadsArray addObject:[KeypadGenerator generateKeypadWithIdentifier:identifier]];
    }
    return keypadsArray;
}

+ (void)restoreAllPurchases
{
    //TODO Implement
}


//TODO REDEFINE WITH IAP
+ (BOOL)keypadIsPurchased:(ReadbackKeypad *)keypad
{
    NSMutableArray *purchasedKeypadsIdentifiers = [[ReadbackSalesManager getPurchasedKeypadsIdentifiers] mutableCopy];
    for (NSString *identifier in purchasedKeypadsIdentifiers) {
        if ([keypad.identifier isEqualToString:identifier]) return YES;
    }
    return NO;
}


//TODO test this actually works
+ (void)savePurchasedKeypadsSorted:(NSArray *)keypadsSorted
{
    NSLog(@"saving sorted %@", keypadsSorted.description);
    NSArray *purchasedIdentifiersUnsorted = [ReadbackSalesManager getPurchasedKeypadsIdentifiers];
    NSMutableArray *purchasedIdentifiersSorted = [NSMutableArray arrayWithCapacity:[purchasedIdentifiersUnsorted count]];
    
    NSLog(@"saving from unsorted %@", purchasedIdentifiersUnsorted.description);
    
    //verify only purchased keypads are saved for safety:
    for (ReadbackKeypad *keypad in keypadsSorted) {
        if ([purchasedIdentifiersUnsorted containsObject:keypad.identifier]) {
            [purchasedIdentifiersSorted addObject:keypad.identifier];
        }
    }
    [ReadbackSalesManager savePurchasedKeypads:purchasedIdentifiersSorted];
}


#pragma mark User Defaults Communication

//standard keypad is always already purchased.
//Get from user defaults, independently from IAP
+ (NSArray *)getPurchasedKeypadsIdentifiers
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *purchasedKeypadsIdentifiers = [[defaults objectForKey:USERKEY_KEYPADS] mutableCopy];
    
    //First App use:
    if(!purchasedKeypadsIdentifiers){
        //manually unlock keypad and ask again
        NSLog(@"purchasing standard");
        purchasedKeypadsIdentifiers = [NSMutableArray arrayWithObject:STANDARD_KEYPAD_IDENTIFIER];
        [ReadbackSalesManager savePurchasedKeypads:purchasedKeypadsIdentifiers];
    }
    
    return purchasedKeypadsIdentifiers;
}

+ (void)savePurchasedKeypads:(NSArray *)keypadIdentifiers
{
    NSLog(@"SAVING USER PURCHASED KEYPADS %@", keypadIdentifiers);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:keypadIdentifiers forKey:USERKEY_KEYPADS];
    [defaults synchronize];
}

@end
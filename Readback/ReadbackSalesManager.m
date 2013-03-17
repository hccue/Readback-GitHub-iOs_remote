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
                                      STANDARD_KEYPAD_IDENTIFIER,
                                      CLEARANCE_KEYPAD_IDENTIFIER,
                                      QWERTY_KEYPAD_IDENTIFIER,
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

#pragma mark Purchasing API


//TODO SOLVE ALERT BUT ON RESTORE DO NOT ALERT ALL THE TIME
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    [super provideContentForProductIdentifier:productIdentifier];
    [ReadbackSalesManager unlockKeypadWithIdentifier:productIdentifier];
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



#pragma mark User Defaults

//Gets from user defaults, independently from IAP - Standard keypad auto-load.
+ (NSArray *)getPurchasedKeypadsIdentifiers
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *purchasedKeypadsIdentifiers = [[defaults objectForKey:USERKEY_KEYPADS] mutableCopy];
    
    if(!purchasedKeypadsIdentifiers){
        //First App use, manually unlock keypad and ask again
        NSLog(@"purchasing standard");
        [ReadbackSalesManager unlockKeypadWithIdentifier:STANDARD_KEYPAD_IDENTIFIER];
        purchasedKeypadsIdentifiers = [[defaults objectForKey:USERKEY_KEYPADS] mutableCopy];
    }
    
    return purchasedKeypadsIdentifiers;
}


+ (void) unlockKeypadWithIdentifier:(NSString *)identifier
{
    NSLog(@"Unlocking Keypad %@", identifier);
    NSMutableArray *purchasedKeypadIdentifiers = [[[NSUserDefaults standardUserDefaults] objectForKey:USERKEY_KEYPADS] mutableCopy];
    if (!purchasedKeypadIdentifiers) purchasedKeypadIdentifiers = [NSMutableArray arrayWithCapacity:1];
    [purchasedKeypadIdentifiers addObject:identifier];
    [[NSUserDefaults standardUserDefaults] setObject:purchasedKeypadIdentifiers forKey:USERKEY_KEYPADS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//Used when saving sorted keypads
+ (void)savePurchasedKeypads:(NSArray *)keypads
{
    NSMutableArray *identifiers = [NSMutableArray arrayWithCapacity:[keypads count]];
    for (ReadbackKeypad *keypad in keypads) {
        [identifiers addObject:keypad.identifier];
    }
    
    NSLog(@"SAVING USER KEYPADS %@", identifiers);
    if ([identifiers count] != [[[NSUserDefaults standardUserDefaults] objectForKey:USERKEY_KEYPADS] count]) {
        NSLog(@"Inconsistency while saving sorted keypads");
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:identifiers forKey:USERKEY_KEYPADS];
    [defaults synchronize];
}
@end
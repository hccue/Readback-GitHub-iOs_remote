//
//  ReadbackSalesManager.m
//  Readback
//
//  Created by Santiago Borja on 1/29/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackSalesManager.h"
#import "KeypadGenerator.h"

@implementation ReadbackSalesManager

#pragma mark Purchasing API

+ (void)performPurchaseOfKeypad:(ReadbackKeypad *)keypad
{
    //TODOPerform purchase with apple
    
    [ReadbackSalesManager unlockKeypadIdentifier:keypad];
}

+ (void)unlockKeypadIdentifier:(ReadbackKeypad *)keypad
{
    NSLog(@"Unlocking %@", keypad.title);
    //TODO check purchasing same item again?
    
    NSMutableArray *purchasedKeypadsIdentifiers = [[ReadbackSalesManager getPurchasedKeypadsIdentifiers] mutableCopy];
    [purchasedKeypadsIdentifiers addObject:keypad.identifier];
    [ReadbackSalesManager savePurchasedKeypads:purchasedKeypadsIdentifiers];
}

+ (NSArray *)getStoreKeypads
{
    NSArray *keypadsIdentifiers = [KeypadGenerator getAvailableKeypadsIdentifiers];
    NSMutableArray *keypadsArray = [NSMutableArray arrayWithCapacity:[keypadsIdentifiers count]];
    
    for (NSNumber *identifier in keypadsIdentifiers) {
        [keypadsArray addObject:[KeypadGenerator generateKeypadWithIdentifier:[identifier intValue]]];
    }
    return keypadsArray;
}

+ (void)restoreAllPurchases
{
    //TODO Implement
}

+ (BOOL)keypadIsPurchased:(ReadbackKeypad *)keypad
{
    NSMutableArray *purchasedKeypadsIdentifiers = [[ReadbackSalesManager getPurchasedKeypadsIdentifiers] mutableCopy];
    for (NSNumber *identifier in purchasedKeypadsIdentifiers) {
        if ([keypad.identifier intValue] == [identifier intValue]) return YES;
    }
    return NO;
}



#pragma mark User Defaults Communication

//standard keypad is always already purchased.
+ (NSArray *)getPurchasedKeypadsIdentifiers
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *purchasedKeypadsIdentifiers = [[defaults objectForKey:USERKEY_KEYPADS] mutableCopy];
    
    //First App use:
    if(!purchasedKeypadsIdentifiers){
        //manually unlock keypad and ask again
        NSLog(@"purchasing standard");
        purchasedKeypadsIdentifiers = [NSMutableArray arrayWithObject:[NSNumber numberWithInt:STANDARD_KEYPAD]];
        [ReadbackSalesManager savePurchasedKeypads:purchasedKeypadsIdentifiers];
    }
    
    return purchasedKeypadsIdentifiers;
}

+ (void)savePurchasedKeypads:(NSArray *)keypadIdentifiers
{
    NSLog(@"SAVING USER PURCHASED KEYPADS");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:keypadIdentifiers forKey:USERKEY_KEYPADS];
    [defaults synchronize];
}

@end
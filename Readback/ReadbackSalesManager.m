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
        NSSet * productIdentifiers = [KeypadGenerator getAvailableKeypadsIdentifiers];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}




#pragma mark Purchasing API

//Overriding parent implementation, super called last to notify after delivery.
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    [ReadbackSalesManager unlockKeypadWithIdentifier:productIdentifier];
    [super provideContentForProductIdentifier:productIdentifier];
}

+ (void) unlockKeypadWithIdentifier:(NSString *)identifier
{
    NSLog(@"Unlocking Keypad %@", identifier);
    NSMutableArray *purchasedKeypadIdentifiers = [ReadbackSalesManager getPurchasedIdentifiersFromMemory];
    [purchasedKeypadIdentifiers addObject:identifier];
    [ReadbackSalesManager savePurchasedIdentifiersToMemory:purchasedKeypadIdentifiers];
}

+ (BOOL)keypadIdentifierIsPurchased:(NSString *)identifier;
{
    NSMutableArray *purchasedKeypadsIdentifiers = [[ReadbackSalesManager getPurchasedIdentifiersFromMemory] mutableCopy];
    for (NSString *purchasedIdentifier in purchasedKeypadsIdentifiers) {
        if ([identifier isEqualToString:purchasedIdentifier]) return YES;
    }
    return NO;
}


#pragma mark User Defaults

+(NSMutableArray *)getPurchasedIdentifiersFromMemory
{
    NSMutableArray *purchasedKeypadIdentifiers = [[[NSUserDefaults standardUserDefaults] objectForKey:USERKEY_KEYPADS] mutableCopy];
    if(!purchasedKeypadIdentifiers){
        //First App use, unlock Standard keypad
        NSLog(@"purchasing standard");
        //Cannot call unlockKeypadWithIdentifier, deadlock!
        NSArray *array = [NSArray arrayWithObject:STANDARD_KEYPAD_IDENTIFIER];
        [ReadbackSalesManager savePurchasedIdentifiersToMemory:array];
        purchasedKeypadIdentifiers = [ReadbackSalesManager getPurchasedIdentifiersFromMemory];
    }
    
    return purchasedKeypadIdentifiers;
}

+(void)savePurchasedIdentifiersToMemory:(NSArray *)purcahsedIdentifiers
{
    //Prevent duplicates:
    NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:purcahsedIdentifiers];
    NSArray *cleanArray = [set array];
    
    NSLog(@"Saving purchased kepads:%@", cleanArray);
    
    [[NSUserDefaults standardUserDefaults] setObject:cleanArray forKey:USERKEY_KEYPADS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
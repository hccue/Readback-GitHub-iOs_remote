//
//  ReadbackSalesManager.h
//  Readback
//
//  Created by Santiago Borja on 1/29/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadbackKeypad.h"

#define USERKEY_KEYPADS @"user_keypads"

@interface ReadbackSalesManager : NSObject

+ (NSArray *)getPurchasedKeypadsIdentifiers; //Array of NSNumber
+ (NSArray *)getStoreKeypads; //All keypads available for purchasing
+ (void)restoreAllPurchases;
+ (void)performPurchaseOfKeypad:(ReadbackKeypad *)keypad;
+ (BOOL)keypadIsPurchased:(ReadbackKeypad *)keypad;

@end

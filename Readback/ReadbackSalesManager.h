//
//  ReadbackSalesManager.h
//  Readback
//
//  Created by Santiago Borja on 1/29/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadbackKeypad.h"
#import "IAPHelper.h"



@interface ReadbackSalesManager : IAPHelper

+ (ReadbackSalesManager *)sharedInstance;

+ (NSArray *)getPurchasedKeypadsIdentifiers; //Array of NSString IAP identifiers    TODO: refactor to IAP
+ (NSArray *)getStoreKeypadIdentifiers;                //All available keypads for purchasing TODO: remove this?
+ (void)restoreAllPurchases;
+ (BOOL)keypadIsPurchased:(ReadbackKeypad *)keypad;

+ (void)savePurchasedKeypads:(NSArray *)keypadIdentifiers;
@end

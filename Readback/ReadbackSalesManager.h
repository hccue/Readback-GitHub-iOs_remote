//
//  ReadbackSalesManager.h
//  Readback
//
//  Created by Santiago Borja on 1/29/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadbackKeypad.h"

#define USER_KEY_KEYPADS @"user_keypads"

#define STANDARD_KEYPAD 1
#define OCEANIC_KEYPAD 2

#define KEY_IDENTIFIER @"Identifier"
#define KEY_TITLE @"Title"
#define KEY_NAME @"Name"
#define KEY_SUBTITLE @"Subtitle"
#define KEY_DETAIL @"Detail"
#define KEY_IMAGE @"image_url"
#define KEY_PRICE @"Price"
#define KEY_PRIORITY @"Priority"

@interface ReadbackSalesManager : NSObject

+ (NSArray *)getPurchasedKeypads;
+ (NSArray *)getStoreKeypads;
+ (void)restoreAllPurchases;
+ (void)performPurchaseOfKeypad:(ReadbackKeypad *)keypad;
+ (BOOL)keypadIsPurchased:(ReadbackKeypad *)keypad;
@end

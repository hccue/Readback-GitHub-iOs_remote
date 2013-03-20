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

+ (NSMutableArray *)getPurchasedIdentifiersFromMemory; //Array of NSString IAP identifiers    TODO: refactor to IAP
+(void)savePurchasedIdentifiersToMemory:(NSArray *)purcahsedIdentifiers;
@end

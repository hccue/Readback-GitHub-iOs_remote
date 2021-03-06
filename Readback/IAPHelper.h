//
//  IAPHelper.h
//  Readback
//
//  Created by Santiago Borja on 3/15/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

#define USERKEY_KEYPADS @"purchasesIdentifiers"


typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);


@interface IAPHelper : NSObject
@property (nonatomic, strong) NSSet * productIdentifiers;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

- (void)buyProduct:(SKProduct *)product;
- (void)restoreCompletedTransactions;

//Override to provide contents.
- (void)provideContentForProductIdentifier:(NSString *)productIdentifier;
@end
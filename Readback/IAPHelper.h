//
//  IAPHelper.h
//  Readback
//
//  Created by Santiago Borja on 3/15/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <Foundation/Foundation.h>

#define USERKEY_KEYPADS @"purchasesIdentifiers"

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

@end
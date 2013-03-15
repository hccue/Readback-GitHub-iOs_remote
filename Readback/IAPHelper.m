//
//  IAPHelper.m
//  Readback
//
//  Created by Santiago Borja on 3/15/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>



@interface IAPHelper () <SKProductsRequestDelegate>
@property (nonatomic, strong) SKProductsRequest * productsRequest;
@property (nonatomic, strong) RequestProductsCompletionHandler completionHandler;
@property (nonatomic, strong) NSSet * productIdentifiers;
@property (nonatomic, strong) NSMutableSet * purchasedProductIdentifiers;
@end

@implementation IAPHelper
@synthesize productsRequest = _productsRequest;
@synthesize completionHandler = _completionHandler;
@synthesize productIdentifiers = _productIdentifiers;
@synthesize purchasedProductIdentifiers = _purchasedProductIdentifiers;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        // Store product identifiers
        self.productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        self.purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in self.productIdentifiers) {

            NSSet *purchasedProducts = [[NSUserDefaults standardUserDefaults] objectForKey:USERKEY_KEYPADS];
            BOOL productPurchased = [purchasedProducts containsObject:productIdentifier];
            if (productPurchased) {
                [self.purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
    NSLog(@"requestin with completion");
    self.completionHandler = [completionHandler copy];
    
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:self.productIdentifiers];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
    
}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"Loaded list of products...");
    self.productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ - %@ - %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    self.completionHandler(YES, skProducts);
    self.completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    self.productsRequest = nil;
    
    self.completionHandler(NO, nil);
    self.completionHandler = nil;
    
}


@end
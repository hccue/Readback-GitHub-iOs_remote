//
//  IAPHelper.m
//  Readback
//
//  Created by Santiago Borja on 3/15/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>


//Purchase success
#define PURCHASED_MESSAGE_TITLE     @"Congratulations!"
#define PURCHASED_MESSAGE_BODY      @"You just purchased a new Keypad."
#define PURCHASED_MESSAGE_BUTTON    @"Thanks"

//Restore success
#define RESTORED_MESSAGE_TITLE     @"Success!"
#define RESTORED_MESSAGE_BODY      @"You just restored your purchased Keypads."
#define RESTORED_MESSAGE_BUTTON    @"Thanks"

//Purchase error
#define ALERT_PURCHASE_ERROR_TITLE     @"In-App-Purchase Error:"
#define ALERT_PURCHASE_ERROR_BUTTON    @"Understood"

//Unable to load products
#define ALERT_LOAD_ERROR_TITLE     @"Cannot Load Products"
#define ALERT_LOAD_ERROR_MESSAGE   @"Maybe your internet connection is down, please try again."
#define ALERT_LOAD_ERROR_BUTTON     @"Understood"

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic, strong) SKProductsRequest * productsRequest;
@property (nonatomic, strong) RequestProductsCompletionHandler completionHandler;

@end

@implementation IAPHelper
@synthesize productsRequest = _productsRequest;
@synthesize completionHandler = _completionHandler;
@synthesize productIdentifiers = _productIdentifiers;
//@synthesize purchasedProductIdentifiers = _purchasedProductIdentifiers;


//Init with list of local available product identifiers
//TODO identify if we can get rid of self.purchasedProductIdentifiers
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        // Store product identifiers
        self.productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        //self.purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in self.productIdentifiers) {
            NSSet *purchasedProducts = [NSSet setWithArray:[[self class] getPurchasedIdentifiersFromMemory]];
            BOOL productPurchased = [purchasedProducts containsObject:productIdentifier];
            if (productPurchased) {
                //[self.purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    
    return self;
}

+ (NSMutableArray *)getPurchasedIdentifiersFromMemory {return nil;}//Implemented in subclass

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
    self.completionHandler = [completionHandler copy];
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:self.productIdentifiers];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    //TODO this is called once per each product whilst it should only be called once at all.
    NSLog(@"Loaded list of products from internet...");
    self.productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ - %@ - %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    ////SalesVC: Generate List of Products to display in store.
    self.completionHandler(YES, skProducts);
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{    
    NSLog(@"Failed to load list of products.");
    UIAlertView* message = [[UIAlertView alloc] initWithTitle:ALERT_LOAD_ERROR_TITLE
                                                      message:ALERT_LOAD_ERROR_MESSAGE
                                                     delegate:self
                                            cancelButtonTitle:ALERT_LOAD_ERROR_BUTTON
                                            otherButtonTitles: nil];
    [message show];
    
    self.productsRequest = nil;
    self.completionHandler(NO, nil);
}

//- (BOOL)productPurchased:(NSString *)productIdentifier {
    //return [self.purchasedProductIdentifiers containsObject:productIdentifier];
//}


//TODO CHECK FOR SANDBOX OR PRODUCTION ENVIRONMENT!!? - maybe only in my server
- (void)buyProduct:(SKProduct *)product {
    NSLog(@"Buying %@...", product.productIdentifier);
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [self alertRestoreSuccess];
}

#pragma mark Transaction Caller Methods

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}


- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"complete Transaction parent...");
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [self alertPurchaseSuccess];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"RESTORING Transaction...");
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    //[self.purchasedProductIdentifiers addObject:productIdentifier];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"Failed Transaction, error: %@", transaction.error.localizedDescription);
    
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSString *errorMessage = @"There was an error purchasing this item please try again.";
        
        if(transaction.error.code == SKErrorUnknown) {
            NSLog(@"Unknown Error (%d), product: %@", (int)transaction.error.code, transaction.payment.productIdentifier);
        }
        
        if(transaction.error.code == SKErrorClientInvalid) {
            NSLog(@"Client invalid (%d), product: %@", (int)transaction.error.code, transaction.payment.productIdentifier);
        }
        
        if(transaction.error.code == SKErrorPaymentInvalid) {
            NSLog(@"Payment invalid (%d), product: %@", (int)transaction.error.code, transaction.payment.productIdentifier);
        }
        
        if(transaction.error.code == SKErrorPaymentNotAllowed) {
            NSLog(@"Payment not allowed (%d), product: %@", (int)transaction.error.code, transaction.payment.productIdentifier);
        }
        
        UIAlertView* message = [[UIAlertView alloc] initWithTitle: ALERT_PURCHASE_ERROR_TITLE
                                                          message: errorMessage
                                                         delegate: self
                                                cancelButtonTitle: ALERT_PURCHASE_ERROR_BUTTON
                                                otherButtonTitles: nil];
        [message show];

    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark Alert Messages

-(void)alertPurchaseSuccess
{
    UIAlertView* message = [[UIAlertView alloc] initWithTitle:PURCHASED_MESSAGE_TITLE
                                                      message:PURCHASED_MESSAGE_BODY
                                                     delegate:self
                                            cancelButtonTitle:PURCHASED_MESSAGE_BUTTON
                                            otherButtonTitles: nil];
    [message show];
}

-(void)alertRestoreSuccess
{
    UIAlertView* message = [[UIAlertView alloc] initWithTitle:RESTORED_MESSAGE_TITLE
                                                      message:RESTORED_MESSAGE_BODY
                                                     delegate:self
                                            cancelButtonTitle:RESTORED_MESSAGE_BUTTON
                                            otherButtonTitles: nil];
    [message show];
}

@end
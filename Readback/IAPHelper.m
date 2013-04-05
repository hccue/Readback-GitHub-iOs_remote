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
#define PURCHASED_MESSAGE_BODY      @"Enjoy your brand new Keypad."
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

//TODO IMPLEMENT:
//skPaymentQueue canMakePayment
//Check status 3


//Init with local list of available product identifiers
- (id)initWithProductIdentifiers:(NSSet *)potentialProductIdentifiers {
    
    if ((self = [super init])) {
        self.productIdentifiers = potentialProductIdentifiers;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

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
    //Called (at least) each time reloadStoreProducts is called
    self.productsRequest = nil;
    
    ////SalesVC: Generate List of Products to display in store.
    self.completionHandler(YES, response.products);
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

- (void)buyProduct:(SKProduct *)product {
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
    NSLog(@"updated transactions %@", transactions);
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                //nothing to do
                break;
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
        }
    };
}


- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"complete Transaction...");
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [self alertPurchaseSuccess];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"Restoring Transaction...");
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
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
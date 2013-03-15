//
//  ReadbackSalesViewController.h
//  Readback
//
//  Created by Santiago Borja on 1/14/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadbackPurchasesTableViewController.h"
#import "ReadbackStoreTableViewController.h"
#import "ReadbackSalesManager.h"

#define PRICE_FORMAT @"$%1.2f"

@protocol ReadbackSalesViewControllerDelegate <NSObject>
-(void) loadKeypadWithIdentifier:(NSString *)identifier;
@end

@interface ReadbackSalesViewController : UIViewController <ReadbackPurchasesTableViewControllerDataSource, ReadbackPurchasesTableViewControllerDelegate, ReadbackStoreTableViewControllerDataSource>

@property (strong, nonatomic) NSArray *purchasedKeypads; //Array of ReadbackKeypads
@property (strong, nonatomic) NSArray *storeKeypads;     //Array of ReadbackKeypads

@property (strong, nonatomic) id<ReadbackSalesViewControllerDelegate> delegate;

- (IBAction)restorePurchases:(UIButton *)sender;
@end

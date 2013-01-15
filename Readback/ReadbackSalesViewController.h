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

#define PRICE_FORMAT @"$%1.2f"

@interface ReadbackSalesViewController : UIViewController <ReadbackPurchasesTableViewControllerDataSource, ReadbackPurchasesTableViewControllerDelegate, ReadbackStoreTableViewControllerDataSource, ReadbackStoreTableViewControllerDelegate>

@property (strong, nonatomic) NSArray *purchasedKeypads;
@property (strong, nonatomic) NSArray *storeKeypads;

- (IBAction)restorePurchases:(UIButton *)sender;

@end

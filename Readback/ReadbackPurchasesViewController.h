//
//  ReadbackPurchasesViewController.h
//  Readback
//
//  Created by Santiago Borja on 1/14/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadbackPurchasesTableViewController.h"

#define KEYPAD_KEY_TITLE @"Title"
#define KEYPAD_KEY_SUBTITLE @"Subtitle"

@interface ReadbackPurchasesViewController : UIViewController <ReadbackPurchasesTableViewControllerDataSource, ReadbackPurchasesTableViewControllerDelegate>
@property (strong, nonatomic) NSArray *purchasedKeypads;
@property (strong, nonatomic) NSArray *storeKeypads;

- (IBAction)restorePurchases:(UIButton *)sender;

@end

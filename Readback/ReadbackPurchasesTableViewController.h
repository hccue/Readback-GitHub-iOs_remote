//
//  ReadbackPurchasesTableViewController.h
//  Readback
//
//  Created by Santiago Borja on 1/14/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PURCHASED_CELL @"PurchasedKeypadCell"

@protocol ReadbackPurchasesTableViewControllerDataSource <NSObject>
-(NSInteger)numberOfPurchasedItems;
-(NSDictionary *)purchasedItemAtIndex:(NSInteger)row;
@end


@interface ReadbackPurchasesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) id <ReadbackPurchasesTableViewControllerDataSource> dataSource;
@end

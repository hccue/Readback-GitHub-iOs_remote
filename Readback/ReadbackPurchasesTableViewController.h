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
-(NSInteger) numberOfPurchasedItems;
-(NSDictionary *) purchasedItemAtIndex:(NSInteger)row;
@end

@protocol ReadbackPurchasesTableViewControllerDelegate <NSObject>
-(void) purchasedKeypadSelectedAtIndexPath:(NSIndexPath *)indexPath;
-(void) moveRowAtIndex:(int)sourceIndex toIndex:(int)destinationIndex;
@end

@interface ReadbackPurchasesTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) id <ReadbackPurchasesTableViewControllerDataSource> dataSource;
@property (strong, nonatomic) id <ReadbackPurchasesTableViewControllerDelegate> delegate;
@end

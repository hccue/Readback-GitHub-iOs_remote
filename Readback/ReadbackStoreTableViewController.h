//
//  ReadbackStoreTableViewController.h
//  Readback
//
//  Created by Santiago Borja on 1/14/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadbackKeypad.h"

#define STORE_CELL @"StoreKeypadCell"
#define TEXT_PURCHASED @"Purchased"

@protocol ReadbackStoreTableViewControllerDataSource <NSObject>
-(NSInteger)numberOfStoreItems;
-(ReadbackKeypad *)storeItemAtIndex:(NSInteger)row;
@end


@interface ReadbackStoreTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) id <ReadbackStoreTableViewControllerDataSource> dataSource;

@end

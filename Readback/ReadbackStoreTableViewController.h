//
//  ReadbackStoreTableViewController.h
//  Readback
//
//  Created by Santiago Borja on 1/14/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <UIKit/UIKit.h>

#define STORE_CELL @"StoreKeypadCell"

@protocol ReadbackStoreTableViewControllerDataSource <NSObject>
-(NSInteger)numberOfStoreItems;
-(NSDictionary *)storeItemAtIndex:(NSInteger)row;
@end

@protocol ReadbackStoreTableViewControllerDelegate <NSObject>
-(void)storeItemWasSelectedAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface ReadbackStoreTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) id <ReadbackStoreTableViewControllerDelegate> delegate;
@property (strong, nonatomic) id <ReadbackStoreTableViewControllerDataSource> dataSource;

@end

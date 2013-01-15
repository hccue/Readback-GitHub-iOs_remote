//
//  ReadbackStoreTableViewController.h
//  Readback
//
//  Created by Santiago Borja on 1/14/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReadbackStoreTableViewController;

@protocol ReadbackStoreTableViewControllerDataSource <NSObject>
-(NSInteger)numberOfItems;
-(NSDictionary *)itemAtIndex:(NSInteger)row;
@end

@protocol ReadbackStoreTableViewControllerDelegate <NSObject>
-(void)itemWasSelectedAtIndexPath:(NSIndexPath *)indexPath;
@end


@interface ReadbackStoreTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) id <ReadbackStoreTableViewControllerDelegate> delegate;
@property (strong, nonatomic) id <ReadbackStoreTableViewControllerDataSource> dataSource;

@end

//
//  ReadbackTableViewController.h
//  Readback
//
//  Created by Santiago Borja on 3/21/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReadbackTableViewControllerDataSource <NSObject>
-(NSInteger) numberOfLogItems;
-(UIView *) logViewAtIndex:(NSInteger)row;
@end

@interface ReadbackTableViewController : UITableViewController
@property (nonatomic, strong) id<ReadbackTableViewControllerDataSource> dataSource;
@end

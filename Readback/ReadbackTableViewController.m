//
//  ReadbackTableViewController.m
//  Readback
//
//  Created by Santiago Borja on 3/21/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackTableViewController.h"

#define LOG_REUSE_IDENTIFIER @"LogCell"

@interface ReadbackTableViewController ()

@end

@implementation ReadbackTableViewController
@synthesize dataSource = _dataSource;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Not actually reusing cells due to overlapping of older cells over new ones.
    static NSString *CellIdentifier = LOG_REUSE_IDENTIFIER;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    [cell.contentView addSubview:[self.dataSource logViewAtIndex:indexPath.row]];
    cell.transform = CGAffineTransformMakeRotation(M_PI);
    return cell;
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource numberOfLogItems];
    
}

@end
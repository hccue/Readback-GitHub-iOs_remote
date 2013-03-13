//
//  ReadbackPurchasesTableViewController.m
//  Readback
//
//  Created by Santiago Borja on 1/14/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackPurchasesTableViewController.h"
#import "ReadbackKeypad.h"
#import "ReadbackSalesViewController.h"

@implementation ReadbackPurchasesTableViewController
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource numberOfPurchasedItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = PURCHASED_CELL;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    ReadbackKeypad *myKeypad = (ReadbackKeypad *)[self.dataSource purchasedItemAtIndex:indexPath.row];
    
    cell.textLabel.text = myKeypad.title;
    cell.detailTextLabel.text = myKeypad.subtitle;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate purchasedKeypadSelectedAtIndexPath:indexPath];
}

@end
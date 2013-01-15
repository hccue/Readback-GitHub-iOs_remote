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
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource numberOfPurchasedItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = PURCHASED_CELL;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    NSDictionary *myKeypad = [self.dataSource purchasedItemAtIndex:indexPath.row];
    
    cell.textLabel.text = [myKeypad objectForKey:KEYPAD_KEY_TITLE];
    cell.detailTextLabel.text = [myKeypad objectForKey:KEYPAD_KEY_SUBTITLE];
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate purchasedItemWasSelectedAtIndexPath:indexPath];
}

@end
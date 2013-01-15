//
//  ReadbackStoreTableViewController.m
//  Readback
//
//  Created by Santiago Borja on 1/14/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackStoreTableViewController.h"
#import "ReadbackKeypad.h"
#import "ReadbackSalesViewController.h"

@implementation ReadbackStoreTableViewController
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource numberOfStoreItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STORE_CELL];
    
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellAccessoryCheckmark reuseIdentifier:STORE_CELL];
    
    ReadbackKeypad *myKeypad = (ReadbackKeypad *)[self.dataSource storeItemAtIndex:indexPath.row];
    
    cell.textLabel.text = myKeypad.title;
    cell.detailTextLabel.text = myKeypad.detail;
    
    if (![myKeypad.purchased boolValue]) {
        UILabel *price = [[UILabel alloc] init];
        price.text = [NSString stringWithFormat:PRICE_FORMAT, [myKeypad.price floatValue]];
        price.textColor = [UIColor blackColor];
        [price sizeToFit];
        cell.accessoryView = price;
    }//else we keep the checkmark
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate storeItemWasSelectedAtIndexPath:indexPath];
}

@end
//
//  ReadbackPurchasesTableViewController.m
//  Readback
//
//  Created by Santiago Borja on 1/14/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackPurchasesTableViewController.h"
#import "ReadbackPurchasesViewController.h"

@interface ReadbackPurchasesTableViewController ()

@end

@implementation ReadbackPurchasesTableViewController
@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

#pragma mark - TableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource numberOfItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"go1");
    static NSString *CellIdentifier = @"MyKepadCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *myKeypad = [self.dataSource itemAtIndex:indexPath.row];
    
    cell.textLabel.text = [myKeypad objectForKey:KEYPAD_KEY_TITLE];
    cell.detailTextLabel.text = [myKeypad objectForKey:KEYPAD_KEY_SUBTITLE];
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate itemWasSelectedAtIndexPath:indexPath];
}

#pragma mark UIView Lifecycle

@end

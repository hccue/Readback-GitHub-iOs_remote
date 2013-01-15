//
//  ReadbackPurchasesViewController.m
//  Readback
//
//  Created by Santiago Borja on 1/14/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackPurchasesViewController.h"

@interface ReadbackPurchasesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *myKeypadsTableView;
@property (weak, nonatomic) IBOutlet UITableView *storeKeypadsTableView;

@property (strong, nonatomic) ReadbackPurchasesTableViewController *purchasedTableViewController;
@property (strong, nonatomic) UITableViewController *storeTableViewController;

@end

@implementation ReadbackPurchasesViewController
@synthesize myKeypadsTableView = _myKeypadsTableView;
@synthesize storeKeypadsTableView = _storeKeypadsTableView;

@synthesize purchasedTableViewController = _purchasedTableViewController;
@synthesize storeTableViewController = _storeTableViewController;

@synthesize purchasedKeypads = _purchasedKeypads;
@synthesize storeKeypads = _storeKeypads;


-(UITableViewController *)purchasedTableViewController
{
    if (!_purchasedTableViewController) {
        _purchasedTableViewController = [[ReadbackPurchasesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _purchasedTableViewController.delegate = self;
        _purchasedTableViewController.dataSource = self;
    }
    return  _purchasedTableViewController;
}

-(NSArray *)purchasedKeypads
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Cool Keypad", KEYPAD_KEY_TITLE, @"Cool Subtitle", KEYPAD_KEY_SUBTITLE, nil];
    
    NSArray *array = [NSArray arrayWithObjects:dictionary, nil];
    
    return array;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)restorePurchases:(UIButton *)sender {
    //TODO Restore Purchases
}


#pragma mark ReadbackPurchasesTableViewController dataSource and delegate

-(NSInteger)numberOfItems
{
    NSLog(@"item was counted");
    return [self.purchasedKeypads count];
}

-(NSDictionary *)itemAtIndex:(NSInteger)row
{
    NSLog(@"item was asked");
    return [self.purchasedKeypads objectAtIndex:row];
}

-(void)itemWasSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"item was selected");
}



#pragma mark UITableView Lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    self.myKeypadsTableView.delegate = self.purchasedTableViewController;
    self.myKeypadsTableView.dataSource = self.purchasedTableViewController;
    
    
}

- (void)viewDidUnload {
    [self setMyKeypadsTableView:nil];
    [self setStoreKeypadsTableView:nil];
    [super viewDidUnload];
}

@end

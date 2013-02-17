//
//  ReadbackPurchasesViewController.m
//  Readback
//
//  Created by Santiago Borja on 1/14/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackSalesViewController.h"
#import "ReadbackKeypad.h"
#import "ReadbackPreviewViewController.h"
#import "ReadbackSalesManager.h"
#import "KeypadGenerator.h"

@interface ReadbackSalesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *purchasedKeypadsTableView;
@property (weak, nonatomic) IBOutlet UITableView *storeKeypadsTableView;

@property (strong, nonatomic) ReadbackPurchasesTableViewController *purchasedTableViewController;
@property (strong, nonatomic) ReadbackStoreTableViewController *storeTableViewController;

@end

@implementation ReadbackSalesViewController
@synthesize purchasedKeypadsTableView = _purchasedKeypadsTableView;
@synthesize storeKeypadsTableView = _storeKeypadsTableView;

@synthesize purchasedTableViewController = _purchasedTableViewController;
@synthesize storeTableViewController = _storeTableViewController;

@synthesize purchasedKeypads = _purchasedKeypads;
@synthesize storeKeypads = _storeKeypads;


-(UITableViewController *)purchasedTableViewController
{
    if (!_purchasedTableViewController) {
        _purchasedTableViewController = [[ReadbackPurchasesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _purchasedTableViewController.dataSource = self;
    }
    return  _purchasedTableViewController;
}

-(UITableViewController *)storeTableViewController
{
    if (!_storeTableViewController) {
        _storeTableViewController = [[ReadbackStoreTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _storeTableViewController.dataSource = self;
    }
    return _storeTableViewController;
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)restorePurchases:(UIButton *)sender {
    [ReadbackSalesManager restoreAllPurchases];
    //TODO Restore all purchases in the UI ?
}



#pragma mark UITableViewControllers implementation

//ReadbackPurchasesTableViewController:

-(NSInteger)numberOfPurchasedItems
{
    return [self.purchasedKeypads count];
}

-(NSDictionary *)purchasedItemAtIndex:(NSInteger)row
{
    return [self.purchasedKeypads objectAtIndex:row];
}

//ReadbackStoreTableViewController:

-(NSInteger)numberOfStoreItems
{
    return [self.storeKeypads count];
}

-(NSDictionary *)storeItemAtIndex:(NSInteger)row
{
    return [self.storeKeypads objectAtIndex:row];
}




#pragma mark UITableView Lifecycle

-(void)viewDidLoad //Only once:
{
    self.purchasedKeypadsTableView.delegate = self.purchasedTableViewController;
    self.purchasedKeypadsTableView.dataSource = self.purchasedTableViewController;
    
    self.storeKeypadsTableView.delegate = self.storeTableViewController;
    self.storeKeypadsTableView.dataSource = self.storeTableViewController;
}

-(void)viewWillAppear:(BOOL)animated
{
    //Refresh in case we are returning from a purchase:
    self.purchasedKeypads = [KeypadGenerator getKeypadsForIdentifiers:[ReadbackSalesManager getPurchasedKeypadsIdentifiers]];
    self.storeKeypads = [ReadbackSalesManager getStoreKeypads];

    [self.purchasedKeypadsTableView reloadData];
    [self.storeKeypadsTableView reloadData];
}

- (void)viewDidUnload {
    [self setPurchasedKeypadsTableView:nil];
    [self setStoreKeypadsTableView:nil];
    [super viewDidUnload];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Set Store keypad to display:
    if ([segue.destinationViewController respondsToSelector:@selector(setKeypad:)]) {
        NSIndexPath *indexPath = [self.storeKeypadsTableView indexPathForCell:sender];
        [segue.destinationViewController setKeypad:[self.storeKeypads objectAtIndex:indexPath.row]];
    }
}

@end

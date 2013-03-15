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
#import "KeypadGenerator.h"

#import "ReadbackSalesManager.h"
#import <StoreKit/StoreKit.h>

#define BUTTON_LABEL_SORT @"Sort"
#define BUTTON_LABEL_DONE @"Done"

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

@synthesize delegate = _delegate;


-(UITableViewController *)purchasedTableViewController
{
    if (!_purchasedTableViewController) {
        _purchasedTableViewController = [[ReadbackPurchasesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _purchasedTableViewController.dataSource = self;
        _purchasedTableViewController.delegate = self;
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

-(ReadbackKeypad *)purchasedItemAtIndex:(NSInteger)row
{
    return [self.purchasedKeypads objectAtIndex:row];
}

-(void) purchasedKeypadSelectedAtIndexPath:(NSIndexPath *)indexPath;
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate loadKeypadWithIdentifier:((ReadbackKeypad *)[self.purchasedKeypads objectAtIndex:indexPath.row]).identifier];
    
}

- (IBAction)editTapped:(UIButton *)sender {
    if ([self.purchasedKeypadsTableView isEditing]) {
        [sender setTitle: BUTTON_LABEL_SORT forState: UIControlStateNormal];
        [self.purchasedKeypadsTableView setEditing:NO animated:YES];
    }else{
        [sender setTitle: BUTTON_LABEL_DONE forState: UIControlStateNormal];
        [self.purchasedKeypadsTableView setEditing:YES animated:YES];
    }
}

-(void) moveRowAtIndex:(int)sourceIndex toIndex:(int)destinationIndex
{
    NSMutableArray *purchasedKeypadsMutable = [self.purchasedKeypads mutableCopy];
    ReadbackKeypad *sourceKeypad = [purchasedKeypadsMutable objectAtIndex:sourceIndex];
    [purchasedKeypadsMutable removeObjectAtIndex:sourceIndex];
    [purchasedKeypadsMutable insertObject:sourceKeypad atIndex:destinationIndex];
    self.purchasedKeypads = purchasedKeypadsMutable;
    [ReadbackSalesManager savePurchasedKeypadsSorted:self.purchasedKeypads];
}



//ReadbackStoreTableViewController:

-(NSInteger)numberOfStoreItems
{
    return [self.storeKeypads count];
}

-(ReadbackKeypad *)storeItemAtIndex:(NSInteger)row
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
    
    //IAP
    [self reloadStoreProducts];
}

-(void)viewWillAppear:(BOOL)animated
{
    //Refresh in case we are returning from a purchase:
    self.purchasedKeypads = [KeypadGenerator getKeypadsForIdentifiers:[ReadbackSalesManager getPurchasedKeypadsIdentifiers]];
    [self.purchasedKeypadsTableView reloadData];
    
    //IAP
    //self.storeKeypads = [KeypadGenerator getKeypadsForIdentifiers:[ReadbackSalesManager getStoreKeypadIdentifiers]];
    //[self.storeKeypadsTableView reloadData];
}

- (void)viewDidUnload {
    [self setPurchasedKeypadsTableView:nil];
    [self setStoreKeypadsTableView:nil];
    [super viewDidUnload];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Preview Segue: Set Store keypad to display:
    if ([segue.destinationViewController respondsToSelector:@selector(setKeypad:)]) {
        NSIndexPath *indexPath = [self.storeKeypadsTableView indexPathForCell:sender];
        [segue.destinationViewController setKeypad:[self.storeKeypads objectAtIndex:indexPath.row]];
    }
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        return YES;
    }
    return NO;
}




#pragma mark In-App Purchases


- (void)reloadStoreProducts {
    self.storeKeypads = nil;
    [self.storeKeypadsTableView reloadData];
    [[ReadbackSalesManager sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            self.storeKeypads = products;
            [self.storeKeypadsTableView reloadData];
        }
        //TODO solve this:
        //[self.refreshControl endRefreshing];
    }];
}

@end
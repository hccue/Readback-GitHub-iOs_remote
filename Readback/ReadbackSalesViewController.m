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

//animation
#import "ReadbackViewController.h"

#define BUTTON_LABEL_SORT @"Sort"
#define BUTTON_LABEL_DONE @"Done"

@interface ReadbackSalesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *purchasedKeypadsTableView;
@property (weak, nonatomic) IBOutlet UITableView *storeKeypadsTableView;

//animation
@property (weak, nonatomic) IBOutlet UILabel *storeKeypadsLabel;

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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)restorePurchases:(UIButton *)sender {
    [[ReadbackSalesManager sharedInstance] restoreCompletedTransactions];
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

//Load selected keypad on main View Controller
-(void) purchasedKeypadSelectedAtIndexPath:(NSIndexPath *)indexPath;
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.delegate loadKeypadWithIdentifier:((ReadbackKeypad *)[self.purchasedKeypads objectAtIndex:indexPath.row]).identifier];
    
}



#pragma mark Sorting

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
    
    
    
    NSMutableArray *identifiers = [NSMutableArray arrayWithCapacity:[self.purchasedKeypads count]];
    for (ReadbackKeypad *keypad in self.purchasedKeypads) {
        [identifiers addObject:keypad.identifier];
    }
    
    [ReadbackSalesManager savePurchasedIdentifiersToMemory:identifiers];
    
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
    //Set delegates and dataSources:
    self.purchasedKeypadsTableView.delegate = self.purchasedTableViewController;
    self.purchasedKeypadsTableView.dataSource = self.purchasedTableViewController;
    self.storeKeypadsTableView.delegate = self.storeTableViewController;
    self.storeKeypadsTableView.dataSource = self.storeTableViewController;
    
    
    //Delegate is always rootViewController:
    self.delegate = [[self.navigationController viewControllers] objectAtIndex:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    //Load here to refresh after purchasing:
    [self reloadPurchasedProducts];
    [self reloadStoreProducts];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productWasPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [ReadbackViewController animateHighlightView:self.storeKeypadsLabel];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setPurchasedKeypadsTableView:nil];
    [self setStoreKeypadsTableView:nil];
    [self setStoreKeypadsLabel:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Preview Segue: Set Store keypad to display:
    if ([segue.destinationViewController respondsToSelector:@selector(setKeypad:)]) {
        NSIndexPath *indexPath = [self.storeKeypadsTableView indexPathForCell:sender];
        [segue.destinationViewController setKeypad:[self.storeKeypads objectAtIndex:indexPath.row]];
    }
}

- (BOOL)shouldAutorotate {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        return NO;
    }
    return YES;
}


-(void)reloadPurchasedProducts
{
    //Unable to use Helper list due to:no sorting.
    self.purchasedKeypads = [KeypadGenerator getKeypadsForIdentifiers:[ReadbackSalesManager getPurchasedIdentifiersFromMemory]];
    [self.purchasedKeypadsTableView reloadData];
}

#pragma mark In-App Purchases


- (void)reloadStoreProducts {
    self.storeKeypads = nil;
    [self.storeKeypadsTableView reloadData];
    [[ReadbackSalesManager sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            //List built from SKProducts:
            NSMutableArray *storeKeypads = [NSMutableArray arrayWithCapacity:[products count]];
            for (SKProduct *product in products) {
                ReadbackKeypad *keypad = [KeypadGenerator generateKeypadWithIdentifier: product.productIdentifier];
                keypad.product = product;
                [storeKeypads addObject:keypad];
            }
            self.storeKeypads = storeKeypads;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.storeKeypadsTableView reloadData];
            });
        }
    }];
}


#pragma mark Notification Listening

//Notification Listener
- (void)productWasPurchased:(NSNotification *)notification {
    [self reloadPurchasedProducts];
    [self reloadStoreProducts];
}
@end

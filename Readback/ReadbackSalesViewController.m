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
        _purchasedTableViewController.delegate = self;
        _purchasedTableViewController.dataSource = self;
    }
    return  _purchasedTableViewController;
}

-(UITableViewController *)storeTableViewController
{
    if (!_storeTableViewController) {
        _storeTableViewController = [[ReadbackStoreTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        _storeTableViewController.delegate = self;
        _storeTableViewController.dataSource = self;
    }
    return _storeTableViewController;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)restorePurchases:(UIButton *)sender {
    //TODO Restore Purchases
}




#pragma mark UITableViewControllers implementation

//ReadbackPurchasesTableViewController:

-(NSArray *)purchasedKeypads
{
    if (_purchasedKeypads) {
        //TODO Check for purchases
        //_purchasedKeypads = ;
    }
    return _purchasedKeypads;
}

-(NSInteger)numberOfPurchasedItems
{
    return [self.purchasedKeypads count];
}

-(NSDictionary *)purchasedItemAtIndex:(NSInteger)row
{
    return [self.purchasedKeypads objectAtIndex:row];
}

-(void)purchasedItemWasSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_purchasedKeypads) {
        //TODO Check for purchases
    }
}

//ReadbackStoreTableViewController:

-(NSArray *)storeKeypads
{
    if (!_storeKeypads) { //Fixed set of Keypads:
        
        ReadbackKeypad *standardKeypad = [[ReadbackKeypad alloc] init];
        standardKeypad.title = @"Standard Keypad";
        standardKeypad.subtitle = @"Suits any pilot, anywhere.";
        standardKeypad.priority = [NSNumber numberWithInt:1];
        standardKeypad.purchased = [NSNumber numberWithBool:YES];
        standardKeypad.imageURL = @"standard.png";
        standardKeypad.price = [NSNumber numberWithFloat:0.00];
        standardKeypad.detail = @"This is the standard keypad, excellent as a handy tool in any phase of flight for short notes and simple clearances, however you may want to get a custom keypad for better performance in critical phases of flight";
        
        ReadbackKeypad *oceanicKeypad = [[ReadbackKeypad alloc] init];
        oceanicKeypad.title = @"Oceanic Keypad";
        oceanicKeypad.subtitle = @"Extended Range Package.";
        oceanicKeypad.priority = [NSNumber numberWithInt:2];
        oceanicKeypad.purchased = [NSNumber numberWithBool:NO];
        oceanicKeypad.imageURL = @"standard.png";
        oceanicKeypad.price = [NSNumber numberWithFloat:3.99];
        standardKeypad.detail = @"This keypad was carefully designed to be your best ally while enroute on Extended Range flights. Werther you are inside the NAT getting New York's Oceanic Clearance or perhaps a SIGMET in the NOPAC, you won't miss a thing.";
        
        _storeKeypads = [NSArray arrayWithObjects:standardKeypad, oceanicKeypad, nil];
    }
    return _storeKeypads;
}

-(NSInteger)numberOfStoreItems
{
    return [self.storeKeypads count];
}

-(NSDictionary *)storeItemAtIndex:(NSInteger)row
{
    return [self.storeKeypads objectAtIndex:row];
}

-(void)storeItemWasSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    //TODO Implement
}



#pragma mark UITableView Lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    self.purchasedKeypadsTableView.delegate = self.purchasedTableViewController;
    self.purchasedKeypadsTableView.dataSource = self.purchasedTableViewController;
    
    self.storeKeypadsTableView.delegate = self.storeTableViewController;
    self.storeKeypadsTableView.dataSource = self.storeTableViewController;
}

- (void)viewDidUnload {
    [self setPurchasedKeypadsTableView:nil];
    [self setStoreKeypadsTableView:nil];
    [super viewDidUnload];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setKeypad:)]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        //TODO Get the correct cell:
        [segue.destinationViewController setKeypad:[self.storeKeypads objectAtIndex:0]];
        
    }
}

@end

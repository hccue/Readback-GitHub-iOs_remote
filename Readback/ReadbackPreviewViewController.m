//
//  ReadbackPreviewViewController.m
//  Readback
//
//  Created by Santiago Borja on 1/15/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackPreviewViewController.h"
#import "ReadbackSalesManager.h"

@interface ReadbackPreviewViewController ()

//Outlets:
@property (weak, nonatomic) IBOutlet UILabel *keypadTitle;
@property (weak, nonatomic) IBOutlet UIImageView *keypadImageView;
@property (weak, nonatomic) IBOutlet UILabel *keypadDetail;
@property (weak, nonatomic) IBOutlet UIButton *purchaseButton;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;

@end

@implementation ReadbackPreviewViewController
@synthesize keypad = _keypad;

-(void)setKeypad:(ReadbackKeypad *)keypad
{
    if (_keypad != keypad) {
        _keypad = keypad;
        [self loadKeypadInformation];
    }
}

-(void)loadKeypadInformation
{
    self.keypadTitle.text = [NSString stringWithFormat:STRING_FORMAT_TITLE, self.keypad.title, self.keypad.subtitle];
    self.keypadDetail.text = self.keypad.description;
    self.keypadImageView.image = [UIImage imageNamed:self.keypad.imageURL];
    
    if ([[ReadbackSalesManager sharedInstance] productPurchased:self.keypad.product.productIdentifier]) {
        [self disablePurchaseButton];
    } else {
        NSNumberFormatter *priceFormatter = [ReadbackKeypad priceFormatter];
        [priceFormatter setLocale:self.keypad.product.priceLocale];
            
        [self.purchaseButton setTitle:[NSString stringWithFormat:STRING_FORMAT_PURCHASE_BUTTON, [priceFormatter stringFromNumber:self.keypad.product.price]] forState:UIControlStateNormal];
    }
}

-(void)disablePurchaseButton
{
    [self.purchaseButton setTitle:LABEL_PURCHASED forState:UIControlStateNormal];
    self.purchaseButton.enabled = NO;
    [self.returnButton setTitle:LABEL_RETURN forState:UIControlStateNormal];
}

- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)purchaseTapped:(UIButton *)sender
{   //Perform Purchase!!
    [[ReadbackSalesManager sharedInstance] buyProduct: self.keypad.product];
}

//Notification Listener
- (void)productPurchased:(NSNotification *)notification {
    //change layout
    if ([self.keypad.product.productIdentifier isEqualToString:notification.object]) {
        [self disablePurchaseButton];
    }
    
    //Return to store VC
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark UIView Lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [self loadKeypadInformation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidUnload {
    [self setKeypadTitle:nil];
    [self setKeypadImageView:nil];
    [self setKeypadDetail:nil];
    [self setPurchaseButton:nil];
    [self setReturnButton:nil];
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        return YES;
    }
    return NO;
}

@end
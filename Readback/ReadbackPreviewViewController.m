//
//  ReadbackPreviewViewController.m
//  Readback
//
//  Created by Santiago Borja on 1/15/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackPreviewViewController.h"
#import "ReadbackSalesManager.h"
#import "CuesoftHelper.h"

//animation
#import "ReadbackViewController.h"

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
    
    if ([ReadbackSalesManager keypadIdentifierIsPurchased:self.keypad.product.productIdentifier]) {
        [self disablePurchaseButton];
    } else {
        NSNumberFormatter *priceFormatter = [CuesoftHelper priceFormatter];
        [priceFormatter setLocale:self.keypad.product.priceLocale];
            
        [self.purchaseButton setTitle:[NSString stringWithFormat:STRING_FORMAT_PURCHASE_BUTTON, [priceFormatter stringFromNumber:self.keypad.product.price]] forState:UIControlStateNormal];
    }
    
    
    //Get UIImageViews and UILabels for each key
    //UIImageView is multiple of 10, UILabel is Image's tag + 1
    int tagValue = 10;
    for (NSString *key in self.keypad.marketingKeys) {
        UIImageView *imageView = (UIImageView *)[self.view viewWithTag:tagValue];
        [imageView setImage:[UIImage imageNamed:key]];
        
        UILabel *keyLabel = (UILabel *)[self.view viewWithTag:tagValue + 1];
        keyLabel.text = [self.keypad.marketingKeys objectForKey:key];
        
        tagValue += 10;
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
- (void)productWasPurchased:(NSNotification *)notification {
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productWasPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [ReadbackViewController animateHighlightView:self.purchaseButton];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setKeypadTitle:nil];
    [self setKeypadImageView:nil];
    [self setKeypadDetail:nil];
    [self setPurchaseButton:nil];
    [self setReturnButton:nil];
}

- (BOOL)shouldAutorotate {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        return NO;
    }
    return YES;
}

@end

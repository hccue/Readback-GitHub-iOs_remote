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
    
    if ([ReadbackSalesManager keypadIsPurchased:self.keypad]) {
        [self.purchaseButton setTitle:LABEL_PURCHASED forState:UIControlStateNormal];
        self.purchaseButton.enabled = NO;
        [self.returnButton setTitle:LABEL_RETURN forState:UIControlStateNormal];
    } else {
        [self.purchaseButton setTitle:[NSString stringWithFormat:STRING_FORMAT_PURCHASE_BUTTON, self.keypad.product.price.doubleValue] forState:UIControlStateNormal];
    }
}

- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)purchaseTapped:(UIButton *)sender {
    //Perform Purchase!!
    [[ReadbackSalesManager sharedInstance] buyProduct: self.keypad.product];
}




#pragma mark UIView Lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    [self loadKeypadInformation];
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

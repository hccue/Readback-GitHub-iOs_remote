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
    self.keypadTitle.text = [NSString stringWithFormat:@"%@, %@", self.keypad.title, self.keypad.subtitle];
    self.keypadDetail.text = self.keypad.detail;
    self.keypadImageView.image = [UIImage imageNamed:self.keypad.imageURL];
    
    if ([ReadbackSalesManager keypadIsPurchased:self.keypad]) {
        [self.purchaseButton setTitle:LABEL_PURCHASED forState:UIControlStateNormal];
        self.purchaseButton.enabled = NO;
        [self.returnButton setTitle:LABEL_RETURN forState:UIControlStateNormal];
    }
}

- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)performPurchase:(UIButton *)sender {
    if (![ReadbackSalesManager keypadIsPurchased:self.keypad]) [ReadbackSalesManager performPurchaseOfKeypad:self.keypad];
}

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
@end

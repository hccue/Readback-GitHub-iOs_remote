//
//  ReadbackPreviewViewController.m
//  Readback
//
//  Created by Santiago Borja on 1/15/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackPreviewViewController.h"

@interface ReadbackPreviewViewController ()
@property (weak, nonatomic) IBOutlet UILabel *keypadTitle;
@property (weak, nonatomic) IBOutlet UIImageView *keypadImageView;
@property (weak, nonatomic) IBOutlet UILabel *keypadDetail;


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
}

- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadKeypadInformation];
}

- (void)viewDidUnload {
    [self setKeypadTitle:nil];
    [self setKeypadImageView:nil];
    [self setKeypadDetail:nil];
    [super viewDidUnload];
}
@end

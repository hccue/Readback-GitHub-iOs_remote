//
//  ReadbackHelpViewController.m
//  Readback
//
//  Created by Santiago Borja on 1/11/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackHelpViewController.h"

@interface ReadbackHelpViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@end

@implementation ReadbackHelpViewController
@synthesize versionLabel = _versionLabel;

- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)visitFriendApp:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_FRIEND_APP]];
}

- (IBAction)rateApp:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:URL_RATE, APP_ID]]];
}

#pragma mark UIViewController Lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    self.versionLabel.text = [NSString stringWithFormat:PATTERN_VERSION, [[NSBundle mainBundle] objectForInfoDictionaryKey:STRING_BUNDLE_VERSION ]];
}

- (void)viewDidUnload {
    [self setVersionLabel:nil];
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

@end
//
//  ReadbackHelpViewController.m
//  Readback
//
//  Created by Santiago Borja on 1/11/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackHelpViewController.h"
#import <MessageUI/MessageUI.h>

@interface ReadbackHelpViewController () <MFMailComposeViewControllerDelegate>
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

- (IBAction)emailTapped:(UIButton *)sender {
    [self displayComposerSheet];
}


-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Readback App Suggestion!"];
    
    // Set up the recipients.
    NSArray *toRecipients = [NSArray arrayWithObjects:@"cuesoftapps@gmail.com",
                             nil];
    NSArray *ccRecipients = [NSArray arrayWithObjects: nil];
    NSArray *bccRecipients = [NSArray arrayWithObjects: nil];
    
    [picker setToRecipients:toRecipients];
    [picker setCcRecipients:ccRecipients];
    [picker setBccRecipients:bccRecipients];
    
     
    // Fill out the email body text.
    NSString *emailBody = @"I have a suggestion about the App,\n\n";
    [picker setMessageBody:emailBody isHTML:NO];
    
    // Present the mail composition interface.
    [self presentModalViewController:picker animated:YES];
}

// The mail compose view controller delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
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
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        return YES;
    }
    return NO;
}

@end
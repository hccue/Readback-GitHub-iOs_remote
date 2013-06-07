//
//  ReadbackHelpViewController.m
//  Readback
//
//  Created by Santiago Borja on 1/11/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackHelpViewController.h"
#import <MessageUI/MessageUI.h>
#import "CuesoftHelper.h"

//animation
#import "ReadbackViewController.h"

@interface ReadbackHelpViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

//animation
@property (weak, nonatomic) IBOutlet UIButton *rateAppButton;
@property (weak, nonatomic) IBOutlet UIButton *fbLikeButton;
@end

@implementation ReadbackHelpViewController
@synthesize versionLabel = _versionLabel;

- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)visitFirendApp1:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_FRIEND_APP_1]];
}

- (IBAction)visitFriendApp2:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_FRIEND_APP_2]];
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
    
    [picker setSubject:SUGGESTION_EMAIL_SUBJECT];
    
    // Set up the recipients.
    NSArray *toRecipients = [NSArray arrayWithObjects:SUGGESTION_EMAIL_TO,
                             nil];
    NSArray *ccRecipients = [NSArray arrayWithObjects: nil];
    NSArray *bccRecipients = [NSArray arrayWithObjects: nil];
    
    [picker setToRecipients:toRecipients];
    [picker setCcRecipients:ccRecipients];
    [picker setBccRecipients:bccRecipients];
    
     
    // Fill out the email body text.
    NSString *emailBody = SUGGESTION_EMAIL_BODY;
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

- (IBAction)facebookLikeTapped:(UIButton *)sender {
    [CuesoftHelper openFacebookID:FACEBOOK_ID];
}



#pragma mark UIViewController Lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    self.versionLabel.text = [NSString stringWithFormat:PATTERN_VERSION, [[NSBundle mainBundle] objectForInfoDictionaryKey:STRING_BUNDLE_VERSION ]];
}

-(void)viewDidAppear:(BOOL)animated
{
    [ReadbackViewController animateHighlightView:self.fbLikeButton];
}

- (void)viewDidUnload {
    [self setVersionLabel:nil];
    [self setRateAppButton:nil];
    [self setFbLikeButton:nil];
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
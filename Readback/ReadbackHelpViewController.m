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
@property (weak, nonatomic) IBOutlet UIButton *rateAppButton;
@end

@implementation ReadbackHelpViewController
@synthesize versionLabel = _versionLabel;

- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)crewCurrencyAppTapped:(id)sender {
    [[UIApplication sharedApplication]  openURL: [NSURL URLWithString:[NSString stringWithFormat:URL_APPSTORE_ANY_APP, APP_ID_CREW_CURRENCY]]
                                        options:@{} completionHandler:^(BOOL success) {
        if (success) {
             NSLog(@"Opened url");
        }
    }];
}
- (IBAction)appSpeedAppTapped:(id)sender {
    [[UIApplication sharedApplication]  openURL: [NSURL URLWithString:[NSString stringWithFormat:URL_APPSTORE_ANY_APP, APP_ID_APP_SPEED]]
                                        options:@{} completionHandler:^(BOOL success) {
        if (success) {
             NSLog(@"Opened url");
        }
    }];
}
- (IBAction)erOpsAppTapped:(id)sender {
    [[UIApplication sharedApplication]  openURL: [NSURL URLWithString:[NSString stringWithFormat:URL_APPSTORE_ANY_APP, APP_ID_ER_OPS]]
                                        options:@{} completionHandler:^(BOOL success) {
        if (success) {
             NSLog(@"Opened url");
        }
    }];
}

- (IBAction)rateApp:(UIButton *)sender {
    if([SKStoreReviewController class]){
        [SKStoreReviewController requestReview] ;
    }else{
        [[UIApplication sharedApplication]  openURL: [NSURL URLWithString:[NSString stringWithFormat:URL_RATE, APP_ID]]
                                            options:@{} completionHandler:^(BOOL success) {
            if (success) {
                 NSLog(@"Opened url");
            }
        }];
    }
}

- (IBAction)emailTapped:(UIButton *)sender {
    [self displayComposerSheet];
}

-(void)displayComposerSheet
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        picker.navigationBar.tintColor = [UIColor whiteColor];
        [picker setSubject:SUGGESTION_EMAIL_SUBJECT];
        
        // Set up the recipients.
        NSArray *toRecipients = [NSArray arrayWithObjects:SUGGESTION_EMAIL_TO,
                                 nil];
        
        [picker setToRecipients:toRecipients];
        [picker setCcRecipients:nil];
        [picker setBccRecipients:nil];
        
        
        // Fill out the email body text.
        NSString *emailBody = SUGGESTION_EMAIL_BODY;
        [picker setMessageBody:emailBody isHTML:NO];
        
        // Present the mail composition interface.
        
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:ALERT_NOEMAIL_TITLE
                                                            message:[NSString stringWithFormat:ALERT_NOEMAIL_MESSAGE, SUGGESTION_EMAIL_TO]
                                                           delegate:self
                                                  cancelButtonTitle:ALERT_NOEMAIL_BUTTON
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}

// The mail compose view controller delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [[controller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIViewController Lifecycle

-(void)viewWillAppear:(BOOL)animated
{
    self.versionLabel.text = [NSString stringWithFormat:PATTERN_VERSION, [[NSBundle mainBundle] objectForInfoDictionaryKey:STRING_BUNDLE_VERSION ]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setVersionLabel:nil];
    [self setRateAppButton:nil];
    
}

- (BOOL)shouldAutorotate {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        return NO;
    }
    return YES;
}

@end

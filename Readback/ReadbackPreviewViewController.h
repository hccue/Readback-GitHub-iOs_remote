//
//  ReadbackPreviewViewController.h
//  Readback
//
//  Created by Santiago Borja on 1/15/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadbackKeypad.h"

#define STRING_FORMAT_TITLE @"%@, %@"
#define STRING_FORMAT_PURCHASE_BUTTON @"Purchase for $%1.2f"

#define LABEL_PURCHASED @"Already Purchased"
#define LABEL_RETURN    @"Return"


//Alert messages constants:
#define ALERT_CONFIRM_PURCHASE  1
#define ALERT_PURCHASED_OK      2
#define ALERT_ALREADY_PURCHASED 3

#define CONFIRM_PURCHASE_MESSAGE_TITLE     @"Confirm Purchase"
#define CONFIRM_PURCHASE_MESSAGE_BODY      @"You are about to purchase a keypad for $1.99"
#define CONFIRM_PURCHASE_MESSAGE_BUTTON_OK    @"Confirm"
#define CONFIRM_PURCHASE_MESSAGE_BUTTON_CANCEL    @"Cancel"

#define PURCHASED_MESSAGE_TITLE     @"Congratulations!"
#define PURCHASED_MESSAGE_BODY      @"You just purchased a new Keypad"
#define PURCHASED_MESSAGE_BUTTON    @"Thanks"

#define ALREADY_PURCHASED_MESSAGE_TITLE     @"Already Purchased!"
#define ALREADY_PURCHASED_MESSAGE_BODY      @"You have already purchased this keypad. No transaction was performed."
#define ALREADY_PURCHASED_MESSAGE_BUTTON    @"Ok"

@interface ReadbackPreviewViewController : UIViewController

@property (nonatomic, strong) ReadbackKeypad *keypad;

@end

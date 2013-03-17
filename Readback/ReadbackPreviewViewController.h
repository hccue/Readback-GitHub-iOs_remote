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

@interface ReadbackPreviewViewController : UIViewController

@property (nonatomic, strong) ReadbackKeypad *keypad;

@end

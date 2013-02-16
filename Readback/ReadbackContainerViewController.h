//
//  ReadbackContainerViewController.h
//  Readback
//
//  Created by Santiago Borja on 1/30/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeypadSuperViewController.h"

#define KEYPAD_SWAP_DURATION 0.5

@interface ReadbackContainerViewController : UIViewController <KeypadDelegate>
-(void)buttonPressed:(UIButton *)button;
@end

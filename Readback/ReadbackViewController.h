//
//  ReadbackViewController.h
//  Readback
//
//  Created by Santiago Borja on 1/6/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//


//TODO
#warning FINISH
//WHAT'S NEW UPDATE
//HELP SCREEN CHANGE TO FIT PORTRAIT
//MY APPS LINKS CRASH ITUNES APP STORE
//




#import <UIKit/UIKit.h>
#import "KeypadViewController.h"
#import "ReadbackSalesViewController.h"

#define APP_ID @"581569231"

#define USERKEY_FIRST_START @"firstStart"
#define USERKEY_HELP_VIEWED @"helpButtonTapped"

#define WHAT_IS_NEW_SCREEN_NAME @"what-is-new.png"

#define SEGUE_CUSTOMIZE @"CustomizeSegue"

#define TEXT_SPACE @"   "
#define TEXT_TAG_FORMAT @"%@   "
#define CLEARANCE_GAP 2
#define IMAGE_SCALE_FACTOR 0.65
#define CLEARANCE_FONT_SIZE 30
#define CLEARANCE_FONT_FAMILY @"Avenir Next"

#define KEYPAD_SWAP_ANIMATION_DURATION 0.5

#define LOG_ROW_HEIGHT 30
#define LOG_CLEARANCE_GAP 2
#define LOG_CLEARANCE_FONT_SIZE 15
#define LOG_CLEARANCE_FONT_FAMILY @"Avenir Next"
#define LOG_TIME_FORMAT @"%@ :  "

#define ZULU_TIME_FORMAT_SHORT @"HH:mm 'Z"
#define ZULU_TIME_FORMAT_LONG @"HH:mm:ss 'Z"

#define CLOCK_TIMER_DURATION 1.0

#define COLOR_LOG_TIME [UIColor grayColor]
#define COLOR_TEXT [UIColor greenColor]
#define COLOR_BACKGROUND_TEXT_COLOR [UIColor clearColor]


//Help Button Animation
#define HELP_BUTTON_TIMER_DURATION 2.5
#define VIEW_ANIMATION_DURATION 0.05
#define VIEW_ANIMATION_SCALE 1.8
#define HELP_IMAGE_NAME @"help-slide.png"


@interface ReadbackViewController : UIViewController <KeypadDelegate, UIGestureRecognizerDelegate, ReadbackSalesViewControllerDelegate, UIDocumentInteractionControllerDelegate>

+(void)animateHighlightView:(UIView *)view;
@end

//
//  ReadbackViewController.h
//  Readback
//
//  Created by Santiago Borja on 1/6/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeypadViewController.h"
#import "ReadbackSalesViewController.h"

#define APP_ID @"581569231"
#define URL_RATE @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@"

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
#define HELP_IMAGE_NAME @"key-help.png"


//PDF display
#define PDF_PAGE_WIDTH_PX 800
#define PDF_PAGE_HEIGHT_PX 600

#define PDF_CONTEXT_TITLE "Flight Log"
#define PDF_CONTEXT_CREATOR "Cuesoft Apps"

#define PDF_TITLE_FONT "Helvetica"
#define PDF_TITLE_FONT_SIZE 18
#define PDF_TITLE_LEFT_GAP 50
#define PDF_TITLE_TOP_GAP 28

#define PDF_DEFAULT_TITLE @"Flight Log"
#define PDF_FORMAT_TITLE @"%@ Summary"
#define PDF_FORMAT_TITLE_PAGE @"Page %d"
#define PDF_TIME_FORMAT @"yyyy/MM/dd 'at' HH:mm'Z"

#define PDF_PAGE_DATE_GAP_RIGHT 180

#define PDF_SEPARATOR_TOP_GAP 40
#define PDF_SEPARATOR_HEIGHT 1

#define PDF_ROWS_LEFT_GAP 20
#define PDF_ROWS_TOP_GAP 20//varies with smaller pdf_page_height, then not???? clean: acts as space from the last component: separator
#define PDF_ROWS_MID_GAP 30 //*
#define PDF_MAX_ROWS_PER_PAGE 17

#define PDF_NAME_DEFAULT @"flight"
#define PDF_NAME_FORMAT_DATE @"yy_MM_dd_HHmm'Z"
#define PDF_NAME_FORMAT @"flightLog_%@_%@.pdf"


@interface ReadbackViewController : UIViewController <KeypadDelegate, UIGestureRecognizerDelegate, ReadbackSalesViewControllerDelegate, UIDocumentInteractionControllerDelegate>

+(void)animateHighlightView:(UIView *)view;
@end

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

#define SEGUE_CUSTOMIZE @"CustomizeSegue"

#define TEXT_SPACE @"   "
#define TEXT_TAG_FORMAT @"%@   "
#define CLEARANCE_GAP 2
#define IMAGE_SCALE_FACTOR 0.65
#define CLEARANCE_FONT_SIZE 30
#define CLEARANCE_FONT_FAMILY @"Avenir Next"

#define KEYPAD_SWAP_ANIMATION_DURATION 0.5

#define LOG_ANIMATION_DURATION 0.5
#define LOG_IMAGE_SCALE_FACTOR 0.45
#define LOG_ROW_HEIGHT 35
#define LOG_CLEARANCE_GAP 2
#define LOG_CLEARANCE_FONT_SIZE 15
#define LOG_CLEARANCE_FONT_FAMILY @"Avenir Next"
#define LOG_TIME_FORMAT @"%@ :  "

#define ZULU_TIMEZONE @"UTC"
#define ZULU_TIME_FORMAT_SHORT @"HH:mm 'Z"
#define ZULU_TIME_FORMAT_LONG @"HH:mm:ss 'Z"

#define CLOCK_TIMER_DURATION 1.0

#define COLOR_LOG_TIME [UIColor grayColor]
#define COLOR_TEXT [UIColor greenColor]
#define COLOR_BACKGROUND_TEXT_COLOR [UIColor clearColor]



@interface ReadbackViewController : UIViewController <KeypadDelegate, UIGestureRecognizerDelegate, ReadbackSalesViewControllerDelegate>
@end

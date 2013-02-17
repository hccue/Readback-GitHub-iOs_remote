//
//  ReadbackViewController.h
//  Readback
//
//  Created by Santiago Borja on 1/6/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeypadViewController.h"

#define TEXT_SPACE @"   "
#define CLEARANCE_GAP 2
#define IMAGE_SCALE_FACTOR 0.65
#define CLEARANCE_FONT_SIZE 30
#define CLEARANCE_FONT_FAMILY @"Avenir Next"

#define KEYPAD_SWAP_ANIMATION_DURATION 0.5

#define HISTORY_ANIMATION_DURATION 0.5
#define HISTORY_IMAGE_SCALE_FACTOR 0.45
#define HISTORY_ROW_HEIGHT 40
#define HISTORY_CLEARANCE_GAP 2
#define HISTORY_CLEARANCE_FONT_SIZE 15
#define HISTORY_CLEARANCE_FONT_FAMILY @"Avenir Next"
#define HISTORY_TIME_FORMAT @"%@ :  "

#define ZULU_TIMEZONE @"UTC"
#define ZULU_TIME_FORMAT_SHORT @"HH:mm 'Z"
#define ZULU_TIME_FORMAT_LONG @"HH:mm:ss 'Z"

#define CLOCK_TIMER_DURATION 1.0

#define COLOR_HISTORY_TIME [UIColor grayColor]
#define COLOR_TEXT [UIColor greenColor]
#define COLOR_BACKGROUND_TEXT_COLOR [UIColor clearColor]



@interface ReadbackViewController : UIViewController <KeypadDelegate>
-(IBAction)buttonPressed:(UIButton *)button;
@end

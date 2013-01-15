//
//  ReadbackKeypad.h
//  Readback
//
//  Created by Santiago Borja on 1/15/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEYPAD_KEY_TITLE @"Title"
#define KEYPAD_KEY_SUBTITLE @"Subtitle"

@interface ReadbackKeypad : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *purchased;//BOOL
@property (nonatomic, strong) NSNumber *priority; //On the list of keypads

@end

//
//  ReadbackHelper.h
//  Readback
//
//  Created by Santiago Borja on 2/25/15.
//  Copyright (c) 2015 Santiago Borja. All rights reserved.
//

#import <Foundation/Foundation.h>


#define LOG_CLEARANCE_FONT_SIZE 15
#define LOG_CLEARANCE_FONT_FAMILY @"Avenir Next"
#define IMAGE_SCALE_FACTOR 0.65

@interface ReadbackHelper : NSObject

+(UIView *)reduceView:(UIView *)view toScale:(float)scale;
+(UIView *)changeToNightView:(UIView *)view;
+(UILabel *)getLabelForString:(NSString *)text;

@end

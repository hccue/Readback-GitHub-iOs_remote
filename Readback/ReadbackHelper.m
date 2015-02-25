//
//  ReadbackHelper.m
//  Readback
//
//  Created by Santiago Borja on 2/25/15.
//  Copyright (c) 2015 Santiago Borja. All rights reserved.
//

#import "ReadbackHelper.h"
#import "CuesoftHelper.h"
#import "KeyInterpreter.h"
#import "PDFHelper.h"

@implementation ReadbackHelper


//Reduce size of symbols for log display
+(UIView *)reduceView:(UIView *)view toScale:(float)scale
{
    CGRect frame = view.frame;
    frame.size = CGSizeMake(frame.size.width * scale, frame.size.height * scale);
    view.frame = frame;
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label =(UILabel *)view;
        [label setFont:[UIFont fontWithName:LOG_CLEARANCE_FONT_FAMILY size:LOG_CLEARANCE_FONT_SIZE]];
        [label sizeToFit];
    }
    return view;
}

+(UIView *)changeToNightView:(UIView *)view
{
    UIView *newView = [[UIView alloc] init];
    for (int x = 0; x < view.subviews.count; x++) {
        UIView *subView = (UIImageView *)[view.subviews objectAtIndex:x];
        UIView *newSubView = [[UIView alloc] init];
        if ([subView isKindOfClass:[UIImageView class]]) {
            NSString *imageName = [KeyInterpreter getSymbolForTag:(int)subView.tag isDaySymbol:true];
            UIImage *image = [UIImage imageNamed:imageName];
            newSubView = (UIImageView *)[ReadbackHelper reduceView:[[UIImageView alloc] initWithImage:image] toScale:IMAGE_SCALE_FACTOR];
        }else{
            newSubView = [CuesoftHelper copyLabel:(UILabel *)subView];
        }
        newSubView.frame = subView.frame;
        [newView addSubview:newSubView];
    }
    return newView;
}

+(UILabel *)getLabelForString:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont fontWithName:@PDF_TITLE_FONT size:PDF_TITLE_FONT_SIZE];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    
    return label;
}


@end

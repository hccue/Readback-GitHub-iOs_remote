//
//  ReadbackKeypad.m
//  Readback
//
//  Created by Santiago Borja on 1/15/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackKeypad.h"

@implementation ReadbackKeypad
@synthesize identifier = _identifier;
@synthesize name = _name;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize description = _description;
@synthesize imageURL = _imageURL;
@synthesize product = _product;


+ (NSNumberFormatter *)priceFormatter
{
    NSNumberFormatter *priceFormatter;
    priceFormatter = [[NSNumberFormatter alloc] init];
    [priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    return priceFormatter;
}

@end

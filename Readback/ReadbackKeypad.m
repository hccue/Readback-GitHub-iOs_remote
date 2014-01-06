//
//  ReadbackKeypad.m
//  Readback
//
//  Created by Santiago Borja on 1/15/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackKeypad.h"
#import "CuesoftHelper.h"

@implementation ReadbackKeypad
@synthesize identifier = _identifier;
@synthesize name = _name;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize description = _description;
@synthesize imageURL = _imageURL;
@synthesize product = _product;
@synthesize marketingKeys = _marketingKeys;

- (void) loadDataFromPlistNamed:(NSString *)plistName
{
    NSDictionary *plist = [CuesoftHelper getPropertyListNamed:plistName];
    self.name = [plist objectForKey:@"name"];
    self.title = [plist objectForKey:@"title"];
    self.subtitle = [plist objectForKey:@"subtitle"];
    self.description = [plist objectForKey:@"description"];
    self.imageURL = [plist objectForKey:@"imageURL"];
    self.product = [plist objectForKey:@"product"]; //TODO IS THIS REALLY NECESSARY?
    self.marketingKeys = [NSMutableDictionary dictionaryWithDictionary:[plist objectForKey:@"keys"]];
}

@end

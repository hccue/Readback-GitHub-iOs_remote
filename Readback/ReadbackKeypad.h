//
//  ReadbackKeypad.h
//  Readback
//
//  Created by Santiago Borja on 1/15/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

//No values can be nil
@interface ReadbackKeypad : NSObject
@property (nonatomic, strong) NSString *identifier; //IAP Identifier
@property (nonatomic, strong) NSString *name;       //VC Xib File Name
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) SKProduct *product;


+ (NSNumberFormatter *)priceFormatter;
@end

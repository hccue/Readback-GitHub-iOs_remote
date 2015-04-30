//
//  ReadbackKeypad.h
//  Readback
//
//  Created by Santiago Borja on 1/15/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h> //For declaring SKProduct

//No values can be nil
@interface ReadbackKeypad : NSObject
@property (nonatomic, strong) NSString *identifier; //IAP Identifier
@property (nonatomic, copy) NSString *name;       //VC Xib File Name
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) SKProduct *product;   //SKProduct received from IAP
@property (nonatomic, strong) NSDictionary  *marketingKeys; //key: NSString image name, value: NSString description. 7 Items total.

- (void) loadDataFromPlistNamed:(NSString *)plistName;
@end

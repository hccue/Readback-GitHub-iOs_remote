//
//  KeypadViewController.h
//  Readback
//
//  Created by Santiago Borja on 2/16/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeypadDelegate <NSObject>
-(void)buttonPressed:(UIButton *)button;
@end

@interface KeypadViewController : UIViewController
@property (nonatomic, strong) id <KeypadDelegate> delegate;
@end

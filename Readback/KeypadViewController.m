//
//  KeypadViewController.m
//  Readback
//
//  Created by Santiago Borja on 2/16/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "KeypadViewController.h"
#import "ReadbackViewController.h"

@interface KeypadViewController ()

@end

@implementation KeypadViewController
@synthesize delegate = _delegate;

-(void)didMoveToParentViewController:(UIViewController *)parent
{
    [self addButtonActions];
    
    [super didMoveToParentViewController:parent];
    ReadbackViewController *container = (ReadbackViewController *)parent;
    self.delegate = container;
}

-(void)addButtonActions
{
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [((UIButton *)view) addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)buttonPressed:(UIButton *)sender {
    [self.delegate buttonPressed:sender];
}

@end

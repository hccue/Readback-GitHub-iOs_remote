//
//  KeypadSuperViewController.m
//  Readback
//
//  Created by Santiago Borja on 2/15/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "KeypadSuperViewController.h"
#import "ReadbackContainerViewController.h"

@interface KeypadSuperViewController ()

@end

@implementation KeypadSuperViewController
@synthesize delegate = _delegate;

-(void)didMoveToParentViewController:(UIViewController *)parent
{
    [self addButtonActions];
    
    [super didMoveToParentViewController:parent];
    ReadbackContainerViewController *container = (ReadbackContainerViewController *)parent;
    self.delegate = container;
}

-(void)addButtonActions
{
    
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [((UIButton *)view) addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        }
    }
}

- (void)buttonPressed:(UIButton *)sender {
    [self.delegate buttonPressed:sender];
}

@end
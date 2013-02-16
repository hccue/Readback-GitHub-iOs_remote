//
//  ReadbackContainerViewController.m
//  Readback
//
//  Created by Santiago Borja on 1/30/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackContainerViewController.h"
#import "ReadbackSalesManager.h"
#import "KeypadSuperViewController.h"

@interface ReadbackContainerViewController ()

@property (nonatomic, strong) NSArray *subViewControllers;
@property (nonatomic, strong) UIViewController *selectedViewController;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation ReadbackContainerViewController
@synthesize subViewControllers = _subViewControllers;
@synthesize selectedViewController = _selectedViewController;
@synthesize containerView = _containerView;

-(void)buttonPressed:(UIButton *)button
{
    NSLog(@"PRESSED %d", button.tag);
}

-(void)loadPurchasedKeypads
{
    NSArray *purchasedKeypads = [ReadbackSalesManager getPurchasedKeypads];
    
    //Get each keypad's ViewController
    NSMutableArray *keypadsViewControllers = [[NSMutableArray alloc] initWithCapacity:[purchasedKeypads count]];
    for (ReadbackKeypad *keypad in purchasedKeypads) {
        KeypadSuperViewController *correspondingVC = [[KeypadSuperViewController alloc] initWithNibName:keypad.name bundle:nil];
        [keypadsViewControllers addObject: correspondingVC];
    }
    
    [self setSubViewControllers:keypadsViewControllers];
}

- (void)setSubViewControllers:(NSArray *)subViewControllers
{
	_subViewControllers = [subViewControllers copy];
    
	if (self.selectedViewController)
	{
        NSLog(@"remove !!!");
		// TODO: remove previous VC
	}
    
	self.selectedViewController = [subViewControllers objectAtIndex:0];
	// cannot add here because the view might not have been loaded yet
}



#pragma mark UIGestureRecognizer Swipe

- (void)swipe:(UISwipeGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateRecognized)
	{
		NSInteger index = [self.subViewControllers indexOfObject:self.selectedViewController];
		
        UIViewAnimationOptions *option;
        if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
            index = MIN(index+1, [self.subViewControllers count]-1);
            option = UIViewAnimationOptionTransitionFlipFromLeft;
        }else{
            index = MAX(index-1, 0);
            option = UIViewAnimationOptionTransitionFlipFromRight;
        }
        
		UIViewController *newSubViewController = [self.subViewControllers objectAtIndex:index];
		[self transitionFromViewController:self.selectedViewController toViewController:newSubViewController withAnimation:UIViewAnimationOptionTransitionFlipFromLeft];
	}
}

- (void)transitionFromViewController:(UIViewController *)fromViewController
                    toViewController:(UIViewController *)toViewController
                       withAnimation:(UIViewAnimationOptions *)animation
{
    // cannot transition to same
	if (fromViewController == toViewController) return;
    
	// animation setup
	toViewController.view.frame = self.containerView.bounds;
	toViewController.view.autoresizingMask = self.containerView.autoresizingMask;
    
	// notify
	[fromViewController willMoveToParentViewController:nil];
	[self addChildViewController:toViewController];
    
	// transition
	[self transitionFromViewController:fromViewController
					  toViewController:toViewController
							  duration:KEYPAD_SWAP_DURATION
							   options:animation
							animations:^{
							}
							completion:^(BOOL finished) {
								[toViewController didMoveToParentViewController:self];
								[fromViewController removeFromParentViewController];
							}];
    
    self.selectedViewController = toViewController;
}




-(void)setSelectedViewController:(UIViewController *)selectedViewController
{
    _selectedViewController = selectedViewController;
    //KeypadSuperViewController *svc = (KeypadSuperViewController *)selectedViewController;
    //*svc.delegate = self;
}






#pragma mark UIView Lifecycle

-(void)viewDidLoad
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.containerView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.containerView addGestureRecognizer:swipeRight];
    
    [self loadPurchasedKeypads];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
	if (self.selectedViewController.parentViewController == self)
	{
        NSLog(@"nothing to do");
		// nowthing to do
		return;
	}
    
	// adjust the frame to fit in the container view
	self.selectedViewController.view.frame = self.containerView.bounds;
    
	// make sure that it resizes on rotation automatically
	self.selectedViewController.view.autoresizingMask = self.containerView.autoresizingMask;
    
	// add as child VC
	[self addChildViewController:self.selectedViewController];
    
	// add it to container view, calls willMoveToParentViewController for us
	[self.containerView addSubview:self.selectedViewController.view];
    
	// notify it that move is done
	[self.selectedViewController didMoveToParentViewController:self];
}

- (void)viewDidUnload {
    [self setContainerView:nil];
    [super viewDidUnload];
}
@end

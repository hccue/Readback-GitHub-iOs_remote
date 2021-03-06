//
//  ReadbackViewController.m
//  Readback
//
//  Created by Santiago Borja on 1/6/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackViewController.h"
#import "ReadbackSalesManager.h"
#import "KeyInterpreter.h"
#import "KeypadGenerator.h"
#import "ReadbackTableViewController.h"
#import "CuesoftHelper.h"
#import "PDFHelper.h"

//Global property defined for horizontal tracking of items
int global_clearanceXPosition;

@interface ReadbackViewController () <ReadbackTableViewControllerDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *clearanceLog;//TODO DELETE

@property (weak, nonatomic) IBOutlet UIView *clearanceView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ReadbackTableViewController *tableViewController;

@property (weak, nonatomic) IBOutlet UILabel *labelZuluTime;
@property (strong, nonatomic) NSTimer *clockTimer;
@property (strong, nonatomic) NSTimer *helpTimer;

@property (nonatomic, strong) NSArray *subViewControllers;
@property (nonatomic, strong) UIViewController *selectedViewController;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *activeKeypadLabel;

@property (nonatomic, strong) NSMutableArray *logItems; //Array of UIView

@property (weak, nonatomic) IBOutlet UIButton *helpButton;

@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@property (weak, nonatomic) IBOutlet UITextField *labelFlightNumber;

@end


@implementation ReadbackViewController

@synthesize clearanceLog = _clearanceLog;
@synthesize clearanceView = _clearanceView;
@synthesize tableView = _logTableView;
@synthesize tableViewController = _tableViewController;
@synthesize labelZuluTime = _labelZuluTime;
@synthesize clockTimer = _clockTimer;
@synthesize helpTimer = _helpTimer;
@synthesize subViewControllers = _subViewControllers;
@synthesize selectedViewController = _selectedViewController;
@synthesize containerView = _containerView;
@synthesize pageControl = _pageControl;
@synthesize activeKeypadLabel = _activeKeypadLabel;
@synthesize logItems = _logItems;
@synthesize documentInteractionController = _documentInteractionController;
@synthesize labelFlightNumber = _labelFlightNumber;


-(UITableViewController *)tableViewController
{
    if (!_tableViewController) {
        _tableViewController = [[ReadbackTableViewController alloc] initWithStyle:UITableViewStylePlain];
        _tableViewController.dataSource = self;
    }
    return  _tableViewController;
}

-(NSMutableArray *)logItems
{
    if (!_logItems) _logItems = [NSMutableArray array];
    return  _logItems;
}



#pragma mark Buttons

- (IBAction)clearLog:(UIButton *)sender {
    self.logItems = [NSMutableArray array];
    [self.tableView reloadData];
}
- (IBAction)clearScratchpad:(UIButton *)sender {
    [self.clearanceView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    global_clearanceXPosition = 0;
}
- (IBAction)clearanceTapped:(UITapGestureRecognizer *)sender {
    if ([self.clearanceView.subviews count] > 0) {
        [self moveClearanceToLog];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)buttonPressed:(UIButton *)sender {
    UIView *lastView = (UIView *)[self.clearanceView.subviews lastObject];
    
    switch (sender.tag) {
        case NO_TAG://All text buttons
            [self addTextToClearance:sender.titleLabel.text];
            break;
            
        case TEXT_TAG://All text buttons
            [self addTextToClearance:[NSString stringWithFormat:TEXT_TAG_FORMAT, sender.titleLabel.text]];
            break;
        case SPACE:
            [self addTextToClearance:TEXT_SPACE];
            break;
        case DELETE:
            global_clearanceXPosition = MAX(0,(global_clearanceXPosition - lastView.frame.size.width - CLEARANCE_GAP));
            [lastView removeFromSuperview];
            break;
            
        default:
            [self addImageToClearance:(int)sender.tag];
            break;
    }
}




#pragma mark Print PDF

- (IBAction)printPdf:(UIButton *)sender {
    NSURL *urlToDoc = [PDFHelper printPDFForFlight:self.labelFlightNumber.text withItems:self.logItems];
   
    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:urlToDoc];
    [self.documentInteractionController setDelegate:self];
    [self.documentInteractionController presentPreviewAnimated:YES];
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}




#pragma mark TableViewController dataSource

-(NSInteger) numberOfLogItems
{
    return [self.logItems count];
}

-(UIView *) logViewAtIndex:(NSInteger)row
{
    return [self.logItems objectAtIndex:row];
}

#pragma mark UIView Lifecycle implementation

-(void)viewDidLoad
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.containerView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.containerView addGestureRecognizer:swipeRight];
    
    self.tableView.dataSource = self.tableViewController;
    self.tableView.delegate = self.tableViewController;
    
    self.clearanceLog = [NSMutableArray array];
    self.labelFlightNumber.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //DISABLED, OUTDATED SCREEN
    //[self showWhatIsNew];
    
    //Always check for updated list of purchases
    [self loadPurchasedKeypads];
    
    [self startClock];
    [self launchHelpButtonAnimation];
    [self loadChildViewController];
    
    //Effect of bottom aligned cells
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopClock];
    [self stopHelpButtonAnimation];
    [self setClearanceView:nil];
    [self setLabelZuluTime:nil];
    [self setPageControl:nil];
    [self setActiveKeypadLabel:nil];
    [self setTableView:nil];
    [self setHelpButton:nil];
}


#pragma mark Clearance Handling

-(void)addImageToClearance:(int)imageTag
{
    NSString *imageName = [KeyInterpreter getSymbolForTag:imageTag isDaySymbol:false];
    //Get the image, create it's view and scale it
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = (UIImageView *)[ReadbackHelper reduceView:[[UIImageView alloc] initWithImage:image] toScale:IMAGE_SCALE_FACTOR];
    imageView.tag = imageTag;
    
    [self positionItem:imageView];
}

-(void)addTextToClearance:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont fontWithName:CLEARANCE_FONT_FAMILY size:CLEARANCE_FONT_SIZE];
    label.backgroundColor = COLOR_BACKGROUND_TEXT_COLOR;
    label.textColor = COLOR_TEXT;
    [label sizeToFit];
    
    [self positionItem:label];
}

-(void)positionItem:(UIView *)view
{
    //First item, move to the right
    if (!global_clearanceXPosition) global_clearanceXPosition = view.frame.size.width/2;
    
    CGFloat x = global_clearanceXPosition;
    CGFloat y = self.clearanceView.bounds.size.height/2;
    
    //Center frame vertically
    view.frame = CGRectMake(x, y - view.frame.size.height/2, view.frame.size.width, view.frame.size.height);
    
    [self.clearanceView addSubview:view];
    
    //Update clearance width for next item
    global_clearanceXPosition += view.frame.size.width + CLEARANCE_GAP;
}

-(void)moveClearanceToLog
{
    //Create the log row frame
    CGRect frame = CGRectMake(0, 0, self.clearanceView.frame.size.width, LOG_ROW_HEIGHT);
    
    //Create new view for log
    UIView *logRow = [[UIView alloc] initWithFrame:frame];
    
    //Move items to the new view
    NSMutableArray *clearanceItems = [self.clearanceView.subviews mutableCopy];

    //Add Zulu time as first item in log
    UILabel *zuluTime = [[UILabel alloc] init];
    zuluTime.text = [NSString stringWithFormat:LOG_TIME_FORMAT, [CuesoftHelper getCurrentZuluTimeWithFormat:ZULU_TIME_FORMAT_SHORT]];
    zuluTime.font = [UIFont systemFontOfSize:CLEARANCE_FONT_SIZE];
    zuluTime.backgroundColor = COLOR_BACKGROUND_TEXT_COLOR;
    zuluTime.textColor = COLOR_LOG_TIME;
    [zuluTime sizeToFit];
    
    [clearanceItems insertObject:zuluTime atIndex:0];
    int xCoord = 0;
    for (int items = 0; items < [clearanceItems count]; items++) {//Unable fast ennumeration
        UIView *item = [clearanceItems objectAtIndex:items];
        if (!xCoord) xCoord = LOG_CLEARANCE_GAP;
        
        //Reduce item size for smaller display as log
        item = [ReadbackHelper reduceView:item toScale:IMAGE_SCALE_FACTOR];
        
        //Adjust vertical position within log row
        item.center = CGPointMake(xCoord + item.frame.size.width / 2, LOG_ROW_HEIGHT / 2);
        
        //Add to log row and update x coordinate for next item
        xCoord += item.frame.size.width + LOG_CLEARANCE_GAP; //Updating clearance width for next item
        
        [logRow addSubview:item];
    }
    
    [self addViewToLog:logRow];
    global_clearanceXPosition = 0;
}

-(void)addViewToLog:(UIView *)newRow
{
    [self.logItems insertObject:newRow atIndex:0];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}


#pragma mark Clock implementation

-(void)startClock
{
    self.clockTimer = [NSTimer scheduledTimerWithTimeInterval:CLOCK_TIMER_DURATION
                                                       target:self
                                                     selector:@selector(updateClockDisplay)
                                                     userInfo:nil
                                                      repeats:YES];
}

-(void)updateClockDisplay
{
    self.labelZuluTime.text = [CuesoftHelper getCurrentZuluTimeWithFormat:ZULU_TIME_FORMAT_LONG];
}

-(void)stopClock
{
    [self.clockTimer invalidate];
}



#pragma mark UIPageControl 

- (IBAction)changePage:(UIPageControl *)pageControl {
    UIViewController *newSubViewController = [self.subViewControllers objectAtIndex:pageControl.currentPage];
    
    [self transitionFromViewController:self.selectedViewController
                      toViewController:newSubViewController
                         withAnimation:UIViewAnimationOptionTransitionFlipFromBottom];

}



#pragma mark What is New

-(void)showWhatIsNew
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:USERKEY_FIRST_START])
    {
        [defaults setValue:@"YES" forKey:USERKEY_FIRST_START];
        
        UIImage *image = [UIImage imageNamed:WHAT_IS_NEW_SCREEN_NAME];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(dismissWhatIsNewView:)];
        [imageView setUserInteractionEnabled:YES];
        [imageView addGestureRecognizer:tap];
        [self.view addSubview:imageView];
    }
}

-(void)dismissWhatIsNewView:(UITapGestureRecognizer *)tap
{
    [tap.view removeFromSuperview];
}



-(void)loadPurchasedKeypads
{
    NSArray *purchasedKeypadsIdentifiers = [ReadbackSalesManager getPurchasedIdentifiersFromMemory];
    
    //Get each keypad's ViewController
    NSMutableArray *keypadsViewControllers = [[NSMutableArray alloc] initWithCapacity:[purchasedKeypadsIdentifiers count]];

    for (NSString *keypadIdentifier in purchasedKeypadsIdentifiers) {

        
        ReadbackKeypad *keypad = [KeypadGenerator generateKeypadWithIdentifier:
                                  keypadIdentifier];
        KeypadViewController *correspondingVC = [[KeypadViewController alloc] initWithNibName:keypad.name bundle:nil];
        correspondingVC.title = keypad.title;
        correspondingVC.keypad = keypad;
        [keypadsViewControllers addObject: correspondingVC];
        
        ReadbackKeypad *current = [(KeypadViewController *)self.selectedViewController keypad];
        
        //Fix: this generation renders different VCs for same previous Keypads.
        //We load new set of VCs so we need to update curret VC
        if ([current.identifier isEqualToString:keypad.identifier]) {
            self.selectedViewController = correspondingVC;
        }
        
    }
    
    [self setSubViewControllers:keypadsViewControllers];
    self.pageControl.numberOfPages = [keypadsViewControllers count];
    
    [self setSelectedKeypad:self.selectedViewController];
}

- (void)setSubViewControllers:(NSArray *)subViewControllers
{
	_subViewControllers = [subViewControllers copy];
    
    if (!self.selectedViewController) {//IF added to FIX: Keypad not loading when tapped from store (purchased) list
        self.selectedViewController = [subViewControllers objectAtIndex:0];
    }
	
}

-(void)loadChildViewController
{
    if (self.selectedViewController.parentViewController == self)
	{
		// nowthing to do, selected vc is the visible one
		return;
	}
    
	// adjust the frame to fit in the container view
    NSLog(@"%f", self.containerView.bounds.size.width);
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



#pragma mark UIGestureRecognizer Swipe

- (void)swipe:(UISwipeGestureRecognizer *)gesture
{
	if (gesture.state == UIGestureRecognizerStateRecognized)
	{
		NSInteger index = [self.subViewControllers indexOfObject:self.selectedViewController];
		
        UIViewAnimationOptions option;
        if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
            index = MIN(index+1, [self.subViewControllers count]-1);
            option = UIViewAnimationOptionTransitionFlipFromRight;
        }else{
            index = MAX(index-1, 0);
            option = UIViewAnimationOptionTransitionFlipFromLeft;
        }
        
		UIViewController *newSubViewController = [self.subViewControllers objectAtIndex:index];
		[self transitionFromViewController:self.selectedViewController
                          toViewController:newSubViewController
                             withAnimation:option];
	}
}

- (void)transitionFromViewController:(UIViewController *)fromViewController
                    toViewController:(UIViewController *)toViewController
                       withAnimation:(UIViewAnimationOptions)animation
{
    // cannot transition to same VC
	if (fromViewController == toViewController) return;
    
	// animation setup
	toViewController.view.frame = self.containerView.bounds;
	toViewController.view.autoresizingMask = self.containerView.autoresizingMask;
    
	// notify
	[fromViewController willMoveToParentViewController:nil];//No parent
    
	[self addChildViewController:toViewController];
    
	// transition
	[self transitionFromViewController:fromViewController
					  toViewController:toViewController
							  duration:KEYPAD_SWAP_ANIMATION_DURATION
                               options:animation
							animations:^{
							}
							completion:^(BOOL finished) {
								[toViewController didMoveToParentViewController:self];
								[fromViewController removeFromParentViewController];
							}];
    
    [self setSelectedKeypad:toViewController];
}

-(void)setSelectedKeypad:(UIViewController *)viewController
{
    self.selectedViewController = viewController;
    self.activeKeypadLabel.text = viewController.title;
    self.pageControl.currentPage = [self.subViewControllers indexOfObject:viewController];
}

-(void)loadKeypadWithIdentifier:(NSString *)identifier;
{
    for (KeypadViewController *keypadVC in self.subViewControllers) {
        ReadbackKeypad *keypad = keypadVC.keypad;
        if ([keypad.identifier isEqualToString:identifier]) {
            [self transitionFromViewController:self.selectedViewController toViewController:keypadVC withAnimation:UIViewAnimationOptionTransitionCurlDown];
        }
    }
    
}


#pragma mark Help Button

- (IBAction)helpTapped:(UIButton *)sender {
    
    UIImage *image;
    if (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        image = [UIImage imageNamed:HELP_IMAGE_NAME_LANDSCAPE];
    }else{
        image = [UIImage imageNamed:HELP_IMAGE_NAME_PORTRAIT];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissHelpView:)];
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:tap];
    [self.view addSubview:imageView];
}

-(void)dismissHelpView:(UITapGestureRecognizer *)tap
{
    [tap.view removeFromSuperview];
    [self stopHelpButtonAnimation];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USERKEY_HELP_VIEWED];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)stopHelpButtonAnimation
{
    [self.helpTimer invalidate];
}

-(void)launchHelpButtonAnimation
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:USERKEY_HELP_VIEWED]) {
        self.helpTimer = [NSTimer scheduledTimerWithTimeInterval:HELP_BUTTON_TIMER_DURATION
                                                           target:self
                                                         selector:@selector(animateHelpButton)
                                                         userInfo:nil
                                                          repeats:YES];
    }
}

-(void)animateHelpButton
{
    [[self class] animateHighlightView:self.helpButton];
    
}

+(void)animateHighlightView:(UIView *)view
{
    UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:VIEW_ANIMATION_DURATION delay:0 options:options animations:^{
        view.transform = CGAffineTransformMakeScale(VIEW_ANIMATION_SCALE,VIEW_ANIMATION_SCALE);
    } completion:^(BOOL finished) {
        if (finished) {
            UIViewAnimationOptions options = UIViewAnimationOptionCurveLinear;
            [UIView animateWithDuration:VIEW_ANIMATION_DURATION * 10 delay:0 options:options animations:^{
                view.transform = CGAffineTransformMakeScale(1.0,1.0);
            } completion:^(BOOL finished) {}];
        };
    }];
}

@end

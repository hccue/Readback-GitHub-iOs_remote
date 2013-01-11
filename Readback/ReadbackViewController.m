//
//  ReadbackViewController.m
//  Readback
//
//  Created by Santiago Borja on 1/6/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackViewController.h"

//Global property defined for horizontal tracking of items
int global_clearanceXPosition;

@interface ReadbackViewController ()
- (IBAction)buttonPushed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *clearanceView;
@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet UILabel *labelZuluTime;
@property (strong, nonatomic) NSTimer *clockTimer;
@end


@implementation ReadbackViewController
@synthesize clearanceView = _clearanceView;
@synthesize historyView = _historyView;
@synthesize labelZuluTime = _labelZuluTime;
@synthesize clockTimer = _clockTimer;

- (IBAction)done:(UIButton *)sender {
    if ([self.clearanceView.subviews count] > 0) {
        [self moveClearanceToHistory];
    }
}

- (IBAction)buttonPushed:(UIButton *)sender {
    //Cannot introduce new scope inside switch statement
    UIView *lastView = (UIView *)[self.clearanceView.subviews lastObject];

    switch (sender.tag) {
        case 0://All text buttons
            [self addTextToClearance:sender.titleLabel.text];
            break;
        case SPACE:
            [self addTextToClearance:TEXT_SPACE];
            break;
            
        case CLEAR:
            [self.clearanceView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            global_clearanceXPosition = 0;
            break;
        case DELETE:
            global_clearanceXPosition = MAX(0,(global_clearanceXPosition - lastView.frame.size.width - CLEARANCE_GAP));
            [lastView removeFromSuperview];
            break;
            
        case LEFT:
            [self addImageToClearance:@"left-button.png"];
            break;
        case RIGHT:
            [self addImageToClearance:@"right.png"];
            break;
        case CLIMB:
            [self addImageToClearance:@"climb.png"];
            break;
        case DESCEND:
            [self addImageToClearance:@"descend.png"];
            break;
        case CROSS:
            [self addImageToClearance:@"cross.png"];
            break;
            
        case NDB://deprecated
            [self addImageToClearance:@"ndb.png"];
            break;
        case VOR:
            [self addImageToClearance:@"vor.png"];
            break;
        case ILS:
            [self addImageToClearance:@"ils.png"];
            break;
        case HOLDSHORT:
            [self addImageToClearance:@"hold-short.png"];
            break;
        case HOLDCAT:
            [self addImageToClearance:@"cat.png"];
            break;
            
        case CALL:
            [self addImageToClearance:@"call.png"];
            break;
        default:
            break;
    }
}

-(void)addImageToClearance:(NSString *)imageName
{
    //Get the image, create it's view and scale it
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = (UIImageView *)[self reduceView:[[UIImageView alloc] initWithImage:image] toScale:IMAGE_SCALE_FACTOR];
    
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

-(void)moveClearanceToHistory
{
    //Create the history row's frame
    CGRect frame = CGRectMake(0, self.historyView.frame.size.height, self.clearanceView.frame.size.width, HISTORY_ROW_HEIGHT);
    
    //Create new view for history
    UIView *historyRow = [[UIView alloc] initWithFrame:frame];
    
    //Move items to the new view
    NSMutableArray *clearanceItems = [self.clearanceView.subviews mutableCopy];

    //Add Zulu time as first item in history
    UILabel *zuluTime = [[UILabel alloc] init];
    zuluTime.text = [NSString stringWithFormat:HISTORY_TIME_FORMAT, [self getCurrentZuluTimeWithFormat:ZULU_TIME_FORMAT_SHORT]];
    zuluTime.font = [UIFont systemFontOfSize:CLEARANCE_FONT_SIZE];
    zuluTime.backgroundColor = COLOR_BACKGROUND_TEXT_COLOR;
    zuluTime.textColor = COLOR_HISTORY_TIME;
    [zuluTime sizeToFit];
    
    [clearanceItems insertObject:zuluTime atIndex:0];
    int xCoord = 0;
    for (int items = 0; items < [clearanceItems count]; items++) {//Unable fast ennumeration
        UIView *item = [clearanceItems objectAtIndex:items];
        if (!xCoord) xCoord = HISTORY_CLEARANCE_GAP;
        
        //Reduce item size for smaller display as history
        item = [self reduceView:item toScale:IMAGE_SCALE_FACTOR];
        
        //Adjust vertical position within history row
        item.center = CGPointMake(xCoord + item.frame.size.width / 2, HISTORY_ROW_HEIGHT / 2);
        
        //Add to history row and update x coordinate for next item
        [historyRow addSubview:item];
        xCoord += item.frame.size.width + HISTORY_CLEARANCE_GAP; //Updating clearance width for next item
    }
    
    [self addHistoryRow:historyRow];
    global_clearanceXPosition = 0;
}

-(void)addHistoryRow:(UIView *)newRow
{
    //Add view to superview and move other views up like a chat history
    [self.historyView addSubview:newRow];
    for (UIView *row in self.historyView.subviews) {
        int newYCoord = row.center.y - HISTORY_ROW_HEIGHT;
        //Move Up Animated
        [UIView animateWithDuration:HISTORY_ANIMATION_DURATION delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            row.center = CGPointMake(row.center.x, newYCoord);
        } completion:^(BOOL finished) {
            if (newYCoord < 0) {//View is out of... view
                [row removeFromSuperview];
            }
        }];
        
    }
    
}

-(UIView *)reduceView:(UIView *)view toScale:(float)scale
{
    CGRect frame = view.frame;
    frame.size = CGSizeMake(frame.size.width * scale, frame.size.height * scale);
    view.frame = frame;
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label =(UILabel *)view;
        [label setFont:[UIFont fontWithName:HISTORY_CLEARANCE_FONT_FAMILY size:HISTORY_CLEARANCE_FONT_SIZE]];
        [label sizeToFit];
    }
    return view;
}

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
    self.labelZuluTime.text = [self getCurrentZuluTimeWithFormat:ZULU_TIME_FORMAT_LONG];
}

-(void)stopClock
{
    [self.clockTimer invalidate];
}


#pragma mark UIView Lifecycle implementation

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startClock];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopClock];
}

- (void)viewDidUnload {
    [self setClearanceView:nil];
    [self setHistoryView:nil];
    [self setLabelZuluTime:nil];
    [super viewDidUnload];
}

#pragma mark Utilities

-(NSString *)getCurrentZuluTimeWithFormat:(NSString *)format
{
    NSDate *localDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:ZULU_TIMEZONE];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:localDate];
}

@end
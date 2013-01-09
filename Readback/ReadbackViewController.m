//
//  ReadbackViewController.m
//  Readback
//
//  Created by Santiago Borja on 1/6/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import "ReadbackViewController.h"

@interface ReadbackViewController ()

- (IBAction)buttonPushed:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *clearanceView;
@property (nonatomic, strong) NSNumber *clearanceWidth;

@end

@implementation ReadbackViewController

-(void)viewDidLoad
{
    self.clearanceWidth = [NSNumber numberWithInt:0];
}
- (IBAction)done:(UIButton *)sender {

}

- (IBAction)buttonPushed:(UIButton *)sender {
    //Cannot introduce new scope inside switch statement
    UIView *lastView = (UIView *)[self.clearanceView.subviews lastObject];

    switch (sender.tag) {
        case 0://All text buttons
            [self addLabel:sender.titleLabel.text];
            break;
            
        case CLEAR:
            [self.clearanceView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            self.clearanceWidth = [NSNumber numberWithInt:0];
            break;
            
        case DELETE:
            self.clearanceWidth = [NSNumber numberWithInt:MAX(0,([self.clearanceWidth intValue] - lastView.frame.size.width - CLEARANCE_GAP))];
            [lastView removeFromSuperview];
            break;
            
        case LEFT:
            [self addImage:@"left-button.png"];
            break;
        case RIGHT:
            [self addImage:@"right.png"];
            break;
        case CLIMB:
            [self addImage:@"climb.png"];
            break;
        case DESCEND:
            [self addImage:@"descend.png"];
            break;
        case CROSS:
            [self addImage:@"cross.png"];
            break;
            
        case NDB:
            [self addImage:@"ndb.png"];
            break;
        case HOLDSHORT:
            [self addImage:@"hold-short.png"];
            break;
        case HOLDCAT:
            [self addImage:@"cat.png"];
            break;
        default:
            break;
    }
}

-(void)addImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    [self positionView:imageView];
}

-(void)addLabel:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:48.0];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    
    [self positionView:label];
}

-(void)positionView:(UIView *)view
{
    //First item, move to the right
    if (![self.clearanceWidth intValue]) self.clearanceWidth = [NSNumber numberWithInt:(view.frame.size.width/2 + CLEARANCE_GAP)];
    
    CGFloat x = [self.clearanceWidth intValue];
    CGFloat y = self.clearanceView.bounds.size.height/2;
    
    //Get current frame and position vertically centered
    CGRect frame = CGRectMake(x, y - view.frame.size.height/2, view.frame.size.width, view.frame.size.height);
    view.frame = frame;
    
    
    [self.clearanceView addSubview:view];
    
    //Update clearance width for next item
    self.clearanceWidth = [NSNumber numberWithInt:(view.frame.size.width + [self.clearanceWidth intValue] + CLEARANCE_GAP)];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        return YES;
    }else{
        return NO;
    }
}

- (void)viewDidUnload {
    [self setClearanceView:nil];
    [super viewDidUnload];
}


@end

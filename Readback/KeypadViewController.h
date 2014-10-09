//
//  KeypadViewController.h
//  Readback
//
//  Created by Santiago Borja on 2/16/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadbackKeypad.h"

@protocol KeypadDelegate <NSObject>
-(void)buttonPressed:(UIButton *)button;
@end

@interface KeypadViewController : UIViewController
@property (nonatomic, strong) id <KeypadDelegate> delegate;
@property (nonatomic, strong) ReadbackKeypad *keypad; //Kepyad associated with VC
@end


/* NEW KEYPAD

1. FILE > NEW > FILE > COCOA TOUCH CLASS
2. Name: XXKeypadVC, Subclass: View Controller, also create xib
3. Copy view inside canvas from other keypad into current one
4. at .xib ctrl-drag file's owner to view, select view.
5. Delete empty white view
4. delete .m & .h files
 
*/

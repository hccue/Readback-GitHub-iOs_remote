//
//  ReadbackHelpViewController.h
//  Readback
//
//  Created by Santiago Borja on 1/11/13.
//  Copyright (c) 2013 Santiago Borja. All rights reserved.
//

#import <UIKit/UIKit.h>

//latest commit

#define PATTERN_VERSION                 @"Version %@"

#define APP_ID_APP_SPEED                        @"581569231"
#define APP_ID_CREW_CURRENCY                    @"1573431275"
#define APP_ID_ER_OPS                           @"619262446"

#define STRING_BUNDLE_VERSION           @"CFBundleShortVersionString"

#define SUGGESTION_EMAIL_SUBJECT        @"Readback App Suggestion!"
#define SUGGESTION_EMAIL_TO             @"support@cuesoft.org"
#define SUGGESTION_EMAIL_BODY           @"I have a suggestion about the App,\n\n"

#define ALERT_NOEMAIL_TITLE             @"Ooops"
#define ALERT_NOEMAIL_MESSAGE           @"No fue posible enviar un correo, existe algún problema con tu configuración. Escríbenos desde tu computador a %@"
#define ALERT_NOEMAIL_BUTTON            @"Ok"

@interface ReadbackHelpViewController : UIViewController

@end

//
//  VacationHelper.h
//  Photomania
//
//  Created by Santiago Borja on 10/30/12.
//  Copyright (c) 2012 Santiago Borja. All rights reserved.
//

#import <Foundation/Foundation.h>

//Facebook promotion
#define FACEBOOK_URL_APP @"fb://profile/%@"
#define FACEBOOK_URL_SAFARI @"http://www.facebook.com/%@"

//Rate App alert
#define URL_CONNECTION_TEST @"http://www.google.com"
#define MIN_USAGE_TIMES 5
#define ALERT_RATE_TITLE @"Please!"
#define ALERT_RATE_MESSAGE @"Please take a moment to rate the App"
#define ALERT_CANCEL_BUTTON @"No"
#define ALERT_RATE_BUTTON @"Rate App"

//User Defaults
#define KEY_DEFAULTS_PROPERTIES @"userProperties"
#define KEY_APP_USAGE @"appUsage"

//Utilities
#define UTC_STRING @"UTC"

//Core data completion block
typedef void (^completion_block_t)(UIManagedDocument *dbDocument);

@interface CuesoftHelper : NSObject

//Core data:
+ (UIManagedDocument *)sharedManagedDocumentForDatabase;
+ (void)openDatabaseDocumentUsingBlock:(completion_block_t)completionBlock;

//App Promotion:
+ (void)openFacebookID:(NSString *)fbId;//Id of facebook page, link to button.
+ (void)popRateMeAlert;//Invoke to pop alert after 5 uses, must be online.
+ (void)rateMeAlertAnswer:(int)buttonIndex
                  withUrl:(NSString *)url
                    forID:(NSString *)appID;//Implement alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex


//User Defaults
+(id)getUSerPropertyNamed:(NSString *)name;
+(void)setUserPropertyNamed:(NSString *)name withValue:(id)value;

//Utility
+ (BOOL) connectedToInternet;
+ (NSString *)getCurrentZuluTimeWithFormat:(NSString *)format;
@end

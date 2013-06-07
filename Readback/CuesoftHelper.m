//
//  VacationHelper.m
//  Photomania
//
//  Created by Santiago Borja on 10/30/12.
//  Copyright (c) 2012 Santiago Borja. All rights reserved.
//

#import "CuesoftHelper.h"
#define DB_DOCUMENTS_DIRECTORY @"vacation_files"
#import <CoreData/CoreData.h>

//First approach, a global variable:
static NSMutableDictionary *sharedDocuments;

@implementation CuesoftHelper

#pragma mark Core Data

+(UIManagedDocument *)sharedManagedDocumentForDatabase
{
    if(!sharedDocuments){
        sharedDocuments = [NSMutableDictionary dictionary];
        //Create Directory:
        [[NSFileManager defaultManager] createDirectoryAtPath:[[CuesoftHelper getDatabaseDocumentsFilesDirectory] path] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *documentName = @"ExpensesAppDocument";

    UIManagedDocument *document = [sharedDocuments objectForKey:documentName];
    if(!document){
        document = [[UIManagedDocument alloc] initWithFileURL:[[CuesoftHelper getDatabaseDocumentsFilesDirectory] URLByAppendingPathComponent:documentName]];
        [sharedDocuments setObject:document forKey:documentName];
    }
    
    return document;
}

//Calls sharedManagedDocumentForDatabase
+ (void)openDatabaseDocumentUsingBlock:(completion_block_t)completionBlock //[self setupFetchedResultsController:vacation];
{
    UIManagedDocument *sharedDocument = [CuesoftHelper sharedManagedDocumentForDatabase];

    if (![[NSFileManager defaultManager] fileExistsAtPath:[sharedDocument.fileURL path]]) {
        [sharedDocument saveToURL:sharedDocument.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            NSLog(@"core save");
            completionBlock(sharedDocument);
        }];
    } else if(sharedDocument.documentState == UIDocumentStateClosed){
        [sharedDocument openWithCompletionHandler:^(BOOL success) {
            NSLog(@"core open");
            completionBlock(sharedDocument);
        }];
    } else if(sharedDocument.documentState == UIDocumentStateNormal){
        NSLog(@"core normal");
        completionBlock(sharedDocument);
    }
}

+(NSURL *)getDatabaseDocumentsFilesDirectory
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsURL URLByAppendingPathComponent:DB_DOCUMENTS_DIRECTORY];
}



#pragma mark App Promotion

+ (void)openFacebookID:(NSString *)fbId{
    NSURL *urlApp = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@", fbId]];
    NSURL *urlSafari = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.facebook.com/%@", fbId]];
    if ([[UIApplication sharedApplication] canOpenURL:urlApp]){
        [[UIApplication sharedApplication] openURL:urlApp];
    }else{
        [[UIApplication sharedApplication] openURL:urlSafari];
    }
}


//Rate me Alert
+ (void)popRateMeAlert
{
    if ([CuesoftHelper triggerRateAlert] && [CuesoftHelper connectedToInternet]) {
        UIAlertView* message = [[UIAlertView alloc] initWithTitle:ALERT_RATE_TITLE
                                                          message:ALERT_RATE_MESSAGE
                                                         delegate:self
                                                cancelButtonTitle:ALERT_CANCEL_BUTTON
                                                otherButtonTitles: ALERT_RATE_BUTTON, nil];
        [message show];
    }
}

+ (BOOL) triggerRateAlert
{
    int appUsage = [[CuesoftHelper getUSerPropertyNamed:KEY_APP_USAGE] intValue];
    if (appUsage >= 0) {
        [CuesoftHelper setUserPropertyNamed:KEY_APP_USAGE withValue:[NSNumber numberWithInt:++appUsage]];
        //This will only happen once ever!
        if (appUsage >= MIN_USAGE_TIMES) {
            return YES;
        }
    }
    
    return NO;
}

+ (void)rateMeAlertAnswer:(int)buttonIndex
                  withUrl:(NSString *)url
                    forID:(NSString *)appID
{
    if (buttonIndex == 0){
        //Wait another X times to ask
        [CuesoftHelper setUserPropertyNamed:KEY_APP_USAGE withValue:[NSNumber numberWithInt:0]];
    }else if (buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:url, appID]]];
        //Negative value guarantees it won't happen again.
        [CuesoftHelper setUserPropertyNamed:KEY_APP_USAGE withValue:[NSNumber numberWithInt:-1]];
    }
}


//User Defaults
+ (id)getUSerPropertyNamed:(NSString *)name
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *appSettings = [[defaults objectForKey:KEY_DEFAULTS_PROPERTIES] mutableCopy];
    if(!appSettings) appSettings = [NSMutableDictionary dictionary];
    
    return [appSettings objectForKey:name];
}

#warning test this
+ (void)setUserPropertyNamed:(NSString *)name withValue:(id)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *appSettings = [[defaults objectForKey:KEY_DEFAULTS_PROPERTIES] mutableCopy];
    if(!appSettings) appSettings = [NSMutableDictionary dictionary];
    [appSettings setObject:value forKey:name];
    [defaults setObject:appSettings forKey:KEY_DEFAULTS_PROPERTIES];
    [defaults synchronize];
}



//Utilities
+ (BOOL) connectedToInternet
{
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:URL_CONNECTION_TEST] encoding:NSASCIIStringEncoding error:nil];
    return ( URLString != NULL ) ? YES : NO;
}

+ (NSString *)getCurrentZuluTimeWithFormat:(NSString *)format
{
    NSDate *localDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:UTC_STRING];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:localDate];
}
@end

//
//  ReadbackHelper.h
//  Readback
//
//  Created by Santiago Borja on 9/19/14.
//  Copyright (c) 2014 Santiago Borja. All rights reserved.
//

#import <Foundation/Foundation.h>

//PDF display
#define PDF_PAGE_WIDTH_PX 800
#define PDF_PAGE_HEIGHT_PX 600

#define PDF_CONTEXT_TITLE "Flight Log"
#define PDF_CONTEXT_CREATOR "Cuesoft Apps"

#define PDF_TITLE_FONT "Avenir Next"
#define PDF_TITLE_FONT_SIZE 18
#define PDF_TITLE_LEFT_GAP 20
#define PDF_TITLE_TOP_GAP 5

#define PDF_DEFAULT_TITLE @"Flight Log"
#define PDF_FORMAT_TITLE @"%@ Summary"
#define PDF_FORMAT_TITLE_PAGE @"Page %d"
#define PDF_TIME_FORMAT @"MMM dd,yyyy 'at' HH:mm'Z"

#define PDF_PAGE_DATE_GAP_RIGHT 190

#define PDF_SEPARATOR_TOP_GAP 40
#define PDF_SEPARATOR_HEIGHT 1

#define PDF_ROWS_LEFT_GAP 20
#define PDF_ROWS_TOP_GAP 20//varies with smaller pdf_page_height, then not???? clean: acts as space from the last component: separator
#define PDF_ROWS_MID_GAP 30 //*
#define PDF_MAX_ROWS_PER_PAGE 17

#define PDF_NAME_DEFAULT @"flight"
#define PDF_NAME_FORMAT_DATE @"yy_MM_dd_HHmm'Z"
#define PDF_NAME_FORMAT @"flightLog_%@_%@.pdf"


#define PDF_PAGE_PADDING_PAGE_NUM 300
#define PDF_PAGE_PADDING_DATE 200
#define PDF_PAGE_PADDING_RETURN_ROWS -530



@interface PDFHelper : NSObject

+ (NSURL *) printPDFForFlight:(NSString *)flightNumber withItems:(NSArray *)logItems;

@end

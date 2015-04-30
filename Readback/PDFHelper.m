//
//  ReadbackHelper.m
//  Readback
//
//  Created by Santiago Borja on 9/19/14.
//  Copyright (c) 2014 Santiago Borja. All rights reserved.
//

#import "PDFHelper.h"
#import "CuesoftHelper.h"
#import "KeyInterpreter.h"
#import "ReadbackHelper.h"

@implementation PDFHelper


+ (NSURL *) printPDFForFlight:(NSString *)flightNumber withItems:(NSArray *)logItems
{
    // Setup PDF
    CGContextRef pdfContext;
    CFStringRef path;
    CFURLRef url;
    CFMutableDictionaryRef myDictionary = NULL;
    
    NSString * fileName = [PDFHelper getPdfNameForFlight:flightNumber];
    
    //Configure PDF
    NSString * newFilePath = [[CuesoftHelper getDocumentsURL].path stringByAppendingPathComponent:fileName];
    CGRect pageRect = CGRectMake(0, 0, PDF_PAGE_WIDTH_PX, PDF_PAGE_HEIGHT_PX);
    path = CFStringCreateWithCString (NULL, [newFilePath UTF8String], kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath (NULL, path, kCFURLPOSIXPathStyle, 0);
    CFRelease (path);
    myDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(myDictionary, kCGPDFContextTitle, CFSTR(PDF_CONTEXT_TITLE));
    CFDictionarySetValue(myDictionary, kCGPDFContextCreator, CFSTR(PDF_CONTEXT_CREATOR));
    pdfContext = CGPDFContextCreateWithURL (url, &pageRect, myDictionary);
    CFRelease(myDictionary);
    CFRelease(url);
    
    //Write all the logs
    int rows = 1;
    int page = 1;
    [PDFHelper pdfSetupPage:page InContext:pdfContext forFlight:flightNumber];
    CGContextTranslateCTM(pdfContext, PDF_PAGE_PADDING_RETURN_ROWS, 0);
    
    for (UIView * view in logItems.reverseObjectEnumerator) {
        
        CGContextTranslateCTM(pdfContext, 0, PDF_ROWS_MID_GAP);
        
        //UIView *nightView = [ReadbackHelper changeToNightView:view];
        //[nightView.layer renderInContext:pdfContext];
        [view.layer renderInContext:pdfContext];
        
        //Finish page and configure new one
        if (rows == PDF_MAX_ROWS_PER_PAGE) {
            page ++;
            CGContextEndPage(pdfContext);
            [PDFHelper pdfSetupPage:page InContext:pdfContext forFlight:flightNumber];
            CGContextTranslateCTM(pdfContext, PDF_PAGE_PADDING_RETURN_ROWS, 0);
            rows = 0;
        }
        rows++;
    }
    CGContextEndPage (pdfContext);
    
    //End Document
    CGContextRelease (pdfContext);
    
    //Present PDF
    NSURL *urlToDoc = [[CuesoftHelper getDocumentsURL] URLByAppendingPathComponent:fileName];
    return urlToDoc;
}

+ (void)pdfSetupPage:(int)page InContext:(CGContextRef)pdfContext forFlight:(NSString *)flightNumber
{
    CGRect pageRect = CGRectMake(0, 0, PDF_PAGE_WIDTH_PX, PDF_PAGE_HEIGHT_PX);
    CGContextBeginPage (pdfContext, &pageRect);
    
    //Background Color
    CGContextSetRGBFillColor (pdfContext, 0, 0, 0, 1);
    CGContextFillRect (pdfContext, CGRectMake (0, 0, PDF_PAGE_WIDTH_PX, PDF_PAGE_HEIGHT_PX));
    
    
    //turn PDF upsidedown - required for view drawing
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformMakeTranslation(0, PDF_PAGE_HEIGHT_PX - PDF_ROWS_TOP_GAP);
    transform = CGAffineTransformScale(transform, 1.0, -1.0);
    CGContextConcatCTM(pdfContext, transform);
    
    CGContextSetTextMatrix(pdfContext, CGAffineTransformMake(1.0,0.0, 0.0, -1.0, 0.0, 0.0));
    
    //Separation line
    CGContextSetRGBFillColor (pdfContext, 1, 1, 1, 1);
    CGContextFillRect (pdfContext, CGRectMake (0, PDF_SEPARATOR_TOP_GAP, PDF_PAGE_WIDTH_PX, PDF_SEPARATOR_HEIGHT));
    
    //Write Title
    NSString *title = PDF_DEFAULT_TITLE;
    if (![flightNumber isEqualToString:@""]) title = flightNumber;
    title = [NSString stringWithFormat:PDF_FORMAT_TITLE, title];
    
    UILabel *titleLabel = [ReadbackHelper getLabelForString:title];
    CGContextTranslateCTM(pdfContext, PDF_TITLE_LEFT_GAP, PDF_TITLE_TOP_GAP);
    [titleLabel.layer renderInContext:pdfContext];

    
    //Write Page
    NSString *pageNum = [NSString stringWithFormat:PDF_FORMAT_TITLE_PAGE, page];
    UILabel *pageLabel = [ReadbackHelper getLabelForString:pageNum];
    CGContextTranslateCTM(pdfContext, PDF_PAGE_PADDING_PAGE_NUM, 0);
    [pageLabel.layer renderInContext:pdfContext];
    
    
    //Write Date
    NSString *date = [CuesoftHelper getCurrentZuluTimeWithFormat:PDF_TIME_FORMAT];
    UILabel *dateLabel = [ReadbackHelper getLabelForString:date];
    CGContextTranslateCTM(pdfContext, PDF_PAGE_PADDING_DATE, 0);
    [dateLabel.layer renderInContext:pdfContext];
    
    //Space to begin log writing:
    CGContextTranslateCTM(pdfContext, PDF_ROWS_LEFT_GAP, PDF_ROWS_TOP_GAP);
}

+ (NSString *)getPdfNameForFlight:(NSString *)flightNumberText
{
    NSString *flightNumber = ![flightNumberText isEqualToString:@""] ? flightNumberText : PDF_NAME_DEFAULT;
    NSString *date = [CuesoftHelper getCurrentZuluTimeWithFormat:PDF_NAME_FORMAT_DATE];
    return [NSString stringWithFormat:PDF_NAME_FORMAT, flightNumber, date];
}


@end

//
//  PSCCustomDrawingViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSCCustomDrawingViewController.h"

@implementation PSCCustomDrawingViewController

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.delegate = self;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewController:(PSPDFViewController *)pdfController didRenderPage:(NSUInteger)page inContext:(CGContextRef)context withSize:(CGSize)fullSize clippedToRect:(CGRect)clipRect withAnnotations:(NSArray *)annotations options:(NSDictionary *)options {

    // don't render text for cached pages
    if (options[kPSPDFCachedRenderRequest]) {
        return;
    }

    // setup graphics context for current PDF page
    PSPDFPageInfo *pageInfo = [pdfController.document pageInfoForPage:page];
    [PSPDFPageRenderer setupGraphicsContext:context inRectangle:clipRect pageInfo:pageInfo];

    // flip drawing
    CGContextTranslateCTM(context, 0, pageInfo.rotatedPageRect.size.height);
    CGContextScaleCTM(context, 1, -1);

    // set up drawing
    NSString *fontName = @"Helvetica-Bold";
    CGFloat fontSize = 24.f;
    NSString *overlayText = @"Example overlay";
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSelectFont(context, [fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
    CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
    CGContextSetTextMatrix(context, xform);

    // calculate the font box to center it
    CGSize boundingBox = [overlayText sizeWithFont:[UIFont fontWithName:fontName size:fontSize]];
    CGContextSetTextPosition(context, roundf((pageInfo.rotatedPageRect.size.width-boundingBox.width)/2), roundf((pageInfo.rotatedPageRect.size.height-boundingBox.height)/2));

    // finally draw text
    CGContextShowText(context, [overlayText cStringUsingEncoding:NSUTF8StringEncoding], [overlayText length]);
}

@end

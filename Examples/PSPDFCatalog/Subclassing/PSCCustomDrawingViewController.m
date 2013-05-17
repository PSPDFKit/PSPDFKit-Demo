//
//  PSCCustomDrawingViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSCCustomDrawingViewController.h"

@interface PSCDocumentDrawer : NSObject <PSPDFDocumentDelegate> @end

@interface PSCCustomDrawingViewController ()
@property (nonatomic, strong) PSCDocumentDrawer *documentDrawer;
@end

@implementation PSCCustomDrawingViewController

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.delegate = self;
        self.documentDrawer = [[PSCDocumentDrawer alloc] init];
        document.delegate = self.documentDrawer;
    }
    return self;
}

@end

@implementation PSCDocumentDrawer

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentDelegate

- (void)pdfDocument:(PSPDFDocument *)document didRenderPage:(NSUInteger)page inContext:(CGContextRef)context withSize:(CGSize)fullSize clippedToRect:(CGRect)clipRect withAnnotations:(NSArray *)annotations options:(NSDictionary *)options {

    // Setup graphics context for current PDF page.
    PSPDFPageInfo *pageInfo = [document pageInfoForPage:page];
    [[PSPDFPageRenderer sharedPageRenderer] setupGraphicsContext:context inRectangle:clipRect pageInfo:pageInfo];

    // Flip drawing.
    CGContextTranslateCTM(context, 0, pageInfo.rotatedPageRect.size.height);
    CGContextScaleCTM(context, 1, -1);

    // Set up drawing.
    NSString *fontName = @"Helvetica-Bold";
    CGFloat fontSize = 24.f;
    NSString *overlayText = @"Example overlay";
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSelectFont(context, [fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
    CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
    CGContextSetTextMatrix(context, xform);

    // Calculate the font box to center it.
    CGSize boundingBox = [overlayText sizeWithFont:[UIFont fontWithName:fontName size:fontSize]];
    CGContextSetTextPosition(context, roundf((pageInfo.rotatedPageRect.size.width-boundingBox.width)/2), roundf((pageInfo.rotatedPageRect.size.height-boundingBox.height)/2));

    // Finally draw text.
    CGContextShowText(context, [overlayText cStringUsingEncoding:NSUTF8StringEncoding], [overlayText length]);
}

@end

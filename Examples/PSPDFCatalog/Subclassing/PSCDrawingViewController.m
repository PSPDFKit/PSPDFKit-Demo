//
//  PSCDrawingViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCDrawingViewController.h"
#import <tgmath.h>

@interface PSCDocumentDrawer : NSObject <PSPDFDocumentDelegate> @end

@interface PSCDrawingViewController ()
@property (nonatomic, strong) PSCDocumentDrawer *documentDrawer;
@end

@implementation PSCDrawingViewController

- (instancetype)initWithDocument:(PSPDFDocument *)document {
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

- (void)pdfDocument:(PSPDFDocument *)document didRenderPage:(NSUInteger)page inContext:(CGContextRef)context withSize:(CGSize)fullSize clippedToRect:(CGRect)clipRect annotations:(NSArray *)annotations options:(NSDictionary *)options {

    // Setup graphics context for current PDF page.
    PSPDFPageInfo *pageInfo = [document pageInfoForPage:page];
    [PSPDFKit.sharedInstance.renderManager setupGraphicsContext:context rectangle:clipRect pageInfo:pageInfo];

	// Set up the text and it's drawing attributes.
    NSString *overlayText = @"Example overlay";
	UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:24.f];
	UIColor *textColor = [UIColor blueColor];
	NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor};

    // Flip drawing, set text drawing mode (fill).
    CGContextTranslateCTM(context, 0, pageInfo.rotatedRect.size.height);
    CGContextScaleCTM(context, 1, -1);
	CGContextSetTextDrawingMode(context, kCGTextFill);

    // Calculate the font box to center the text on the page.
	CGSize boundingBox = [overlayText sizeWithAttributes:attributes];
	CGPoint point = CGPointMake(__tg_round((pageInfo.rotatedRect.size.width-boundingBox.width)/2), __tg_round((pageInfo.rotatedRect.size.height-boundingBox.height)/2));

	// Finally draw the text.
	[overlayText drawAtPoint:point withAttributes:attributes];
}

@end

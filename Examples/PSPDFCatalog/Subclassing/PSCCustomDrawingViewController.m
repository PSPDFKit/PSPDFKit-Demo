//
//  PSCCustomDrawingViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCCustomDrawingViewController.h"
#import <tgmath.h>

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

- (void)pdfDocument:(PSPDFDocument *)document didRenderPage:(NSUInteger)page inContext:(CGContextRef)context withSize:(CGSize)fullSize clippedToRect:(CGRect)clipRect annotations:(NSArray *)annotations options:(NSDictionary *)options {

    // Setup graphics context for current PDF page.
    PSPDFPageInfo *pageInfo = [document pageInfoForPage:page];
    [[PSPDFPageRenderer sharedPageRenderer] setupGraphicsContext:context rectangle:clipRect pageInfo:pageInfo];

	// Set up the text and it's drawing attributes.
    NSString *overlayText = @"Example overlay";
	UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:24.f];
	UIColor *textColor = [UIColor blueColor];
	NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor};

    // Flip drawing, set text drawing mode (fill).
    CGContextTranslateCTM(context, 0, pageInfo.rotatedPageRect.size.height);
    CGContextScaleCTM(context, 1, -1);
	CGContextSetTextDrawingMode(context, kCGTextFill);

    // Calculate the font box to center the text on the page.
	CGSize boundingBox = [overlayText sizeWithAttributes:attributes];
	CGPoint point = CGPointMake(__tg_round((pageInfo.rotatedPageRect.size.width-boundingBox.width)/2), __tg_round((pageInfo.rotatedPageRect.size.height-boundingBox.height)/2));

	// Finally draw the text.
	[overlayText drawAtPoint:point withAttributes:attributes];
}

@end

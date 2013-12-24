//
//  PSCSimpleImageExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCSimpleImageExample.h"
#import "PSCAssetLoader.h"

@implementation PSCSimpleImageExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Simple Image Annotation";
        self.category = PSCExampleCategoryMultimedia;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    PSPDFDocument *document = [PSCAssetLoader temporaryDocumentWithString:@"Test PDF"];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    // Dynamically add gallery annotation.
    PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://farm6.staticflickr.com/5109/5637667104_571ae77158_b.jpg"];
    CGRect pageRect = [document pageInfoForPage:0].rotatedPageRect;
    CGPoint center = CGPointMake(CGRectGetMidX(pageRect), CGRectGetMidY(pageRect));
    CGSize size = CGSizeMake(400, 300);
    galleryAnnotation.boundingBox = CGRectMake(center.x - size.width / 2.f, center.y - size.height / 2.f, size.width, size.height);
    [document addAnnotations:@[galleryAnnotation]];

    // Add simple image annotation
    PSPDFLinkAnnotation *imageAnnotation = [[PSPDFLinkAnnotation alloc] initWithLinkAnnotationType:PSPDFLinkAnnotationImage];
    imageAnnotation.fillColor = [UIColor clearColor];
    imageAnnotation.URL = [NSURL fileURLWithPath:[NSBundle.mainBundle.bundlePath stringByAppendingPathComponent:@"alternative_note_image@2x.png"]];

    imageAnnotation.boundingBox = (CGRect) {CGPointMake(3.f, 200.f), CGSizeMake(25.f, 25.f)};
    imageAnnotation.page = 0;
    [document addAnnotations:@[imageAnnotation]];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    return pdfController;
}

@end

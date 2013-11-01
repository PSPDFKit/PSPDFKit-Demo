//
//  PSCSimpleImageExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
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
    galleryAnnotation.boundingBox = CGRectMake(center.x - size.width / 2.0f, center.y - size.height / 2.0f, size.width, size.height);
    [document addAnnotations:@[galleryAnnotation]];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    return pdfController;
}

@end

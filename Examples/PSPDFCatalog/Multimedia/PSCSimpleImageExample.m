//
//  PSCSimpleImageExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCSimpleImageExample : PSCExample @end
@implementation PSCSimpleImageExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Simple Image Annotation";
        self.contentDescription = @"Add inline images to the PDF.";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 400;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader temporaryDocumentWithString:@"Test PDF"];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    // Dynamically add gallery annotation.
    PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://https://pbs.twimg.com/media/Bfw58-LIYAAVYdW.jpg"];
    CGRect pageRect = [document pageInfoForPage:0].rotatedRect;
    CGPoint center = CGPointMake(CGRectGetMidX(pageRect), CGRectGetMidY(pageRect));
    CGSize size = CGSizeMake(400.f, 300.f);
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

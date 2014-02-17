//
//  PSCGalleryExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCGalleryExample.h"
#import "PSCAssetLoader.h"

@implementation PSCGalleryExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Image Gallery";
        self.contentDescription = @"Gallery example with video, images, audio and YouTube gallery items.";
        self.category = PSCExampleCategoryMultimedia;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
    
    // Dynamically add gallery annotation.
    for (NSUInteger pageIndex = 0; pageIndex < document.pageCount; pageIndex++) {
        PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://localhost/Bundle/sample.gallery"];
        galleryAnnotation.absolutePage = pageIndex;
        CGRect pageRect = [document pageInfoForPage:0].rotatedPageRect;
        CGPoint center = CGPointMake(CGRectGetMidX(pageRect), CGRectGetMidY(pageRect));
        CGSize size = CGSizeMake(400, 300);
        galleryAnnotation.boundingBox = CGRectMake(center.x - size.width / 2.0f, center.y - size.height / 2.0f, size.width, size.height);
        [document addAnnotations:@[galleryAnnotation]];
    }

    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end

//
//  PSCFreeFormImageResizeExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCFreeFormImageResizeExample.h"
#import "PSCAssetLoader.h"

@interface PSCFreeFormResizeStampAnnotation : PSPDFStampAnnotation @end

@implementation PSCFreeFormImageResizeExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Free Form Image Resize";
        self.category = PSCExampleCategoryAnnotations;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    // Set up the document.
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    [document overrideClass:PSPDFStampAnnotation.class withClass:PSCFreeFormResizeStampAnnotation.class];

    // And also the controller.
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    return pdfController;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCFreeFormResizeStampAnnotation

@implementation PSCFreeFormResizeStampAnnotation

// Never maintain aspect ratio. By default this would return YES for images.
- (BOOL)shouldMaintainAspectRatio {
    return NO;
}

@end

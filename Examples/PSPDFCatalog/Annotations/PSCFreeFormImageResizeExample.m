//
//  PSCFreeFormImageResizeExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCExample.h"

@interface PSCFreeFormResizeStampAnnotation : PSPDFStampAnnotation @end

@interface PSCFreeFormImageResizeExample : PSCExample @end
@implementation PSCFreeFormImageResizeExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Free Form Image Resize";
        self.contentDescription = @"Disables the forced aspect ratio resizing for image (stamp) annotations.";
        self.category = PSCExampleCategoryAnnotations;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    [document overrideClass:PSPDFStampAnnotation.class withClass:PSCFreeFormResizeStampAnnotation.class];
    return [[PSPDFViewController alloc] initWithDocument:document];
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

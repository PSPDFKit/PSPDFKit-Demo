//
//  PSCSelectFreeTextAnnotationsExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCExample.h"

@interface PSCSelectFreeTextAnnotationsExample : PSCExample @end
@implementation PSCSelectFreeTextAnnotationsExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Select Free Text Annotations for editing";
        self.category = PSCExampleCategoryAnnotations;
        self.priority = 330;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    // Create sample annotations
    for (NSUInteger idx = 0; idx < 5; idx++) {
        NSString *contents = [NSString stringWithFormat:@"This is free-text annotation #%tu.", idx];
        PSPDFFreeTextAnnotation *freeText = [[PSPDFFreeTextAnnotation alloc] initWithContents:contents];
        freeText.fillColor = UIColor.yellowColor;
        freeText.fontSize = 15.f;
        freeText.boundingBox = CGRectMake(300.f, (idx+1)*100.f, 150.f, 150.f);
        [freeText sizeToFit];
        [document addAnnotations:@[freeText]];
    }

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

    // Iterate over all annotations and select them.
    __weak PSPDFViewController *weakPDFController = pdfController;
    NSArray *annotations = [document annotationsForPage:0 type:PSPDFAnnotationTypeFreeText];
    [annotations enumerateObjectsUsingBlock:^(PSPDFFreeTextAnnotation *freeText, NSUInteger idx, BOOL *stop) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * (idx+1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PSPDFPageView *pageView = [weakPDFController pageViewForPage:0];
            pageView.selectedAnnotations = @[freeText];

            // Get the annotation view and directly invoke editing.
            PSPDFFreeTextAnnotationView *freeTextView = (PSPDFFreeTextAnnotationView *)[pageView annotationViewForAnnotation:freeText];
            [freeTextView beginEditing];
        });
    }];
    
    return pdfController;
}

@end

//
//  PSCCustomAnnotationToolbarButtonsExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCCustomAnnotationToolbarButtonsExample.h"
#import "PSCAssetLoader.h"
#import "UIBarButtonItem+PSCBlockSupport.h"

@interface PSCCustomAnnotationToolbar : PSPDFAnnotationToolbar
@end

@implementation PSCCustomAnnotationToolbarButtonsExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Add a custom button to the annotation toolbar";
        self.category = PSCExampleCategoryAnnotations;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    [pdfController overrideClass:PSPDFAnnotationToolbar.class withClass:PSCCustomAnnotationToolbar.class];
    return pdfController;
}

@end

// Custom annotation toolbar sublass that adds a "Clear" button that removes all visible annotations OR the current drawing view state.
@implementation PSCCustomAnnotationToolbar {
    UIBarButtonItem *_clearAnnotationsButton;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithPDFController:(PSPDFViewController *)pdfController {
    if (self = [super initWithPDFController:pdfController]) {

        // The biggest challenge here isn't the clear button, but correctly updating the clear button if we actually can clear something or not.
        NSNotificationCenter *dnc = NSNotificationCenter.defaultCenter;
        [dnc addObserver:self selector:@selector(annotationsChanged:) name:PSPDFAnnotationChangedNotification object:nil];
        [dnc addObserver:self selector:@selector(annotationsChanged:) name:PSPDFAnnotationsAddedNotification object:nil];
        [dnc addObserver:self selector:@selector(annotationsChanged:) name:PSPDFAnnotationsRemovedNotification object:nil];

        // We could also use the delegate, but this is cleaner.
        [dnc addObserver:self selector:@selector(didShowPageViewNotification:) name:PSPDFViewControllerDidShowPageViewNotification object:nil];

        // Add clear button
        _clearAnnotationsButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearButtonPressed:)];
        [self updateClearAnnotationButton];
        self.additionalBarButtonItems = @[_clearAnnotationsButton];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Clear Button Action

- (void)clearButtonPressed:(id)sender {
    // If we're in draw mode, clear should only clear the current drawing.
    if (self.drawViews.count > 0) {
        for (PSPDFDrawView *drawView in self.drawViews.allValues) {
            [drawView clearAllActions];
        }
    }else {
        // Iterate over all visible pages and remove all but links.
        PSPDFViewController *pdfController = self.pdfController;
        PSPDFDocument *document = pdfController.document;
        for (PSPDFPageView *pageView in pdfController.visiblePageViews) {
            NSArray *annotations = [document annotationsForPage:pageView.page type:PSPDFAnnotationTypeAll&~(PSPDFAnnotationTypeLink|PSPDFAnnotationTypeWidget)];
            [document removeAnnotations:annotations];

            // Remove any annotation on the page as well (updates views)
            // Alternatively, you can call `reloadData` on the pdfController as well.
            for (PSPDFAnnotation *annotation in annotations) {
                [pageView removeAnnotation:annotation animated:YES];
            }
        }
    }
    [self updateDrawingUndoRedoButtons];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Notifications

// If we detect annotation changes, schedule a reload.
- (void)annotationsChanged:(NSNotification *)notification {
    // Re-evaluate toolbar button
    if (self.window) {
        [self updateClearAnnotationButton];
    }
}

- (void)didShowPageViewNotification:(NSNotification *)notification {
    [self updateClearAnnotationButton];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFAnnotationToolbar

- (void)updateDrawingUndoRedoButtons {
    [super updateDrawingUndoRedoButtons];
    [self updateClearAnnotationButton];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)updateClearAnnotationButton {
    BOOL annotationsFound = [self canUndoDrawing]; // Also factor in drawing mode
    if (self.drawViews.count == 0) {
        PSPDFViewController *pdfController = self.pdfController;
        for (NSNumber *pageNumber in pdfController.calculatedVisiblePageNumbers) {
            NSArray *annotations = [pdfController.document annotationsForPage:pageNumber.unsignedIntegerValue type:PSPDFAnnotationTypeAll&~(PSPDFAnnotationTypeLink|PSPDFAnnotationTypeWidget)];
            if (annotations.count > 0) {
                annotationsFound = YES;
                break;
            }
        }
    }
    _clearAnnotationsButton.enabled = annotationsFound;
}

@end

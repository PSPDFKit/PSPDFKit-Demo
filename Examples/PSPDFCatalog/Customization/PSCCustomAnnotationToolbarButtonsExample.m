//
//  PSCCustomAnnotationToolbarButtonsExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCExample.h"

@interface PSCCustomAnnotationToolbarButtonsExample : PSCExample @end
@interface PSCCustomAnnotationToolbar : PSPDFFlexibleAnnotationToolbar @end
@implementation PSCCustomAnnotationToolbarButtonsExample

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Add a custom button to the annotation toolbar";
        self.contentDescription = @"Will add a 'Clear' button to the annotation toolbar that removes all annotations from the visible page.";
        self.category = PSCExampleCategoryBarButtons;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    [pdfController overrideClass:PSPDFFlexibleAnnotationToolbar.class withClass:PSCCustomAnnotationToolbar.class];
    return pdfController;
}

@end

// Custom annotation toolbar sublass that adds a "Clear" button that removes all visible annotations OR the current drawing view state.
@implementation PSCCustomAnnotationToolbar {
    PSPDFFlexibleToolbarButton *_clearAnnotationsButton;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)initWithAnnotationStateManager:(PSPDFAnnotationStateManager *)annotationStateManager {
    if (self = [super initWithAnnotationStateManager:annotationStateManager]) {

        // The biggest challenge here isn't the clear button, but correctly updating the clear button if we actually can clear something or not.
        NSNotificationCenter *dnc = NSNotificationCenter.defaultCenter;
        [dnc addObserver:self selector:@selector(annotationChangedNotification:) name:PSPDFAnnotationChangedNotification object:nil];
        [dnc addObserver:self selector:@selector(annotationChangedNotification:) name:PSPDFAnnotationsAddedNotification object:nil];
        [dnc addObserver:self selector:@selector(annotationChangedNotification:) name:PSPDFAnnotationsRemovedNotification object:nil];

        // We could also use the delegate, but this is cleaner.
        [dnc addObserver:self selector:@selector(didShowPageViewNotification:) name:PSPDFViewControllerDidShowPageViewNotification object:nil];

        // Add clear button
		UIImage *clearImage = [PSPDFBundleImage(@"trash") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _clearAnnotationsButton = [PSPDFFlexibleToolbarButton new];
		[_clearAnnotationsButton setImage:clearImage];
		[_clearAnnotationsButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

        [self updateClearAnnotationButton];
        self.additionalButtons = @[_clearAnnotationsButton];
    }
    return self;
}

- (void)dealloc {
	[NSNotificationCenter.defaultCenter removeObserver:self];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Clear Button Action

- (void)clearButtonPressed:(id)sender {
    // If we're in draw mode, clear should only clear the current drawing.
    if (self.annotationStateManager.drawViews.count > 0) {
        for (PSPDFDrawView *drawView in self.annotationStateManager.drawViews.allValues) {
            [drawView clearAllActions];
        }
    }else {
        // Iterate over all visible pages and remove all but links.
        PSPDFViewController *pdfController = self.annotationStateManager.pdfController;
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

	PSPDFAnnotationStateManager *manager = self.annotationStateManager;
	[self annotationStateManager:manager didChangeUndoState:manager.canUndo redoState:manager.canRedo];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Notifications

// If we detect annotation changes, schedule a reload.
- (void)annotationChangedNotification:(NSNotification *)notification {
    // Re-evaluate toolbar button
    if (self.window) {
        [self updateClearAnnotationButton];
    }
}

- (void)didShowPageViewNotification:(NSNotification *)notification {
    [self updateClearAnnotationButton];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFAnnotationStateManagerDelegate

- (void)annotationStateManager:(PSPDFAnnotationStateManager *)manager didChangeUndoState:(BOOL)undoEnabled redoState:(BOOL)redoEnabled {
    [super annotationStateManager:manager didChangeUndoState:undoEnabled redoState:redoEnabled];
    [self updateClearAnnotationButton];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)updateClearAnnotationButton {
    BOOL annotationsFound = NO;
    if (self.annotationStateManager.drawViews.count == 0) {
        PSPDFViewController *pdfController = self.annotationStateManager.pdfController;
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

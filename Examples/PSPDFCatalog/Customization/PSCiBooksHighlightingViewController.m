//
//  PSCiBooksHighlightingViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCiBooksHighlightingViewController.h"

@interface PSCiBooksHighlightingViewController () <PSPDFViewControllerDelegate> {
    BOOL _isFreshSelection;
    BOOL _isSelectingText;
}
@end

@implementation PSCiBooksHighlightingViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];
    self.delegate = self;
    self.createAnnotationMenuEnabled = NO;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

// Enable simple selection mode once the page loaded.
- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView {
    pageView.selectionView.simpleSelectionModeEnabled = YES;
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didSelectText:(NSString *)text withGlyphs:(NSArray *)glyphs atRect:(CGRect)rect onPageView:(PSPDFPageView *)pageView {

    // Track that we are changing the word selection.
    _isSelectingText = text.length > 0 && pageView.scrollView.longPressGesture.state == UIGestureRecognizerStateChanged;
}

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didLongPressOnPageView:(PSPDFPageView *)pageView atPoint:(CGPoint)viewPoint gestureRecognizer:(UILongPressGestureRecognizer *)gestureRecognizer {

    // Track that initially, nothing is selected.
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _isFreshSelection = pageView.selectionView.selectedGlyphs.count == 0;
    }

    // If the gesture ended and we have a selection, create a highlight annotation.
    else if (_isSelectingText && _isFreshSelection && gestureRecognizer.state == UIGestureRecognizerStateEnded && pageView.selectionView.selectedGlyphs.count > 0) {

        // Create annotation and add to document.
        PSPDFDocument *document = pdfController.document;
        PSPDFHighlightAnnotation *highlight = [PSPDFHighlightAnnotation textOverlayAnnotationWithGlyphs:pageView.selectionView.selectedGlyphs pageRotationTransform:[document pageInfoForPage:pageView.page].pageRotationTransform];
        [document addAnnotations:@[highlight] page:pageView.page];

        // Update visible page and discard current selection.
        [pageView addAnnotation:highlight animated:NO];
        [pageView.selectionView discardSelection];

        // Wait until long press touch processing is complete, then select and show menu.
        dispatch_async(dispatch_get_main_queue(), ^{
            pageView.selectedAnnotations = @[highlight];
            [pageView showMenuIfSelectedAnimated:YES];
        });
    }

    return NO;
}

@end

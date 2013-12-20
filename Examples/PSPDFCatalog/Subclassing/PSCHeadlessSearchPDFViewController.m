//
//  PSCHeadlessSearchPDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCHeadlessSearchPDFViewController.h"

@interface PSCNonAnimatingSearchHighlightView : PSPDFSearchHighlightView @end

@implementation PSCHeadlessSearchPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];

    // we are using the delegate to be informed about page loads.
    self.delegate = self;

    // register the override to use a custom search highlight view subclass.
    [self overrideClass:PSPDFSearchHighlightView.class withClass:PSCNonAnimatingSearchHighlightView.class];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView {
    // restart search if we have a new pageView loaded.
    [self updateTextHighlight];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties

- (void)setHighlightedSearchText:(NSString *)highlightedSearchText {
    if (highlightedSearchText != _highlightedSearchText) {
        _highlightedSearchText = highlightedSearchText;
        [self updateTextHighlight];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)updateTextHighlight {
    if ([self.highlightedSearchText length]) {
        [self.document.textSearch searchForString:self.highlightedSearchText];
    }else {
        [self clearHighlightedSearchResults];
        [self.document.textSearch cancelAllOperationsAndWait];
    }
}

@end


@implementation PSCNonAnimatingSearchHighlightView

// NOP
- (void)popupAnimation {}

@end

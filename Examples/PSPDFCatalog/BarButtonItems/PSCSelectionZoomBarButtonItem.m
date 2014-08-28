//
//  PSPDFSelectionZoomBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCSelectionZoomBarButtonItem.h"

@interface PSCSelectionZoomBarButtonItem() <PSPDFSelectionViewDelegate>
@end

@implementation PSCSelectionZoomBarButtonItem {
    PSPDFSelectionView *_selectionView;

    // state properties
    BOOL _savedRotationLock;
    BOOL _savedViewLock;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFBarButtonitem

- (void)dealloc {
    _selectionView.delegate = nil;
}

- (BOOL)isAvailable {
    return [super isAvailable] && self.pdfController.viewMode == PSPDFViewModeDocument;
}

- (UIImage *)image {
     return _selectionView ? [UIImage imageNamed:@"eye-deactivate"] : [UIImage imageNamed:@"eye"];
}

- (NSString *)actionName {
    return PSPDFLocalize(@"Zoom to Area");
}

- (void)updateEyeButton {
    [self.pdfController updateBarButtonItem:self animated:YES];
}

- (BOOL)cleanup {
    if (_selectionView) {
        PSPDFViewController *pdfController = self.pdfController;
        pdfController.rotationLockEnabled = _savedRotationLock;
        pdfController.viewLockEnabled = _savedViewLock;
        _selectionView.delegate = nil;
        [_selectionView removeFromSuperview];
        _selectionView = nil;
        return YES;
    }
    return NO;
}

// override default handler
- (void)action:(PSPDFBarButtonItem *)sender {
    [self.class dismissPopoverAnimated:YES completion:NULL];

    if (![self cleanup]) {
        // disable various features to lock UI
        PSPDFViewController *pdfController = self.pdfController;
        _savedViewLock = pdfController.isViewLockEnabled;
        _savedRotationLock = pdfController.isRotationLockEnabled;
        pdfController.viewLockEnabled = YES;
        pdfController.rotationLockEnabled = YES;

        PSPDFPageView *pageView = [pdfController pageViewForPage:pdfController.page];

        _selectionView = [[PSPDFSelectionView alloc] initWithFrame:pageView.bounds delegate:self];
        [pageView addSubview:_selectionView];
    }
    [self updateEyeButton];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFSelectionViewDelegate

- (void)selectionView:(PSPDFSelectionView *)selectionView finishedWithSelectedRect:(CGRect)rect {
    PSPDFViewController *pdfController = self.pdfController;
    [pdfController zoomToRect:rect page:pdfController.page animated:YES];
    [self cleanup];
    [self updateEyeButton];
}

@end

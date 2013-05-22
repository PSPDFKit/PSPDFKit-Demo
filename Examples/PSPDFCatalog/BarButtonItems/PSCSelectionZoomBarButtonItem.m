//
//  PSPDFSelectionZoomBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCSelectionZoomBarButtonItem.h"

@interface PSCSelectionZoomBarButtonItem() <PSPDFSelectionViewDelegate>
@end

@implementation PSCSelectionZoomBarButtonItem {
    PSPDFSelectionView *_selectionView;

    // state properties
    BOOL _savedRotationLock;
    BOOL _savedViewLock;
    BOOL _savedTextSelection;
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
        pdfController.textSelectionEnabled = _savedTextSelection;
        _selectionView.delegate = nil;
        [_selectionView removeFromSuperview];
        _selectionView = nil;
        return YES;
    }
    return NO;
}

// override default handler
- (void)action:(PSPDFBarButtonItem *)sender {
    [self.class dismissPopoverAnimated:YES];

    if (![self cleanup]) {
        // disable various features to lock UI
        PSPDFViewController *pdfController = self.pdfController;
        _savedViewLock = pdfController.isViewLockEnabled;
        _savedRotationLock = pdfController.isRotationLockEnabled;
        _savedTextSelection = pdfController.isTextSelectionEnabled;
        pdfController.viewLockEnabled = YES;
        pdfController.rotationLockEnabled = YES;
        pdfController.textSelectionEnabled = NO;

        PSPDFPageView *pageView = [pdfController pageViewForPage:pdfController.page];

        _selectionView = [[PSPDFSelectionView alloc] initWithFrame:pageView.bounds delegate:self];
        [pageView addSubview:_selectionView];
    }
    [self updateEyeButton];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFSelectionViewDelegate

- (void)selectionView:(PSPDFSelectionView *)selectionView finishedWithSelectedRect:(CGRect)rect {
    [self.pdfController zoomToRect:rect animated:YES];
    [self cleanup];
    [self updateEyeButton];
}

@end

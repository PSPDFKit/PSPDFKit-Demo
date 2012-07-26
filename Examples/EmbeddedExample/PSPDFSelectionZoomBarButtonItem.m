//
//  PSPDFSelectionZoomBarButtonItem.m
//  EmbeddedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFSelectionZoomBarButtonItem.h"

@interface PSPDFSelectionZoomBarButtonItem() <PSPDFSelectionViewDelegate>
@end

@implementation PSPDFSelectionZoomBarButtonItem {
    PSPDFTransparentToolbar *_toolbar;
    PSPDFSelectionView *_selectionView;

    // state properties
    BOOL _savedRotationLock;
    BOOL _savedViewLock;
    BOOL _savedTextSelection;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFBarButtonitem

// a UIToolbar is used instead of an UIButton to get the automatic shadows on UIBarButtonItem icons.
- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[PSPDFTransparentToolbar alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        _toolbar.barStyle = self.pdfController.navigationController.navigationBar.barStyle;
        _toolbar.tintColor = self.pdfController.tintColor;
        [self updateEyeButton];
    }
    return _toolbar;
}

- (BOOL)isAvailable {
    return self.pdfController.viewMode == PSPDFViewModeDocument;
}

- (UIView *)customView {
    return self.toolbar;
}

- (void)updateEyeButton {
    UIImage *buttonItem = _selectionView ? [UIImage imageNamed:@"eye-deactivate"] : [UIImage imageNamed:@"eye"];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:buttonItem style:UIBarButtonItemStylePlain target:self action:@selector(selectionZoomAction:)];
    [self.toolbar setItems:@[flexibleSpace, barButtonItem, flexibleSpace] animated:YES];
}

- (BOOL)cleanup {
    if (_selectionView) {
        self.pdfController.rotationLockEnabled = _savedRotationLock;
        self.pdfController.viewLockEnabled = _savedViewLock;
        self.pdfController.textSelectionEnabled = _savedTextSelection;
        _selectionView.delegate = nil;
        [_selectionView removeFromSuperview];
        _selectionView = nil;
        return YES;
    }
    return NO;
}

- (void)selectionZoomAction:(PSPDFBarButtonItem *)sender {
    if (![self cleanup]) {
        // diable various features to lock UI
        _savedViewLock = self.pdfController.isViewLockEnabled;
        _savedRotationLock = self.pdfController.isRotationLockEnabled;
        _savedTextSelection = self.pdfController.isTextSelectionEnabled;
        self.pdfController.viewLockEnabled = YES;
        self.pdfController.rotationLockEnabled = YES;
        self.pdfController.textSelectionEnabled = NO;

        PSPDFPageView *pageView = [self.pdfController pageViewForPage:self.pdfController.realPage];

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

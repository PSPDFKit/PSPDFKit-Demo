//
//  PSPDFPlayButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSCPlayBarButtonItem.h"

@implementation PSCPlayBarButtonItem {
    PSPDFTransparentToolbar *_toolbar;
    NSTimer *_autoplayTimer;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFBarButtonItem

- (BOOL)isAvailable {
    return [super isAvailable] && self.pdfController.viewMode == PSPDFViewModeDocument;
}

// If we would return UIBarButtonSystemItem, UIKit would auto-calculate the width and there - surprise! - is a 3px difference between play/pause, making all icons afterwards to jump.
//- (UIBarButtonSystemItem)systemItem {
//    return self.isAutoplaying ? UIBarButtonSystemItemPause : UIBarButtonSystemItemPlay;
//}

// a UIToolbar is used instead of an UIButton to get the automatic shadows on UIBarButtonItem icons.
- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[PSPDFTransparentToolbar alloc] initWithFrame:CGRectMake(0.f, 0.f, 22.f, 44.f)];
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _toolbar.barStyle = self.pdfController.navigationController.navigationBar.barStyle;
        _toolbar.tintColor = self.pdfController.tintColor;
        [self updatePlayButton];
    }
    return _toolbar;
}

- (UIView *)customView {
    return self.toolbar;
}

- (void)updateBarButtonItem {
    // it's quite tricky to get the height right.
    CGRect toolbarFrame = _toolbar.frame;
    toolbarFrame.size.height = (PSIsIpad() || UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation)) ? 44 : 32;
    _toolbar.frame = toolbarFrame;
}

- (void)updatePlayButton {
    UIBarButtonSystemItem systemItem = self.isAutoplaying ? UIBarButtonSystemItemPause : UIBarButtonSystemItemPlay;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(playPauseAction:)];
    [self.toolbar setItems:@[flexibleSpace, barButtonItem, flexibleSpace] animated:YES];
}

- (void)playPauseAction:(id)sender {
    [self.class dismissPopoverAnimated:NO];

    if (!self.isAutoplaying) {
        _autoplaying = YES;
        _autoplayTimer = [NSTimer scheduledTimerWithTimeInterval:kPSPDFSlideshowDuration target:self selector:@selector(advanceToNextPage) userInfo:nil repeats:YES];
        [self updatePlayButton];
    }else {
        _autoplaying = NO;
        [_autoplayTimer invalidate];
        [self updatePlayButton];
    }

    // lock any interaction while we are in auto-scroll mode
    PSPDFViewController *pdfController = self.pdfController;
    pdfController.textSelectionEnabled = !_autoplaying;
    pdfController.scrollOnTapPageEndEnabled = !_autoplaying;
    pdfController.viewLockEnabled = _autoplaying;
    pdfController.scrollingEnabled = !_autoplaying;
}

- (void)advanceToNextPage {
    PSPDFViewController *pdfController = self.pdfController;

    pdfController.viewLockEnabled = NO;
    if ([pdfController isLastPage]) {
        [pdfController setPage:0 animated:YES];
    }else {
        [pdfController scrollToNextPageAnimated:YES];
    }
    pdfController.viewLockEnabled = _autoplaying;
}

- (void)setAutoplaying:(BOOL)autoplaying {
    if (_autoplaying != autoplaying) {
        [self playPauseAction:nil];
    }
}

@end

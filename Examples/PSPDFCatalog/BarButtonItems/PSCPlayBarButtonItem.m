//
//  PSPDFPlayButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCPlayBarButtonItem.h"

@interface PSCPlayBarButtonItem ()
@property (nonatomic, strong) PSPDFTransparentToolbar *toolbar;
@property (nonatomic, strong) NSTimer *autoplayTimer;
@end

@implementation PSCPlayBarButtonItem

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
- (PSPDFTransparentToolbar *)toolbar {
    if (!_toolbar) {
        PSPDFViewController *pdfController = self.pdfController;
        _toolbar = [[PSPDFTransparentToolbar alloc] initWithFrame:CGRectMake(0.f, 0.f, 22.f, 44.f)];
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _toolbar.barStyle = pdfController.navigationController.navigationBar.barStyle;
        [self updatePlayButton];
    }
    return _toolbar;
}

- (UIView *)customView {
    return self.toolbar;
}

- (void)updateBarButtonItem {
    // It's quite tricky to get the height right.
    CGRect toolbarFrame = self.toolbar.frame;
    toolbarFrame.size.height = (PSCIsIPad() || UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation)) ? 44.f : 32.f;
    self.toolbar.frame = toolbarFrame;
}

- (void)updatePlayButton {
    UIBarButtonSystemItem systemItem = self.isAutoplaying ? UIBarButtonSystemItemPause : UIBarButtonSystemItemPlay;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(playPauseAction:)];
    [self.toolbar setItems:@[flexibleSpace, barButtonItem, flexibleSpace] animated:YES];
}

- (void)playPauseAction:(id)sender {
    [self.class dismissPopoverAnimated:NO completion:NULL];

    if (!self.isAutoplaying) {
        self.autoplaying = YES;
        self.autoplayTimer = [NSTimer scheduledTimerWithTimeInterval:PSCSlideshowDuration target:self selector:@selector(advanceToNextPage) userInfo:nil repeats:YES];
        [self updatePlayButton];
    } else {
        self.autoplaying = NO;
        [self.autoplayTimer invalidate];
        [self updatePlayButton];
    }

    // lock any interaction while we are in auto-scroll mode
    PSPDFViewController *pdfController = self.pdfController;
    [pdfController updateConfigurationWithoutReloadingWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        builder.textSelectionEnabled = !self.isAutoplaying;
        builder.scrollOnTapPageEndEnabled = !self.isAutoplaying;
    }];
    pdfController.viewLockEnabled = self.isAutoplaying;
    pdfController.scrollingEnabled = !self.isAutoplaying;
}

- (void)advanceToNextPage {
    PSPDFViewController *pdfController = self.pdfController;

    pdfController.viewLockEnabled = NO;
    if ([pdfController isLastPage]) {
        [pdfController setPage:0 animated:YES];
    } else {
        [pdfController scrollToNextPageAnimated:YES];
    }
    pdfController.viewLockEnabled = self.isAutoplaying;
}

- (void)setAutoplaying:(BOOL)autoplaying {
    if (_autoplaying != autoplaying) {
        [self playPauseAction:nil];
    }
}

@end

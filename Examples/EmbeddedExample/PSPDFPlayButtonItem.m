//
//  PSPDFPlayButtonItem.m
//  EmbeddedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFPlayButtonItem.h"

@implementation PSPDFPlayButtonItem {
    PSPDFTransparentToolbar *_toolbar;
    NSTimer *_autoplayTimer;
    BOOL _autoplay;
}

- (BOOL)isAvailable {
    return self.pdfController.viewMode == PSPDFViewModeDocument;
}

// a UIToolbar is used instead of an UIButton to get the automatic shadows on UIBarButtonItem icons.
- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[PSPDFTransparentToolbar alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        _toolbar.barStyle = self.pdfController.navigationController.navigationBar.barStyle;
        _toolbar.tintColor = self.pdfController.tintColor;
        [self updatePlayButton];
    }
    return _toolbar;
}

- (UIView *)customView {
    return self.toolbar;
}

- (void)updatePlayButton {
    UIBarButtonSystemItem systemItem = _autoplay ? UIBarButtonSystemItemPause : UIBarButtonSystemItemPlay;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(playPauseAction:)];
    [self.toolbar setItems:@[flexibleSpace, barButtonItem, flexibleSpace] animated:YES];
}

- (void)playPauseAction:(id)sender {
    [PSPDFBarButtonItem dismissPopoverAnimated:NO];
    
    if (!_autoplay) {
        _autoplay = YES;
        _autoplayTimer = [NSTimer scheduledTimerWithTimeInterval:kPSPDFSlideshowDuration target:self.pdfController selector:@selector(advanceToNextPage) userInfo:nil repeats:YES];
        [self updatePlayButton];
    }else {
        _autoplay = NO;
        [_autoplayTimer invalidate];
        [self updatePlayButton];
    }
}

@end

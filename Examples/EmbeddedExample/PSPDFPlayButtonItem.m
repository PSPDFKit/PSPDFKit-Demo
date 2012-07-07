//
//  PSPDFPlayButtonItem.m
//  EmbeddedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFPlayButtonItem.h"

@implementation PSPDFPlayButtonItem {
    PSPDFTransparentToolbar *toolbar_;
    NSTimer *autoplayTimer_;
    BOOL autoplay_;
}

// a UIToolbar is used instead of an UIButton to get the automatic shadows on UIBarButtonItem icons.
- (UIToolbar *)toolbar {
    if (!toolbar_) {
        toolbar_ = [[PSPDFTransparentToolbar alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
        toolbar_.barStyle = self.pdfController.navigationController.navigationBar.barStyle;
        toolbar_.tintColor = self.pdfController.tintColor;
        [self updatePlayButton];
    }
    return toolbar_;
}

- (UIView *)customView {
    return self.toolbar;
}

- (void)updatePlayButton {
    UIBarButtonSystemItem systemItem = autoplay_ ? UIBarButtonSystemItemPause : UIBarButtonSystemItemPlay;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem target:self action:@selector(playPauseAction:)];
    [self.toolbar setItems:@[flexibleSpace, barButtonItem, flexibleSpace] animated:YES];
}

- (void)playPauseAction:(id)sender {
    [PSPDFBarButtonItem dismissPopoverAnimated:NO];
    
    if (!autoplay_) {
        autoplay_ = YES;
        autoplayTimer_ = [NSTimer scheduledTimerWithTimeInterval:kPSPDFSlideshowDuration target:self.pdfController selector:@selector(advanceToNextPage) userInfo:nil repeats:YES];
        [self updatePlayButton];
    }else {
        autoplay_ = NO;
        [autoplayTimer_ invalidate];
        [self updatePlayButton];
    }
}

@end

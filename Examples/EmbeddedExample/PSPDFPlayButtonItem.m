//
//  PSPDFPlayButtonItem.m
//  EmbeddedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFPlayButtonItem.h"

@implementation PSPDFPlayButtonItem {
    NSTimer *_autoplayTimer;
    BOOL _autoplay;
}

- (BOOL)isAvailable {
    return [super isAvailable] && self.pdfController.viewMode == PSPDFViewModeDocument;
}

- (UIBarButtonSystemItem)systemItem {
    return _autoplay ? UIBarButtonSystemItemPause : UIBarButtonSystemItemPlay;
}

- (void)action:(id)sender {
    [PSPDFBarButtonItem dismissPopoverAnimated:NO];
    
    if (!_autoplay) {
        _autoplay = YES;
        _autoplayTimer = [NSTimer scheduledTimerWithTimeInterval:kPSPDFSlideshowDuration target:self.pdfController selector:@selector(advanceToNextPage) userInfo:nil repeats:YES];
    }else {
        _autoplay = NO;
        [_autoplayTimer invalidate];
    }

    [self.pdfController updateBarButtonItem:self animated:YES];
}

@end

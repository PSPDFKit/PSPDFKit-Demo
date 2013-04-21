//
//  PSCTopScrobbleBar.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSCTopScrobbleBar.h"

@implementation PSCTopScrobbleBar

- (void)setToolbarFrameAndVisibility:(BOOL)shouldShow animated:(BOOL)animated {
    NSLog(@"----------CustomScrobbleBar:setToolbarFrameAndVisibility-----------");

    // Stick scrobble bar to the top.
    CGRect newFrame = self.pdfController.contentRect;
    newFrame.size.height = 44.f;
    self.frame = newFrame;

    // Disable view lock (else we get called recursively)
    self.viewLocked = NO;
}

@end

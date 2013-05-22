//
//  PSCTopScrobbleBar.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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

//
//  PSPFScrobbleBar.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFCache.h"

/// Scrobble bar like in iBooks.
@interface PSPDFScrobbleBar : UIView <PSPDFCacheDelegate>

/// initialize with pdf controller.
- (id)initWithPDFController:(PSPDFViewController *)pdfController;

/// pdf controller delegate.
@property(nonatomic, assign) PSPDFViewController *pdfController;

/// updates toolbar, realigns page screenshots. Registers in the runloop and works later.
- (void)updateToolbar;

/// *instantly* updates toolbar.
- (void)updateToolbarForced;

/// updates the page marker. call manually after alpha > 0 !
- (void)updatePageMarker;

/// current selected page.
@property(nonatomic, assign) NSUInteger page;

/// locks view for animations.
@property(nonatomic, assign, getter=isViewLocked) BOOL viewLocked;

/// access toolbar. It's in an own view, to have a transparent toolbar but non-transparent images.
@property(nonatomic, retain) UIToolbar *toolbar;

@end

//
//  PSPFScrobbleBar.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFCache.h"
#import "PSPDFKitGlobal.h"

@class PSPDFViewController;

/// Scrobble bar like in iBooks.
@interface PSPDFScrobbleBar : UIView <PSPDFCacheDelegate>

/// pdf controller delegate.
@property(nonatomic, unsafe_unretained) PSPDFViewController *pdfController;

/// updates toolbar, realigns page screenshots. Registers in the runloop and works later.
- (void)updateToolbar;

/// *instantly* updates toolbar.
- (void)updateToolbarForced;

/// updates the page marker. call manually after alpha > 0 !
- (void)updatePageMarker;

/// current selected page.
@property(nonatomic, assign) NSUInteger page;

/// access toolbar. It's in an own view, to have a transparent toolbar but non-transparent images.
@property(nonatomic, strong) UIToolbar *toolbar;

@end

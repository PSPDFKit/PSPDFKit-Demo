//
//  PSPFScrobbleBar.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFCache.h"

@class PSPDFViewController;

/// ScrobbleBar, similar to iBooks.
/// This class connects to the pdfController via KVO.
@interface PSPDFScrobbleBar : UIView <PSPDFCacheDelegate>

/// PDF controller delegate. We use KVO, so no weak here.
/// Re-set pdfController to update the tintColor.
@property (nonatomic, unsafe_unretained) PSPDFViewController *pdfController;

/// Updates toolbar, realigns page screenshots. Registers in the runloop and works later.
- (void)updateToolbar;

/// *Instantly* updates toolbar.
- (void)updateToolbarForced;

/// Updates the page marker. call manually after alpha > 0 !
- (void)updatePageMarker;

/// Current selected page.
@property (nonatomic, assign) NSUInteger page;

/// Access toolbar. It's in an own view, to have a transparent toolbar but non-transparent images.
/// Alpha is set to 0.7, can be changed.
@property (nonatomic, strong) UIToolbar *toolbar;

/// Defaults to 5. 
@property (nonatomic, assign) CGFloat leftBorderMargin;

/// Defaults to 5.
@property (nonatomic, assign) CGFloat rightBorderMargin;

@end

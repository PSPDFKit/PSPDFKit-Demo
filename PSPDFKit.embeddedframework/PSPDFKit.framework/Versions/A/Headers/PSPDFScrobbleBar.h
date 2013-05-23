//
//  PSPDFScrobbleBar.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFCache.h"

@class PSPDFViewController;

/// PDF thumbnail scrobble bar - similar to iBooks.
@interface PSPDFScrobbleBar : UIView <PSPDFCacheDelegate>

/// PDF controller delegate. We use KVO, so no weak here.
/// Re-set pdfController to update the tintColor.
@property (nonatomic, unsafe_unretained) PSPDFViewController *pdfController;

/// Updates toolbar, re-aligns page screenshots. Registers in the runloop and works later.
- (void)updateToolbarAnimated:(BOOL)animated;

/// Updates the toolbar position.
- (void)updateToolbarPositionAnimated:(BOOL)animated;

/// *Instantly* updates toolbar.
- (void)updateToolbarForced;

/// Updates the page marker. call manually after alpha > 0 !
- (void)updatePageMarker;

/// Current selected page.
@property (nonatomic, assign) NSUInteger page;

/// Access toolbar. It's in an own view, to have a transparent toolbar but non-transparent images.
/// Alpha is set to 0.7, can be changed.
@property (nonatomic, strong) UIToolbar *toolbar;

/// Left border margin. Defaults to thumbnailMargin. Set higher to allow custom buttons.
@property (nonatomic, assign) CGFloat leftBorderMargin;

/// Right border margin. Defaults to thumbnailMargin. Set higher to allow custom buttons.
@property (nonatomic, assign) CGFloat rightBorderMargin;

/// Taps left/right of the pages area (if there aren't enough pages to fill up space) by default count as first/last page. Defaults to YES.
@property (nonatomic, assign) BOOL allowTapsOutsidePageArea;

@end


@interface PSPDFScrobbleBar (SubclassingHooks)

// Updates the frame and the visibility depending if toolbar is displayed or not.
- (void)setToolbarFrameAndVisibility:(BOOL)shouldShow animated:(BOOL)animated;

// Implementation detail: if you override setToolbarFrameAndVisibility, you need to set this to NO after you're done setting/animating the frame.
@property (nonatomic, assign, getter=isViewLocked) BOOL viewLocked;

// Returns YES if toolbar is in landscape+iPhone mode.
- (BOOL)isSmallToolbar;

// Returns toolbar height. (depending on isSmallToolbar)
- (CGFloat)scrobbleBarHeight;

// Returns size of the bottom thumbnails. (depending on isSmallToolbar)
- (CGSize)scrobbleBarThumbSize;

// Called once for every thumbnail image.
- (UIImageView *)emptyThumbnailImageView;

// Called upon touches and drags on the thumbnails.
- (BOOL)processTouch:(UITouch *)touch animated:(BOOL)animated;

// Margin between thumbnails. Defaults to 2.
@property (nonatomic, assign) CGFloat thumbnailMargin;

// Size multiplier for the current page thumbnail. Defaults to 1.35.
@property (nonatomic, assign) CGFloat pageMarkerSizeMultiplier;

@end

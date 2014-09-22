//
//  PSPDFScrobbleBar.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFCache.h"
#import "PSPDFPresentationContext.h"

@class PSPDFScrobbleBar;

@protocol PSPDFScrobbleBarDelegate <NSObject>

- (void)scrobbleBar:(PSPDFScrobbleBar *)scrobbleBar didSelectPage:(NSUInteger)page;

@end

/// PDF thumbnail scrobble bar - similar to iBooks.
@interface PSPDFScrobbleBar : UIView <PSPDFCacheDelegate>

/// The delegate for touch events
@property (nonatomic, weak) id <PSPDFScrobbleBarDelegate> delegate;

/// The data source.
@property (nonatomic, weak) id <PSPDFPresentationContext> dataSource;

/// Updates toolbar, re-aligns page screenshots. Registers in the runloop and works later.
- (void)updateToolbarAnimated:(BOOL)animated;

/// *Instantly* updates toolbar.
- (void)updateToolbarForced;

/// Updates the page marker.
- (void)updatePageMarker;

/// Current selected page.
@property (nonatomic, assign) NSUInteger page;

/// Taps left/right of the pages area (if there aren't enough pages to fill up space) by default count as first/last page. Defaults to YES.
@property (nonatomic, assign) BOOL allowTapsOutsidePageArea;

/// @name Styling

/// The background tintColor.
/// Defaults to the PSPDFViewController navigationBar barTintColor (if available).
@property (nonatomic, strong) UIColor *barTintColor UI_APPEARANCE_SELECTOR;

/// If set to a nonzero value, the scrobble bar will render with the standard translucency - blur effect.
/// Inferred from the dataSource by default.
/// @note `UIAppearance` for BOOL is only supported in iOS 8.
@property (nonatomic, assign, getter=isTranslucent) BOOL translucent UI_APPEARANCE_SELECTOR;

/// Left border margin. Defaults to `thumbnailMargin`. Set higher to allow custom buttons.
@property (nonatomic, assign) CGFloat leftBorderMargin;

/// Right border margin. Defaults to `thumbnailMargin`. Set higher to allow custom buttons.
@property (nonatomic, assign) CGFloat rightBorderMargin;

@end


@interface PSPDFScrobbleBar (SubclassingHooks)

// Returns YES if toolbar is in landscape+iPhone mode.
- (BOOL)isSmallToolbar;

// Returns toolbar height. (depending on `isSmallToolbar`)
- (CGFloat)scrobbleBarHeight;

// Returns size of the bottom thumbnails. (depending on `isSmallToolbar`)
- (CGSize)scrobbleBarThumbSize;

// Called once for every thumbnail image.
- (UIImageView *)emptyThumbnailImageView;

// Called upon touches and drags on the thumbnails.
- (BOOL)processTouch:(UITouch *)touch;

// Margin between thumbnails. Defaults to 2.
@property (nonatomic, assign) CGFloat thumbnailMargin;

// Size multiplier for the current page thumbnail. Defaults to 1.35.
@property (nonatomic, assign) CGFloat pageMarkerSizeMultiplier;

@end

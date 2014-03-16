//
//  PSPDFHUDView.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

@import UIKit;
#import "PSPDFRelayTouchesView.h"
#import "PSPDFScrobbleBar.h"
#import "PSPDFLabelView.h"
#import "PSPDFPageLabelView.h"

@class PSPDFDocumentLabelView, PSPDFPageLabelView, PSPDFScrobbleBar, PSPDFThumbnailBar, PSPDFDocument;

// Empty subclass for easier debugging.
@interface PSPDFDocumentLabelView : PSPDFLabelView @end

typedef NS_ENUM(NSUInteger, PSPDFThumbnailBarMode) {
    PSPDFThumbnailBarModeNone,            /// Don't show thumbnail bottom bar.
    PSPDFThumbnailBarModeScrobbleBar,     /// Show scrobble bar (like iBooks, PSPDFScrobbleBar)
    PSPDFThumbnailBarModeScrollable       /// Show scrollable thumbnail bar (PSPDFThumbnailBar)
};

typedef NS_ENUM(NSUInteger, PSPDFHUDViewMode) {
    PSPDFHUDViewModeAlways,                   /// Always show the HUD.
    PSPDFHUDViewModeAutomatic,                /// Show HUD on touch and first/last page.
    PSPDFHUDViewModeAutomaticNoFirstLastPage, /// Show HUD on touch.
    PSPDFHUDViewModeNever                     /// Never show the HUD.
};

typedef NS_ENUM(NSUInteger, PSPDFHUDViewAnimation) {
    PSPDFHUDViewAnimationNone,            /// Don't animate HUD appearance
    PSPDFHUDViewAnimationFade,            /// Fade HUD in/out
    PSPDFHUDViewAnimationSlide            /// Slide HUD.
};

// Action delegate. Aggregates indivitual delegates.
@protocol PSPDFHUDViewDelegate <PSPDFThumbnailBarDelegate, PSPDFScrobbleBarDelegate, PSPDFPageLabelViewDelegate>
@end

/// The HUD overlay for the `PSPDFViewController`. Contains the thumbnail and page/title label overlays.
@interface PSPDFHUDView : PSPDFRelayTouchesView

/// Designated initializer.
- (id)initWithFrame:(CGRect)frame delegate:(id<PSPDFHUDViewDelegate>)delegate dataSource:(id <PSPDFConfigurationDataSource>)dataSource;

/// The data source.
@property (nonatomic, weak, readonly) id <PSPDFConfigurationDataSource> dataSource;

/// The data source
@property (nonatomic, weak, readonly) id <PSPDFHUDViewDelegate> delegate;

/// Force subview updating.
- (void)layoutSubviewsAnimated:(BOOL)animated;

/// Fetches data again
- (void)reloadData;

// See PSPDFViewController for explanations of these properties.
@property (nonatomic, assign) PSPDFHUDViewMode HUDViewMode;
@property (nonatomic, assign) PSPDFHUDViewAnimation HUDViewAnimation;
@property (nonatomic, assign) PSPDFThumbnailBarMode thumbnailBarMode;
@property (nonatomic, assign, getter=isPageLabelEnabled) BOOL pageLabelEnabled;
@property (nonatomic, assign, getter=isDocumentLabelEnabled) BOOL documentLabelEnabled;

@property (nonatomic, assign) CGFloat pageLabelDistance UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat documentLabelDistance UI_APPEARANCE_SELECTOR;

@end

@interface PSPDFHUDView (Subviews)

/// Document title label view.
@property (nonatomic, strong) PSPDFDocumentLabelView *documentLabel;

/// Document page label view.
@property (nonatomic, strong) PSPDFPageLabelView *pageLabel;

/// Scrobble bar. Created lazily. Available if `PSPDFThumbnailBarModeScrobbleBar` is set.
@property (nonatomic, strong, readonly) PSPDFScrobbleBar *scrobbleBar;

/// Thumbnail bar. Created lazily. Available if `PSPDFThumbnailBarModeScrollable` is set.
@property (nonatomic, strong, readonly) PSPDFThumbnailBar *thumbnailBar;

@end

@interface PSPDFHUDView (SubclassingHooks)

// Update these to manually set the frame.
- (void)updateDocumentLabelFrameAnimated:(BOOL)animated;
- (void)updatePageLabelFrameAnimated:(BOOL)animated;
- (void)updateThumbnailBarFrameAnimated:(BOOL)animated;
- (void)updateScrobbleBarFrameAnimated:(BOOL)animated;

@end

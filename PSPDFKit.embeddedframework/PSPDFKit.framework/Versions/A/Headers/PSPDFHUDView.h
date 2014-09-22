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

#import <UIKit/UIKit.h>
#import "PSPDFRelayTouchesView.h"
#import "PSPDFScrobbleBar.h"
#import "PSPDFLabelView.h"
#import "PSPDFPageLabelView.h"
#import "PSPDFThumbnailBar.h"

@class PSPDFDocumentLabelView, PSPDFPageLabelView, PSPDFScrobbleBar, PSPDFThumbnailBar, PSPDFDocument;

// Empty subclass for easier debugging.
@interface PSPDFDocumentLabelView : PSPDFLabelView @end

/// The HUD overlay for the `PSPDFViewController`. Contains the thumbnail and page/title label overlays.
@interface PSPDFHUDView : PSPDFRelayTouchesView

/// Designated initializer.
- (instancetype)initWithFrame:(CGRect)frame
                   dataSource:(id <PSPDFPresentationContext>)dataSource NS_DESIGNATED_INITIALIZER;

/// The data source.
@property (nonatomic, weak, readonly) id <PSPDFPresentationContext> dataSource;

/// Force subview updating.
- (void)layoutSubviewsAnimated:(BOOL)animated;

/// Fetches data again
- (void)reloadData;

/// Specifies the distance between the page label and the top of the scrobble bar or the
/// bottom of the screen, depending on whether the scrobble bar is enabled. Defaults to 10.f
@property (nonatomic, assign) CGFloat pageLabelDistance UI_APPEARANCE_SELECTOR;

/// Specifies the distance between the top document label. Defaults to 10.f
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

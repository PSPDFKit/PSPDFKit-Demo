//
//  PSPDFGalleryContainerView.h
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
#import "PSPDFBlurView.h"
#import "PSPDFOverridable.h"
#import "PSPDFModernizer.h"

/// `PSPDFGalleryContainerViewContentState` controls which content view will be visible.
typedef NS_ENUM(NSUInteger, PSPDFGalleryContainerViewContentState) {
    /// The content is currently loading.
    PSPDFGalleryContainerViewContentStateLoading,

    /// The content is ready and presentable.
    PSPDFGalleryContainerViewContentStateReady,

    /// An error occurred.
    PSPDFGalleryContainerViewContentStateError
};

/// `PSPDFGalleryContainerViewPresentationMode` controls which background view will be visible.
typedef NS_ENUM(NSUInteger, PSPDFGalleryContainerViewPresentationMode) {
    /// The embedded presentation mode.
    PSPDFGalleryContainerViewPresentationModeEmbedded,

    /// The fullscreen presentation mode.
    PSPDFGalleryContainerViewPresentationModeFullscreen
};

@class PSPDFGalleryView, PSPDFGalleryLoadingView, PSPDFStatusHUDView;

// The following dummy classes are created to allow specific UIAppearance targeting.
// They do not have any functionality besides that.
@interface PSPDFGalleryEmbeddedBackgroundView : PSPDFBlurView @end
@interface PSPDFGalleryFullscreenBackgroundView : PSPDFBlurView @end

/// Used to group the error, loading and gallery view and to properly lay them out.
@interface PSPDFGalleryContainerView : UIView

/// Initializes the `PSPDFGalleryContainerView` with a `frame` and an `overrideDelegate`.
/// The `overrideDelegate` is used to allow customization using the `PSPDFOverridable` protocol.
/// The delegate is optional.
- (instancetype)initWithFrame:(CGRect)frame overrideDelegate:(id<PSPDFOverridable>)overrideDelegate NS_DESIGNATED_INITIALIZER;

/// Initializes the `PSPDFGalleryContainerView` with a frame. No `overrideDelegate` is set.
- (instancetype)initWithFrame:(CGRect)frame;

/// The override delegate, if set.
@property (nonatomic, weak, readonly) id<PSPDFOverridable> overrideDelegate;

/// @name State

/// The content state.
@property (nonatomic, assign) PSPDFGalleryContainerViewContentState contentState;

/// The presentation mode.
@property (nonatomic, assign) PSPDFGalleryContainerViewPresentationMode presentationMode;

/// @name Subviews

/// The gallery view.
@property (nonatomic, strong) PSPDFGalleryView *galleryView;

/// The loading view.
@property (nonatomic, strong) PSPDFGalleryLoadingView *loadingView;

/// The background view.
@property (nonatomic, strong) PSPDFGalleryEmbeddedBackgroundView *backgroundView;

/// The fullscreen background view.
@property (nonatomic, strong) PSPDFGalleryFullscreenBackgroundView *fullscreenBackgroundView;

/// The status HUD view.
@property (nonatomic, strong) PSPDFStatusHUDView *statusHUDView;

/// This view conveniently groups together the `galleryView`, `loadingView` and `statusHUDView`.
@property (nonatomic, strong, readonly) UIView *contentContainerView;

/// @name HUD Presentation

/// Presents the HUD. After the given `timeout`, it will automatically be dismissed.
/// @note You can use a negative `timeout` to present the HUD indefinitely.
- (void)presentStatusHUDWithTimeout:(NSTimeInterval)timeout animated:(BOOL)animated;

/// Dismisses the HUD.
- (void)dismissStatusHUDAnimated:(BOOL)animated;

@end

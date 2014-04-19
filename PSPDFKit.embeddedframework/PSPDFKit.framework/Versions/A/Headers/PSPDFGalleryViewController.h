//
//  PSPDFGalleryViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFBaseViewController.h"
#import "PSPDFGalleryItem.h"

@class PSPDFLinkAnnotation, PSPDFMediaPlayerController;

typedef NS_ENUM(NSUInteger, PSPDFGalleryViewControllerState) {
    /// The view controller is currently not doing anything.
    PSPDFGalleryViewControllerStateIdle,
    
    /// The manifest file is currently downloaded.
    PSPDFGalleryViewControllerStateLoading,
    
    /// The manifest file has been downloaded and the view controller is ready.
    PSPDFGalleryViewControllerStateReady,
    
    /// The view controller could not download the manifest file because of a connection error.
    PSPDFGalleryViewControllerStateConnectionError,
    
    /// The view controller could download the manifest file but could not parse it.
    PSPDFGalleryViewControllerStateManifestError
};

@class PSPDFGalleryViewController;

/// Handles a gallery of one or multiple images.
@interface PSPDFGalleryViewController : PSPDFBaseViewController <PSPDFOverridable>

/// Create a new gallery view controller by passing in a link annotation with `linkAnnotationType` set to `PSPDFLinkAnnotationImage`.
- (instancetype)initWithLinkAnnotation:(PSPDFLinkAnnotation *)annotation;

/// @name Configuration

/// The max. number of concurrent downloads. Defaults to 2. Must at least be 1.
@property (nonatomic, assign) NSUInteger maxConcurrentDownloads;

/// The max. number of images after the currently visible one that should be prefetched. Defaults to 5.
/// To disable prefetching, set this to zero.
@property (nonatomic, assign) NSUInteger maxPrefetchDownloads;

/// Controls if the user can switch between the fullscreen mode and embedded mode by double-tapping
/// or panning. Defaults to `YES`.
/// @note This only affects user interaction. If you call `setFullscreen:animated:` programmatically,
/// the mode will still be set accordingly.
@property (nonatomic, assign) BOOL displayModeUserInteractionEnabled;

/// The treshold in points after which the fullscreen mode is exited after a pan. Defaults to 80pt.
@property (nonatomic, assign) CGFloat fullscreenDismissPanTreshold;

/// Set this to YES if zooming should be enabled in fullscreen mode. Defaults to YES.
@property (nonatomic, assign, getter=isFullscreenZoomEnabled) BOOL fullscreenZoomEnabled;

/// The maximum zoom scale that you want to allow. Only meaningful if `fullscreenZoomEnabled` is YES
/// Defaults to 5.0.
@property (nonatomic, assign) CGFloat maximumFullscreenZoomScale;

/// The minimum zoom scale that you want to allow. Only meaningful if `fullscreenZoomEnabled` is YES.
/// Defaults to 1.0.
@property (nonatomic, assign) CGFloat minimumFullscreenZoomScale;

/// Controls if the gallery should loop infinitely, that is if the user can keep scrolling forever
/// and the content will repeat itself. Defaults to `YES`. Ignored if there's only one item set.
@property (nonatomic, assign, getter=isLoopEnabled) BOOL loopEnabled;

/// Setting this to `YES` will present a HUD whenever the user goes from the last image to the
/// first one. Defaults to `YES`.
/// @note This propery has no effect if `loopEnabled` is set to `NO`.
@property (nonatomic, assign, getter=isLoopHUDEnabled) BOOL loopHUDEnabled;

/// @name State

/// The current state.
@property (nonatomic, assign, readonly) PSPDFGalleryViewControllerState state;

/// All `PSPDFGalleryItems` of this gallery. Only set if state is `PSPDFGalleryViewControllerStateReady`.
@property (nonatomic, copy, readonly) NSArray *items;

/// The link annotation that was used to instanciate the view controller.
@property (nonatomic, strong, readonly) PSPDFLinkAnnotation *linkAnnotation;

/// Used to enter or exit the fullscreen mode.
@property (nonatomic, assign, getter=isFullscreen) BOOL fullscreen;

/// Indicates if the view controller is currently transitioning between display modes, that
/// is if the controller is moving from fullscreen to embedded or vice versa.
@property (nonatomic, assign, getter=isTransitioningDisplayMode) BOOL transitioningDisplayMode;

/// Used to enter or exit the fullscreen mode with or without animation.
/// @warning If you use this property programmatically, you must set it to `NO` once
/// you're done with your instance of `PSPDFGalleryViewController`!
- (void)setFullscreen:(BOOL)fullscreen animated:(BOOL)animated;

/// The current zoom scale. Only valid when displayed as an embedded gallery within a PDF document.
/// Defaults to 1.0.
@property (nonatomic, assign) CGFloat zoomScale;

// @name Gesture Recognizers

/// Single-Tap: Show/Hide image description.
@property (nonatomic, strong, readonly) UITapGestureRecognizer *singleTapGestureRecognizer;

/// Double-Tap: Toggle Full-Screen.
@property (nonatomic, strong, readonly) UITapGestureRecognizer *doubleTapGestureRecognizer;

/// Pan: Dismiss Full-Screen mode.
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGestureRecognizer;

/// @name Utility

/// Returns the current `PSPDFMediaPlayerController` if a video is currently visible. Returns `nil` otherwise.
- (PSPDFMediaPlayerController *)currentMediaPlayerController;

@end

@interface PSPDFGalleryViewController (Private)

@property (nonatomic, weak) UIViewController <PSPDFOverridable> *overridableParentViewController;

@end

@interface PSPDFGalleryViewController (Deprecated)

@property (nonatomic, strong) UIColor *backgroundColor PSPDF_DEPRECATED(3.7.0, "Use backgroundColor on PSPDFGalleryEmbeddedBackgroundView instead.");
@property (nonatomic, assign) BOOL blurBackground PSPDF_DEPRECATED(3.7.0, "Use blurBackground on PSPDFGalleryEmbeddedBackgroundView instead.");
@property (nonatomic, strong) UIColor *fullscreenBackgroundColor PSPDF_DEPRECATED(3.7.0, "Use backgroundColor on PSPDFGalleryFullscreenBackgroundView instead.");

@end

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
#import "PSPDFOverridable.h"
#import "PSPDFPlugin.h"
#import "PSPDFMultimediaViewController.h"

@class PSPDFLinkAnnotation, PSPDFMediaPlayerController, PSPDFGalleryConfiguration;

typedef NS_ENUM(NSUInteger, PSPDFGalleryViewControllerState) {
    /// The view controller is currently not doing anything.
    PSPDFGalleryViewControllerStateIdle,

    /// The manifest file is currently downloaded.
    PSPDFGalleryViewControllerStateLoading,

    /// The manifest file has been downloaded and the view controller is ready.
    PSPDFGalleryViewControllerStateReady,

    /// The view controller could not load or parse the manifest file.
    PSPDFGalleryViewControllerStateError
};

@class PSPDFGalleryViewController;

/// Handles a gallery of one or multiple images.
@interface PSPDFGalleryViewController : PSPDFBaseViewController <PSPDFOverridable, PSPDFPlugin, PSPDFMultimediaViewController>

/// Create a new gallery view controller by passing in the plugin registry and an options dictionary.
/// The options dictionary must contain the key `PSPDFMultimediaLinkAnnotationKey` that maps to an
/// `PSPDFLinkAnnotation` object.
- (instancetype)initWithPluginRegistry:(PSPDFPluginRegistry *)pluginRegistry options:(NSDictionary *)options NS_DESIGNATED_INITIALIZER;

/// Create a new gallery view controller by passing in a link annotation.
- (instancetype)initWithLinkAnnotation:(PSPDFLinkAnnotation *)linkAnnotation;

/// The configuration. Defaults to `+[PSPDFGalleryConfiguration defaultConfiguration]`.
/// @warning You cannot set this property to `nil` since a gallery must always have a configuration.
@property (nonatomic, strong) PSPDFGalleryConfiguration *configuration;

/// @name State

/// The current state.
@property (nonatomic, assign, readonly) PSPDFGalleryViewControllerState state;

/// All `PSPDFGalleryItems` of this gallery. Only set if state is `PSPDFGalleryViewControllerStateReady`.
@property (nonatomic, copy, readonly) NSArray *items;

/// The link annotation that was used to instantiate the view controller.
@property (nonatomic, strong, readonly) PSPDFLinkAnnotation *linkAnnotation;

/// Used to enter or exit the fullscreen mode.
@property (nonatomic, assign, getter=isFullscreen) BOOL fullscreen;

/// Indicates if the view controller is currently transitioning between display modes, that
/// is if the controller is moving from fullscreen to embedded or vice versa.
@property (nonatomic, assign, getter=isTransitioning) BOOL transitioning;

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

@end

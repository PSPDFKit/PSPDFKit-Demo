//
//  PSPDFGalleryViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFBaseViewController.h"
#import "PSPDFGalleryItem.h"

@class PSPDFLinkAnnotation;

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

/// Handles a gallery of images.
@interface PSPDFGalleryViewController : PSPDFBaseViewController <PSPDFOverridable>

/// Create a new gallery view controller by passing in a link annotation with linkAnnotationType set to PSPDFLinkAnnotationGallery.
- (instancetype)initWithLinkAnnotation:(PSPDFLinkAnnotation *)annotation;

/// @name Configuration

/// The max. number of concurrent downlaods. Defaults to 2. Must at least be 1.
@property (nonatomic, assign) NSUInteger maxConcurrentDownloads;

/// The max. number of images after the currently visible one that should be prefetched. Defaults to 5.
/// To disable prefetching, set this to zero.
@property (nonatomic, assign) NSUInteger maxPrefetchDownloads;

/// Control if the user can enter the fullscreen mode by double-tapping. Defaults to YES.
/// @note This only affects user interaction. If you call setFullscreen:YES manually, the fullscreen mode will
/// still be entered.
@property (nonatomic, assign) BOOL allowFullscreen;

/// The treshold in points after which the fullscreen mode is exited after a pan. Defaults to 80pt.
@property (nonatomic, assign) CGFloat fullscreenDismissPanTreshold;

/// @name State

/// The current state.
@property (nonatomic, assign, readonly) PSPDFGalleryViewControllerState state;

/// All PSPDFGalleryItems of this gallery. Only set if state is PSPDFGalleryViewControllerStateReady.
@property (nonatomic, copy, readonly) NSArray *items;

/// The link annotation that was used to instanciate the view controller.
@property (nonatomic, strong, readonly) PSPDFLinkAnnotation *linkAnnotation;

/// Used to enter or exit the fullscreen mode.
@property (nonatomic, assign, getter = isFullscreen) BOOL fullscreen;

/// Used to enter or exit the fullscreen mode with or without animation.
- (void)setFullscreen:(BOOL)fullscreen animated:(BOOL)animated;

@end

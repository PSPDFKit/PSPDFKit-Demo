//
//  PSPDFGalleryConfiguration.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

@class PSPDFGalleryConfigurationBuilder;

/// A `PSPDFGalleryConfiguration` defines the behavior of a `PSPDFGalleryViewController`.
@interface PSPDFGalleryConfiguration : NSObject

/// Returns a copy of the default gallery configuration.
+ (instancetype)defaultConfiguration;

/// Returns a copy of the default gallery configuration. You can provide a `builderBlock` to change
/// the value of properties.
+ (instancetype)configurationWithBuilder:(void (^)(PSPDFGalleryConfigurationBuilder *))builderBlock;

/// The max. number of concurrent downloads. Defaults to 2. Must at least be 1.
@property (nonatomic, assign, readonly) NSUInteger maximumConcurrentDownloads;

/// The max. number of images after the currently visible one that should be prefetched. Defaults to 3.
/// To disable prefetching, set this to zero.
@property (nonatomic, assign, readonly) NSUInteger maximumPrefetchDownloads;

/// Controls if the user can switch between the fullscreen mode and embedded mode by double-tapping
/// or panning. Defaults to `YES`.
/// @note This only affects user interaction. If you call `setFullscreen:animated:` programmatically,
/// the mode will still be set accordingly.
@property (nonatomic, assign, readonly) BOOL displayModeUserInteractionEnabled;

/// The threshold in points after which the fullscreen mode is exited after a pan. Defaults to 80pt.
@property (nonatomic, assign, readonly) CGFloat fullscreenDismissPanThreshold;

/// Set this to YES if zooming should be enabled in fullscreen mode. Defaults to YES.
@property (nonatomic, assign, readonly, getter=isFullscreenZoomEnabled) BOOL fullscreenZoomEnabled;

/// The maximum zoom scale that you want to allow. Only meaningful if `fullscreenZoomEnabled` is YES
/// Defaults to 20.0.
@property (nonatomic, assign, readonly) CGFloat maximumFullscreenZoomScale;

/// The minimum zoom scale that you want to allow. Only meaningful if `fullscreenZoomEnabled` is YES.
/// Defaults to 1.0.
@property (nonatomic, assign, readonly) CGFloat minimumFullscreenZoomScale;

/// Controls if the gallery should loop infinitely, that is if the user can keep scrolling forever
/// and the content will repeat itself. Defaults to `YES`. Ignored if there's only one item set.
@property (nonatomic, assign, readonly, getter=isLoopEnabled) BOOL loopEnabled;

/// Setting this to `YES` will present a HUD whenever the user goes from the last image to the
/// first one. Defaults to `YES`.
/// @note This property has no effect if `loopEnabled` is set to `NO`.
@property (nonatomic, assign, readonly, getter=isLoopHUDEnabled) BOOL loopHUDEnabled;

@end

@interface PSPDFGalleryConfigurationBuilder : NSObject

@property (nonatomic, assign) NSUInteger maximumConcurrentDownloads;
@property (nonatomic, assign) NSUInteger maximumPrefetchDownloads;
@property (nonatomic, assign) BOOL displayModeUserInteractionEnabled;
@property (nonatomic, assign) CGFloat fullscreenDismissPanThreshold;
@property (nonatomic, assign) BOOL fullscreenZoomEnabled;
@property (nonatomic, assign) CGFloat maximumFullscreenZoomScale;
@property (nonatomic, assign) CGFloat minimumFullscreenZoomScale;
@property (nonatomic, assign) BOOL loopEnabled;
@property (nonatomic, assign) BOOL loopHUDEnabled;

@end

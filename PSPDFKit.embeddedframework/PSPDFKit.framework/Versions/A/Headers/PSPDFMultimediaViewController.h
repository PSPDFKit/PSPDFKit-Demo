//
//  PSPDFMultimediaViewController.h
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
#import <CoreGraphics/CoreGraphics.h>

@class PSPDFAction;
@protocol PSPDFOverridable;

/// A key in the `options` dictionary when initializing a multimedia plugin. Maps to the `PSPDFLinkAnnotation`
/// that should be used for the multimedia content.
extern NSString *const PSPDFMultimediaLinkAnnotationKey;

/// A protocol that defines the interface that multimedia view controller plugins must conform to.
/// @warning The class that implements this protocol must be a `UIViewController` subclass!
@protocol PSPDFMultimediaViewController <NSObject>

/// Indicates if the controller is currently in fullscreen mode or changes the state.
@property (nonatomic, assign, getter=isFullscreen) BOOL fullscreen;
- (void)setFullscreen:(BOOL)fullscreen animated:(BOOL)animated;

/// Indicates if the controller is transitiioning between fullscreen and embedded mode.
@property (nonatomic, assign, getter=isTransitioning) BOOL transitioning;

/// The zoom scale at which the controller is presented.
@property (nonatomic, assign) CGFloat zoomScale;

/// The delegate that can be used to override classes.
@property (nonatomic, weak) id<PSPDFOverridable> overrideDelegate;

/// Called when a multimedia action (either `PSPDFRenditionAction` or `PSPDFRichMediaExecuteAction`)
/// should be performed.
- (void)performAction:(PSPDFAction *)action;

@end

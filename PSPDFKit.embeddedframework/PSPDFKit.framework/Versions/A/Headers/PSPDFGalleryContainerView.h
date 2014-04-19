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

@class PSPDFGalleryView, PSPDFGalleryErrorView, PSPDFGalleryLoadingView, PSPDFStatusHUDView;

// The following dummy classes are created to allow specific UIAppearance targeting. They do not
// have any functionality besides that.
@interface PSPDFGalleryEmbeddedBackgroundView : PSPDFBlurView @end
@interface PSPDFGalleryFullscreenBackgroundView : PSPDFBlurView @end

/// Used to group the error, loading and gallery view and to properly lay them out.
@interface PSPDFGalleryContainerView : UIView

/// The gallery view. Will not be created by this view but must be set.
@property (nonatomic, strong) PSPDFGalleryView *galleryView;

/// The error view. Will not be created by this view but must be set.
@property (nonatomic, strong) PSPDFGalleryErrorView *errorView;

/// The loading view. Will not be created by this view but must be set.
@property (nonatomic, strong) PSPDFGalleryLoadingView *loadingView;

/// The background view.
@property (nonatomic, strong) PSPDFGalleryEmbeddedBackgroundView *backgroundView;

/// The fullscreen background view.
@property (nonatomic, strong) PSPDFGalleryFullscreenBackgroundView *fullscreenBackgroundView;

/// The status HUD view.
@property (nonatomic, strong) PSPDFStatusHUDView *statusHUDView;

/// Contains `galleryView`, `errorView` and `loadingView`. This view is only used to group all
/// content views together.
@property (nonatomic, strong, readonly) UIView *contentContainerView;

@end

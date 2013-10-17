//
//  PSPDFGalleryContainerView.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

@class PSPDFGalleryView, PSPDFGalleryErrorView, PSPDFGalleryLoadingView;

/// Used to group the error, loading and gallery view and to properly lay them out.
@interface PSPDFGalleryContainerView : UIView

/// The gallery view. Will not be created by this view but must be set.
@property (nonatomic, strong) PSPDFGalleryView *galleryView;

/// The error view. Will not be created by this view but must be set.
@property (nonatomic, strong) PSPDFGalleryErrorView *errorView;

/// The loading view. Will not be created by this view but must be set.
@property (nonatomic, strong) PSPDFGalleryLoadingView *loadingView;

@end

//
//  PSPDFGalleryScrollableContentView.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFGalleryContentView.h"

@interface PSPDFGalleryScrollableContentView : PSPDFGalleryContentView

/// Set this to YES if zooming should be enabled. This value only has an effect if an image
/// is currently displayed. Defaults to NO.
@property (nonatomic, assign, getter = isZoomEnabled) BOOL zoomEnabled;

/// The maximum zoom scale that you want to allow. Only meaningful if zoomEnabled is YES.
/// Defaults to 5.0.
@property (nonatomic, assign) CGFloat maximumZoomScale;

/// The minimum zoom scale that you want to allow. Only meaningful if zoomEnabled is YES.
/// Defaults to 1.0.
@property (nonatomic, assign) CGFloat minimumZoomScale;

/// The current zoom scale. This is only meaningful if zoomEnabled is YES. Defaults to 1.0.
@property (nonatomic, assign) CGFloat zoomScale;

/// Sets the current zoom scale, but only if zoomEnabled is YES and
/// minimumZoomScale <= zoomScale <= maximumZoomScale is true.
- (void)setZoomScale:(CGFloat)zoomScale animated:(BOOL)animated;

@end

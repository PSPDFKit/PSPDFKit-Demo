//
//  PSPDFGalleryAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFLinkAnnotationBaseView.h"

@class PSPDFGalleryViewController;

/// Acts as the container view for an image gallery.
/// @note To get a basic image view without the gallery tap handling, simply set `userInteractionEnabled = NO` on this view.
@interface PSPDFGalleryAnnotationView : PSPDFLinkAnnotationBaseView

/// The gallery's view controller.
@property (nonatomic, strong, readonly) PSPDFGalleryViewController *galleryViewController;

/// Associated weak reference to then `PSPDFPageView`.
@property (nonatomic, weak) PSPDFPageView *pageView;

@end

@interface PSPDFGalleryAnnotationView (SubclassingHooks)

// Will create and set up the internal gallery view controller.
- (PSPDFGalleryViewController *)createGalleryViewController;

@end

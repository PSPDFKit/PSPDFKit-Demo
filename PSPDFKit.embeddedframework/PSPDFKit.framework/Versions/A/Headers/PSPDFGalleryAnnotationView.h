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

#import "PSPDFLinkAnnotationBaseView.h"

@class PSPDFGalleryViewController;

/// Acts as the container view for an image gallery.
@interface PSPDFGalleryAnnotationView : PSPDFLinkAnnotationBaseView

/// The gallery's view controller.
@property (nonatomic, strong, readonly) PSPDFGalleryViewController *galleryViewController;

@end

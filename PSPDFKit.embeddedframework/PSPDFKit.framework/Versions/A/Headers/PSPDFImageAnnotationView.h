//
//  PSPDFImageAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFLinkAnnotationBaseView.h"

// Allow setting a contentMode in setting parameters -> sets the UIViewContentMode of the UIImageView.
#define PSPDFImageContentMode @"contentMode"

/// Shows a single UIImageView.
@interface PSPDFImageAnnotationView : PSPDFLinkAnnotationBaseView

/// Image URL (to a local resource)
@property (nonatomic, strong) NSURL *URL;

/// Direct access to the ImageView.
@property (nonatomic, strong, readonly) UIImageView *imageView;

@end

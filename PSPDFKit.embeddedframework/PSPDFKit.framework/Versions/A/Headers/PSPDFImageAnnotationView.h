//
//  PSPDFImageAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFLinkAnnotationBaseView.h"

// Allow setting a contentMode in setting parameters -> sets the UIViewContentMode of the UIImageView.
#define kPSPDFImageContentMode @"contentMode"

/// Shows a single UIImageView.
@interface PSPDFImageAnnotationView : PSPDFLinkAnnotationBaseView

/// Image URL (to a local resource)
@property (nonatomic, strong) NSURL *URL;

/// Direct access to the ImageView.
@property (nonatomic, strong, readonly) UIImageView *imageView;

@end

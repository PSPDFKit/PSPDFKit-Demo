//
//  PSPDFImageAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//  Thanks to Niklas Saers / Trifork A/S for the contribution.
//

#import "PSPDFAnnotationView.h"

/// Shows a single UIImageView.
@interface PSPDFImageAnnotation : UIView <PSPDFAnnotationView>

/// Image URL (to a local resource)
@property(nonatomic, strong) NSURL *URL;

/// Direct access to the ImageView.
@property(nonatomic, strong, readonly) UIImageView *imageView;

@end

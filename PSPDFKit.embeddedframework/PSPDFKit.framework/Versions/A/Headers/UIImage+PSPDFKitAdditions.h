//
//  UIImage+PSPDFKitAdditions.h
//  PSPDFKit
//
//  Copyright 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

// Note: If you see an error like "Terminating app due to uncaught exception 'NSInvalidArgumentException"
// you've missed adding the linker flag -ObjC.

extern CGColorSpaceRef pspdf_colorSpace;

@interface UIImage (PSPDFKitAdditions)

typedef NS_ENUM(NSInteger, PSPDFImageResizingMethod) {
    PSPDFImageResizeCrop,	// analogous to UIViewContentModeScaleAspectFill, i.e. "best fit" with no space around.
    PSPDFImageResizeCropStart,
    PSPDFImageResizeCropEnd,
    PSPDFImageResizeScale	// analogous to UIViewContentModeScaleAspectFit, i.e. scale down to fit, leaving space around if necessary.
};

/// Returns a new image that is resize to fitSize.
- (UIImage *)pspdf_imageToFitSize:(CGSize)fitSize method:(PSPDFImageResizingMethod)resizeMethod honorScaleFactor:(BOOL)honorScaleFactor opaque:(BOOL)opaque;

/// Load images via path, looking automatically for a @2x option.
- (id)initWithContentsOfResolutionIndependentFile_pspdf:(NSString *)path;

/// Creates a new images that is already preloaded to draw on screen.
+ (UIImage *)pspdf_preloadedImageWithContentsOfFile:(NSString *)path;

/// Creates a new image that is optimized for the screen. (ARGB, not ABGR)
- (UIImage *)pspdf_preloadedImage;

/// Creates a new image that is eventually decompressed..
+ (UIImage *)pspdf_preloadedImageWithData:(NSData *)data;

/// Tint an image.
- (UIImage *)pdpdf_imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction;

/// Loads an animated GIF. iOS5 upwards.
/// This supports basic animated GIF with a equal animation delay.
/// For a more perfect solution, use https://github.com/ondalabs/OLImageView.
+ (UIImage *)pspdf_animatedGIFWithPath:(NSString *)path;

@end

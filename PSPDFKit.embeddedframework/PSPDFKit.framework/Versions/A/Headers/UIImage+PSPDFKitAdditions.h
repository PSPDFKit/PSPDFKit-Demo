//
//  UIImage+PSPDFKitAdditions.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

extern CGColorSpaceRef pspdf_colorSpace;

@interface UIImage (PSPDFKitAdditions)

/// Returns a new image that is resize to bounds.
/// Supported content modes: UIViewContentModeScaleAspectFill, UIViewContentModeScaleAspectFit, UIViewContentModeScaleToFill.
/// if `honorScaleFactor` is set to NO, resulting image will not be retina scaled.
- (UIImage *)pspdf_resizedImageWithContentMode:(UIViewContentMode)contentMode
        bounds:(CGSize)bounds
        honorScaleFactor:(BOOL)honorScaleFactor
        interpolationQuality:(CGInterpolationQuality)quality;

/// Load images via path, looking automatically for a @2x option.
- (id)initWithContentsOfResolutionIndependentFile_pspdf:(NSString *)path;

/// Creates a new images that is already preloaded to draw on screen.
+ (UIImage *)pspdf_preloadedImageWithContentsOfFile:(NSString *)path;

/// Creates a new image that is optimized for the screen. (ARGB, not ABGR)
- (UIImage *)pspdf_preloadedImage;

/// Creates a new image that is eventually decompressed..
+ (UIImage *)pspdf_preloadedImageWithData:(NSData *)data;

/// Tint an image.
- (UIImage *)pspdf_imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction;

/// Loads an animated GIF. iOS5 upwards.
/// This supports basic animated GIF with a equal animation delay.
/// For a more perfect solution, use https://github.com/ondalabs/OLImageView.
+ (UIImage *)pspdf_animatedGIFWithPath:(NSString *)path;

/// CropRect is assumed to be in UIImageOrientationUp, as it is delivered this way from the UIImagePickerController when using AllowsImageEditing is on.
/// The sourceImage can be in any orientation, the crop will be transformed to match
/// The output image bounds define the final size of the image, the image will be scaled to fit,(AspectFit) the bounds, the fill color will be used for areas that are not covered by the scaled image.
/// This method is especially useful when dealing with UIImagePickerControllerCropRect.
- (UIImage *)pspdf_cropImageWithCropRect:(CGRect)cropRect aspectFitBounds:(CGSize)finalImageSize fillColor:(UIColor *)fillColor;

@end

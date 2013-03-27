//
//  PSPDFIconGenerator.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

/// Applies the barButton shadow if style is UIBarButtonItemStyleBorder.
/// This is not needed, UIBarButtonItemStylePlain is managed by the system.
extern UIImage *PSPDFApplyToolbarShadowToImage(UIImage *oldImage);

typedef NS_ENUM(NSInteger, PSPDFIconType) {
    PSPDFIconTypeOutline,
    PSPDFIconTypePage,
    PSPDFIconTypeThumbnails,
    PSPDFIconTypeBackArrow,
    PSPDFIconTypeBackArrowSmall,
    PSPDFIconTypeForwardArrow,
    PSPDFIconTypePrint,
    PSPDFIconTypeEmail,
    PSPDFIconTypeAnnotations,
    PSPDFIconTypeBookmark,
    PSPDFIconTypeBookmarkActive
};

/// Generates various icons on the fly and caches them for later use.
@interface PSPDFIconGenerator : NSObject

/// Access singleton.
/// @note can be overridden with changing global kPSPDFIconGeneratorClassName.
+ (instancetype)sharedGenerator;

/// Generates in-code images on the fly. Cached, Thread-safe.
- (UIImage *)iconForType:(PSPDFIconType)iconType;

/// Generates image on the fly, applies button shadow if needed. Thread-safe.
- (UIImage *)iconForType:(PSPDFIconType)iconType barButtonStyle:(UIBarButtonItemStyle)style;

/// Generates in-code images on the fly. Thread-safe. Uses custom shadow settings.
- (UIImage *)iconForType:(PSPDFIconType)iconType shadowOffset:(CGSize)shadowOffset shadowColor:(UIColor *)shadowColor;

@end

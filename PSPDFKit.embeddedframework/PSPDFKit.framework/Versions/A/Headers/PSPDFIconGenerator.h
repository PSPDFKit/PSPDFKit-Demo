//
//  PSPDFIconGenerator.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

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
    PSPDFIconTypeBookmarkActive,
    PSPDFIconTypeBrightness
};

/// Generates various Icons on the fly and caches them for later use.
@interface PSPDFIconGenerator : NSObject

/// Access singleton. Note: can be overridden with changing global kPSPDFIconGeneratorClassName.
+ (PSPDFIconGenerator *)sharedGenerator;

/// Generates in-code images on the fly. Cached, Thread-safe.
- (UIImage *)iconForType:(PSPDFIconType)iconType;

/// Generates in-code images on the fly. Thread-safe. Uses custom shadow settings.
- (UIImage *)iconForType:(PSPDFIconType)iconType shadowOffset:(CGSize)shadowOffset shadowColor:(UIColor *)shadowColor;

@end

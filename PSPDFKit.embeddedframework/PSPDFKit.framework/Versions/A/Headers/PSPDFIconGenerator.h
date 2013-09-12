//
//  PSPDFIconGenerator.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

/// Applies the barButton shadow if style is UIBarButtonItemStyleBorder.
/// This is not needed, UIBarButtonItemStylePlain is managed by the system.
/// @note As of iOS7, this is a NOP and will simply return `oldImage`.
extern UIImage *PSPDFApplyToolbarShadowToImage(UIImage *oldImage);

// Can be used to use a custom subclass of the PSPDFIconGenerator. Defaults to nil, which will use PSPDFIconGenerator.class.
// Set very early (in your AppDelegate) before you access PSPDFKit. Will be used to create the singleton.
extern Class PSPDFIconGeneratorClass;

typedef NS_ENUM(NSInteger, PSPDFIconType) {
    PSPDFIconTypeOutline,
    PSPDFIconTypePage,
    PSPDFIconTypeThumbnails,
    PSPDFIconTypeBackArrow,
    PSPDFIconTypeBackArrowSmall,
    PSPDFIconTypeForwardArrow,
    PSPDFIconTypeEmail,
};

/// Generates various icons on the fly and caches them for later use.
@interface PSPDFIconGenerator : NSObject

/// Access singleton.
/// @note can be overridden with changing global PSPDFIconGeneratorClassName.
+ (instancetype)sharedGenerator;

/// Generates in-code images on the fly. Cached, Thread-safe.
- (UIImage *)iconForType:(PSPDFIconType)iconType;

/// Generates image on the fly, applies button shadow if needed. Thread-safe.
- (UIImage *)iconForType:(PSPDFIconType)iconType barButtonStyle:(UIBarButtonItemStyle)style;

/// Generates in-code images on the fly. Thread-safe. Uses custom shadow settings.
- (UIImage *)iconForType:(PSPDFIconType)iconType shadowOffset:(CGSize)shadowOffset shadowColor:(UIColor *)shadowColor;

@end

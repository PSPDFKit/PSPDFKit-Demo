//
//  PSPDFAnnotationGroupItem.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

@class PSPDFAnnotationGroupItem;
typedef UIImage *(^PSPDFAnnotationGroupItemConfigurationBlock)(PSPDFAnnotationGroupItem *item, id container, UIColor *tintColor);

extern NSString * const PSPDFAnnotationStringInkVariantPen;
extern NSString * const PSPDFAnnotationStringInkVariantHighlighter;
extern NSString * const PSPDFAnnotationStringFreeTextVariantCallout;

// Simple helper that combines a state + variant into a new identifier.
// Can be used to set custom types in the `PSPDFStyleManager`.
extern NSString *PSPDFAnnotationStateVariantIdentifier(NSString *state, NSString *variant);

/// An annotation group items defines one annotation type, optionally with a variant.
@interface PSPDFAnnotationGroupItem : NSObject

/// Creates a group item with the specified annotation type.
/// @see itemWithType:variant:configurationBlock:
+ (instancetype)itemWithType:(NSString *)type;

/// Creates a group item with the specified annotation type and optional variant identifier.
/// @see itemWithType:variant:configurationBlock:
+ (instancetype)itemWithType:(NSString *)type variant:(NSString *)variant;

/// Creates a group item with the specified annotation type, an optional variant identifier and configuration block.
/// @param type The annotation type. See `PSPDFAnnotation.h` for a list of valid types.
/// @param variant An optional string identifier for the item variant. Use variants to add several instances of the same tool with uniquely preservable annotation style settings.
/// @param block An option block, that should return the button's image. If nil, `defaultConfigurationBlock` is used.
/// @note Whenever possible try to return a template image from the configuration block (UIImageRenderingModeAlwaysTemplate). Use the provided tint color only to when you need multi-color images.
+ (instancetype)itemWithType:(NSString *)type variant:(NSString *)variant configurationBlock:(PSPDFAnnotationGroupItemConfigurationBlock)block;

/// A block that configures an preset image based on the annotation type.
/// This is the default configuration block.
+ (PSPDFAnnotationGroupItemConfigurationBlock)defaultConfigurationBlock;

/// Produces the default Ink annotation icon, which includes the currently set ink color and thickness.
/// Only supported for Ink annotation types.
+ (PSPDFAnnotationGroupItemConfigurationBlock)inkConfigurationBlock;

/// Allows to configure the `PSPDFAnnotationStringFreeTextVariantCallout` option of `PSPDFAnnotationStringFreeText`.
+ (PSPDFAnnotationGroupItemConfigurationBlock)freeTextConfigurationBlock;

/// The set annotation type. See `PSPDFAnnotation.h` for a list of valid types.
@property (nonatomic, copy, readonly) NSString *type;

/// The annotation variant, if set during initialization.
@property (nonatomic, copy, readonly) NSString *variant;

/// Used to generate the annotation image. Will be `defaultConfigurationBlock` or `inkConfigurationBlock` in most cases.
@property (nonatomic, copy, readonly) PSPDFAnnotationGroupItemConfigurationBlock configurationBlock;

@end

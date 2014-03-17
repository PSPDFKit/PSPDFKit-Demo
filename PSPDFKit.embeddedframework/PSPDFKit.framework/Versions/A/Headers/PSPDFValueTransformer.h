//
//  PSPDFValueTransformer.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//  Based on GitHub's Mantle project, MIT licensed.
//

#import <Foundation/Foundation.h>

/// A value transformer supporting block-based transformation.
@interface PSPDFValueTransformer : NSValueTransformer

/// Returns a transformer which transforms values using the given block. Reverse
/// transformations will not be allowed.
+ (instancetype)transformerWithBlock:(id (^)(id))transformationBlock;

/// Returns a transformer which transforms values using the given block, for
/// forward or reverse transformations.
+ (instancetype)reversibleTransformerWithBlock:(id (^)(id))transformationBlock;

/// Returns a transformer which transforms values using the given blocks.
+ (instancetype)reversibleTransformerWithForwardBlock:(id (^)(id))forwardBlock reverseBlock:(id (^)(id))reverseBlock;

/// Returns a transformer that translates with `dictionary` and optionally returns `defaultValue`.
+ (instancetype)transformerWithDictionary:(NSDictionary *)dictionary defaultValue:(id)defaultValue unknownValue:(id)unknownValue;

/// Returns a value transformer and executes the block to create the transformer if not found.
+ (NSValueTransformer *)valueTransformerForName:(NSString *)name createBlock:(NSValueTransformer *(^)())createBlock;

@end

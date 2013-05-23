//
//  PSPDFValueTransformer.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//  Based on GitHub's Mantle project, MIT licensed.
//

#import <Foundation/Foundation.h>

typedef id (^PSPDFValueTransformerBlock)(id);

///
/// A value transformer supporting block-based transformation.
///
@interface PSPDFValueTransformer : NSValueTransformer

/// Returns a transformer which transforms values using the given block. Reverse
/// transformations will not be allowed.
+ (instancetype)transformerWithBlock:(PSPDFValueTransformerBlock)transformationBlock;

/// Returns a transformer which transforms values using the given block, for
/// forward or reverse transformations.
+ (instancetype)reversibleTransformerWithBlock:(PSPDFValueTransformerBlock)transformationBlock;

/// Returns a transformer which transforms values using the given blocks.
+ (instancetype)reversibleTransformerWithForwardBlock:(PSPDFValueTransformerBlock)forwardBlock reverseBlock:(PSPDFValueTransformerBlock)reverseBlock;

@end

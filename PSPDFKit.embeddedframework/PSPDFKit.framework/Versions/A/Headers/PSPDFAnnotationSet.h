//
//  PSPDFAnnotationSet.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFModel.h"

@class PSPDFAnnotation;

/// An annotation set allows to add and position multiple annotations.
@interface PSPDFAnnotationSet : PSPDFModel <NSFastEnumeration>

/// Designated initializer. `annotations` will be a deep copy of the current annotations.
/// The `boundingBox` of the annotations will be normalized. (upper left one will have 0,0 origin)
- (id)initWithAnnotations:(NSArray *)annotations;

/// The saved annotations.
@property (nonatomic, copy, readonly) NSArray *annotations;

/// Draw all annotations.
- (void)drawInContext:(CGContextRef)context withOptions:(NSDictionary *)options;

/// @name Frames

/// Bounding box of all annotations. If set, will correctly resize all annotations.
@property (nonatomic, assign) CGRect boundingBox;

/// @name Clipboard

/// Copies the current set to the clipboard.
- (void)copyToClipboard;

/// Loads a PSPDFAnnotationSet from the clipboard.
/// @note Also supports legacy format and will automatically pack it into a PSPDFAnnotationSet.
+ (instancetype)unarchiveFromClipboard;

@end

//
//  PSPDFAnnotationStyle.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFModel.h"
@class PSPDFAnnotation;

/// Defines an annotation style.
@interface PSPDFAnnotationStyle : PSPDFModel

/// Initializer.
- (id)initWithName:(NSString *)styleName;

/// The name of the annotation style.
@property (atomic, copy) NSString *styleName;

/// Key/Value pairs of style settings that should be applied to the object.
@property (atomic, copy) NSDictionary *styleDictionary;

/// Populates the styleDictionary. use nil for `style` to remove a value
- (void)setStyle:(id)style forKey:(NSString *)key;

/// Applies all applicable style attribute to the annotation. Matching is done via property name comparison.
- (void)applyStyleToAnnotation:(PSPDFAnnotation *)annotation;

@end

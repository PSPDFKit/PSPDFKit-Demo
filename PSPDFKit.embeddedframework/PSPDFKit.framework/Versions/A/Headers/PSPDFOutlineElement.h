//
//  PSPDFOutlineElement.h
//  PSPDFKit
//
//  Copyright 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFBookmark.h"

///
/// Represents a single outline/table of contents element.
///
@interface PSPDFOutlineElement : PSPDFBookmark

/// Init with title, page, child elements and indentation level.
- (id)initWithTitle:(NSString *)title page:(NSUInteger)page relativePath:(NSString *)relativePath children:(NSArray *)children level:(NSUInteger)level;

/// Returns all elements + flattened subelements if they are expanded
- (NSArray *)flattenedChildren;

/// All elements, ignores expanded state.
- (NSArray *)allFlattenedChildren;

/// Outline title.
@property (nonatomic, copy) NSString *title;

/// Set if outline to a different PDF document. Path is relative to current document.
@property (nonatomic, copy) NSString *relativePath;

/// Child elements.
@property (nonatomic, copy, readonly) NSArray *children;

/// Current outline level.
@property (nonatomic, assign) NSUInteger level;

/// Expansion state of current outline element.
@property (nonatomic, assign, getter=isExpanded) BOOL expanded;

/// PDF destination name.
/// @warning If 'destinationName' is set, the target page hasn't yet been resolved.
/// Use PSPDFOutlineParser to resolve a destination name.
@property (nonatomic, copy) NSString *destinationName;

@end

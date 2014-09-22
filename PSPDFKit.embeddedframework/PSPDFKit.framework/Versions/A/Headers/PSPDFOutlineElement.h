//
//  PSPDFOutlineElement.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBookmark.h"

/// Represents a single outline/table of contents element.
@interface PSPDFOutlineElement : PSPDFBookmark

/// Init with title, page, child elements and indentation level.
- (instancetype)initWithTitle:(NSString *)title color:(UIColor *)color fontTraits:(UIFontDescriptorSymbolicTraits)fontTraits action:(PSPDFAction *)action children:(NSArray *)children level:(NSUInteger)level NS_DESIGNATED_INITIALIZER;

/// Returns all elements + flattened subelements if they are expanded
- (NSArray *)flattenedChildren;

/// All elements, ignores expanded state.
- (NSArray *)allFlattenedChildren;

/// Outline title.
@property (nonatomic, copy, readonly) NSString *title;

/// Bookmark can have a color. Defaults to system text color if not set. (Optional; PDF 1.4)
@property (nonatomic, strong, readonly) UIColor *color;

/// A bookmark can be optionally bold or italic. (Optional; PDF 1.4)
@property (nonatomic, assign, readonly) UIFontDescriptorSymbolicTraits fontTraits;

/// Child elements.
@property (nonatomic, copy, readonly) NSArray *children;

/// Current outline level.
@property (nonatomic, assign, readonly) NSUInteger level;

/// Expansion state of current outline element (will not be persisted)
@property (nonatomic, assign, getter=isExpanded) BOOL expanded;

@end

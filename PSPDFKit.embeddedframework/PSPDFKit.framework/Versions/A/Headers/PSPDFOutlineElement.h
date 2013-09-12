//
//  PSPDFOutlineElement.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBookmark.h"

/// Represents a single outline/table of contents element.
@interface PSPDFOutlineElement : PSPDFBookmark

/// Init with title, page, child elements and indentation level.
- (id)initWithTitle:(NSString *)title action:(PSPDFAction *)action children:(NSArray *)children level:(NSUInteger)level;

/// Returns all elements + flattened subelements if they are expanded
- (NSArray *)flattenedChildren;

/// All elements, ignores expanded state.
- (NSArray *)allFlattenedChildren;

/// Outline title.
@property (nonatomic, copy) NSString *title;

/// Child elements.
@property (nonatomic, readonly) NSArray *children;

/// Current outline level.
@property (nonatomic, assign) NSUInteger level;

/// Expansion state of current outline element (will not be persisted)
@property (nonatomic, assign, getter=isExpanded) BOOL expanded;

@end

//
//  PSPDFWord.h
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

/// Represents a word. Formed out of (usually) multiple glyphs.
@interface PSPDFWord : NSObject <NSCopying, NSCoding>

/// Initialize with glyphs (PSPDFGlyph).
/// As an optimizations, only the first and last glyph will be used for frame calculations.
- (id)initWithGlyphs:(NSArray *)wordGlyphs;

/// Initialize with word frame.
- (id)initWithFrame:(CGRect)wordFrame;

/// Returns the content of the word (all glyphs merged together)
- (NSString *)stringValue;

/// All glyphs merged together in the smallest possible bounding box.
@property (nonatomic, assign) CGRect frame;

/// All PSPDFGlyph objects.
/// Frame will be recalculated when glyphs are set.
@property (nonatomic, copy) NSArray *glyphs;

/// Set to YES if this is the last word on a textBlock.
@property (nonatomic, assign) BOOL lineBreaker;

/// Tests if word is approximately on the same horizontal line as the other word.
- (BOOL)isOnSameLineAs:(PSPDFWord *)word;

// Helper to sort the lines: top->down, left->right
- (NSComparisonResult)compareByLayout:(PSPDFWord *)word;

/// Compare.
- (BOOL)isEqualToWord:(PSPDFWord *)otherWord;

@end

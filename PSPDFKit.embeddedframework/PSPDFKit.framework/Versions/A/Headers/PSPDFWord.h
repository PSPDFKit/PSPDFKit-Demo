//
//  PSPDFWord.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

/// Represents a word. Formed out of (usually) multiple glyphs.
@interface PSPDFWord : NSObject <NSCopying, NSCoding>

// Initalizers
- (id)initWithGlyphs:(NSArray *)wordGlyphs;
- (id)initWithFrame:(CGRect)wordFrame;

/// Returns the content of the word (all glyphs merged together)
- (NSString *)stringValue;

- (BOOL)isOnSameLineAs:(PSPDFWord *)word;

// Helper to sort the lines: top->down, left->right
- (NSComparisonResult)compareByLayout:(PSPDFWord *)word;

/// All glyphs merged together in the smallest possible bounding box.
@property (nonatomic, assign) CGRect frame;

/// All PSPDFGlyph objects
@property (nonatomic, copy) NSArray *glyphs;

/// Set to YES if this is the last word on a textBlock.
@property (nonatomic, assign) BOOL lineBreaker;

/// Compare.
- (BOOL)isEqualToWord:(PSPDFWord *)otherWord;

@end

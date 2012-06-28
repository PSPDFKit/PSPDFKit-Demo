//
//  PSPDFWord.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

/// Represents a word. Formed out of (usually) multiple glyphs.
@interface PSPDFWord : NSObject

@property (nonatomic) CGRect frame;

@property (nonatomic, strong) NSArray *glyphs;

- (id)initWithGlyphs:(NSArray *)wordGlyphs;

- (id)initWithFrame:(CGRect)wordFrame;

/// Returns the content of the word (all glyphs merged together)
- (NSString *)stringValue;

- (CGRect)frameInView:(UIView *)pageView withPageRect:(CGRect)pageRect;

- (BOOL)isOnSameLineAs:(PSPDFWord *)word;

// helper to sort the lines: top->down, left->right
- (NSComparisonResult)compareByLayout:(PSPDFWord *)word;

@end

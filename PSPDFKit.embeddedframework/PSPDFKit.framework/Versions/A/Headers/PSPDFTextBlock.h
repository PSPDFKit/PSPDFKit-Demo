//
//  PSPDFTextBlock.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

/// Represents multiple words forming a text block. (e.g. a Column)
@interface PSPDFTextBlock : NSObject <NSCopying, NSCoding>

/// Designated initializer.
- (id)initWithGlyphs:(NSArray *)glyphs;

/// Frame of the text block. Not rotated.
@property (nonatomic, assign, readonly) CGRect frame;

/// All words of the current text block. Evaluated lazily.
@property (nonatomic, copy, readonly) NSArray *words;

/// All glyphs of the current text block.
@property (nonatomic, copy) NSArray *glyphs;

/// Returns the content of the text block (all words merged together)
@property (nonatomic, copy, readonly) NSString *content;

/// Compare.
- (BOOL)isEqualToTextBlock:(PSPDFTextBlock *)otherBlock;

@end

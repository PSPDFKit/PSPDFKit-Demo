//
//  PSPDFTextBlock.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

/// Represents multiple words forming a text block. (e.g. a Column)
@interface PSPDFTextBlock : NSObject

- (id)initWithGlyphs:(NSArray *)glyphs;

@property (nonatomic, readonly) CGRect frame;

/// All words of the current text block. Evaluated lazily.
@property (nonatomic, strong, readonly) NSArray *words;

/// All glyphs of the current text block.
@property (nonatomic, strong) NSArray *glyphs;

/// Returns the content of the text block (all words merged together)
@property (nonatomic, strong, readonly) NSString *content;

@end

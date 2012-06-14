//
//  PSPDFTextBlock.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Represents multiple words forming a text block. (e.g. a Column)
@interface PSPDFTextBlock : NSObject

- (id)initWithGlyphs:(NSArray *)glyphs;

@property (nonatomic, readonly) CGRect frame;

@property (nonatomic, strong, readonly) NSArray *words;

@property (nonatomic, strong, readonly) NSArray *glyphs;

/// Returns the content of the text block (all words merged together)
@property (nonatomic, strong, readonly) NSString *content;

@end

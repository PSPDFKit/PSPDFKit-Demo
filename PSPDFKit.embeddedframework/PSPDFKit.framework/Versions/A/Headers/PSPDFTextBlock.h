//
//  PSPDFTextBlock.h
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

/// Represents multiple words forming a text block. (e.g. a Column)
@interface PSPDFTextBlock : NSObject <NSCopying, NSCoding>

/// Designated initializer.
- (id)initWithGlyphs:(NSArray *)glyphs;

/// Frame of the text block. Not rotated.
@property (nonatomic, assign, readonly) CGRect frame;

/// All glyphs of the current text block.
@property (nonatomic, copy) NSArray *glyphs;

/// All words of the current text block. Evaluated lazily.
@property (nonatomic, copy, readonly) NSArray *words;

/// Returns the content of the text block (all words merged together)
@property (nonatomic, copy, readonly) NSString *content;

/// Compare.
- (BOOL)isEqualToTextBlock:(PSPDFTextBlock *)otherBlock;

@end

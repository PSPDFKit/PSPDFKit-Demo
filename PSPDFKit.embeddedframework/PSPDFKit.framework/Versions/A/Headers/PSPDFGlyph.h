//
//  PSPDFGlyph.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFFontInfo;

/// Global helper to convert glyphs to rects.
/// 't' is the pageRotationTransform of PSPDFPageInfo.
/// boundingBox will already be transformed with 't'.
extern NSArray *PSPDFRectsFromGlyphs(NSArray *glyphs, CGAffineTransform t, CGRect *boundingBox);

/// Returns the boundingBox that includes all glyphs.
/// 't' is the pageRotationTransform of PSPDFPageInfo.
extern CGRect PSPDFBoundingBoxFromGlyphs(NSArray *glyphs, CGAffineTransform t);

/// Scans glyphs and reduces the selection to columns.
extern NSArray *PSPDFReduceGlyphsToColumn(NSArray *glyphs);


/// Represents a single character (glyph, quad) on the PDF page.
@interface PSPDFGlyph : NSObject <NSCopying, NSCoding>

/// Designated initializer.
- (id)initWithFrame:(CGRect)frame content:(NSString *)content font:(PSPDFFontInfo *)font;

/// Frame of the glyph. Doesn't has pageRotation applied.
/// To apply the pageRotation, use CGRectApplyAffineTransform(glyph.frame, pageView.pageInfo.pageRotationTransform)
/// (PSPDFWord etc do have convenience methods for this)
@property (nonatomic, assign) CGRect frame;

/// Character content (usually a single character)
@property (nonatomic, strong) NSString *content;

/// Used font info.
/// @warning font is not retained for performance reasons. Don't access after the corresponding textParser has been deallocated.
@property (nonatomic, unsafe_unretained) PSPDFFontInfo *font;

/// Set if after this glyph a \n is there.
@property (nonatomic, assign) BOOL lineBreaker;

/// Dynamically evaluated. Return YES if glyph is a word boundary (space, parenthesis)
@property (nonatomic, assign, readonly) BOOL isWordBreaker;

/// Returns YES if glyph is end of a word or line.
@property (nonatomic, assign, readonly) BOOL isWordOrLineBreaker;

/// Index set on the Glyph.
@property (nonatomic, assign) int indexOnPage;

/// Used for caching during longPress event.
@property (nonatomic, assign) CGRect cachedViewRect;

/// Compare with second glyph on the X position.
- (NSComparisonResult)compareByXPosition:(PSPDFGlyph *)glyph;

/// Compare glyph with other glyph if it's approximately on the same line.
- (BOOL)isOnSameLineAs:(PSPDFGlyph *)glyph;

/// Compare glyph with other glyph if it's approximately on the same line segment (block detection).
- (BOOL)isOnSameLineSegmentAs:(PSPDFGlyph *)glyph;

/// Compare glyph.
- (BOOL)isEqualToGlyph:(PSPDFGlyph *)otherGlyph;

@end

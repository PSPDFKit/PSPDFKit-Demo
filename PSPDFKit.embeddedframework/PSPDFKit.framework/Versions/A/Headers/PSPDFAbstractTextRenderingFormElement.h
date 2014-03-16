//
//  PSPDFAbstractTextRenderingFormElement.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFFormElement.h"
#import "PSPDFFreeTextAnnotation.h" // for PSPDFVerticalAlignment
@import CoreText;

@protocol PSPDFTextOptionsProtocol <NSObject>
- (CGFloat)fontSize;
- (CGRect)boundingBox;
- (CGFloat)lineWidth;
- (UIColor *)fillColorWithAlpha;
- (NSTextAlignment)textAlignment;
- (PSPDFVerticalAlignment)verticalTextAlignment;
- (UIColor *)colorWithAlpha;
- (NSUInteger)rotation;
- (NSUInteger)pageRotation;
- (CTFontRef)createFontRef;
- (UIEdgeInsets)edgeInsets;
- (CGRect)clippingBox;
- (BOOL)isMultiline;
@end

@interface PSPDFTextOptions : NSObject <PSPDFTextOptionsProtocol>
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGRect boundingBox;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *fillColorWithAlpha;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) PSPDFVerticalAlignment verticalTextAlignment;
@property (nonatomic, strong) UIColor *colorWithAlpha;
@property (nonatomic, assign) NSUInteger rotation;
@property (nonatomic, assign) NSUInteger pageRotation;
@property (nonatomic, assign) CTFontRef fontRef;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGRect clippingBox;
@property (nonatomic, assign) BOOL isMultiline;
- (id)initWithOptions:(id<PSPDFTextOptionsProtocol>)options;
@end

@interface PSPDFAbstractTextRenderingFormElement : PSPDFFormElement

/// Font name as defined in the DA appearance string.
@property (nonatomic, copy) NSString *fontName;

/// Font size as defined in the DA appearance string.
@property (nonatomic, assign) CGFloat fontSize;

/// Text justification. Allows `NSTextAlignmentLeft`, `NSTextAlignmentCenter` and `NSTextAlignmentRight`.
/// @warning It seems that Adobe Acrobat X simply ignores this 'Q' setting (Optional; PDF 1.4)
@property (nonatomic, assign) NSTextAlignment textAlignment;

/// The vertical alignment. Defaults to `PSPDFVerticalAlignmentTop`.
@property (nonatomic, assign) PSPDFVerticalAlignment verticalTextAlignment;

/// Font calculated from the various font settings and corrected for autoresizing.
@property (nonatomic, assign, readonly) UIFont *font;

// Helper that returns a font for `contents`. Useful for auto-sized form elements.
- (UIFont *)fontWithContents:(NSString *)contents;

// Returns YES if the form element has automatic font sizing.
- (BOOL)isAutoSizedFont;

// Auto size a font within a rectangle.
- (UIFont *)autoSizedFontWithContents:(NSString *)contents forRect:(CGRect)rect;

/// (Optional; inheritable) The maximum length of the field’s text, in characters.
@property (nonatomic, assign) NSUInteger maxLength;

// Font defaults
- (NSString *)defaultFontName;
- (CGFloat)defaultFontSize;
- (UIFont *)defaultFont;
- (CTFontRef)createFontRef;
- (CGFloat)autoFontSizingFudgeFactor;
- (CGFloat)autoFontSizingHeightCorrection;

// Properties for rendering
@property (nonatomic, assign) CTFontRef fontRef;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGRect clippingBox;
@property (nonatomic, assign) BOOL isMultiline;

// Text rendering
- (void)drawText:(NSString *)contents inContext:(CGContextRef)context;
- (void)drawText:(NSString *)contents withCombLength:(NSUInteger)combLength inContext:(CGContextRef)context;

- (void)drawText:(NSString *)contents inContext:(CGContextRef)context withOptions:(id<PSPDFTextOptionsProtocol>)options;
- (void)drawText:(NSString *)contents withCombLength:(NSUInteger)combLength inContext:(CGContextRef)context withOptions:(id<PSPDFTextOptionsProtocol>)options;

- (void)drawText:(NSString *)text atMaximumSizeInRect:(CGRect)rect font:(UIFont *)font context:(CGContextRef)context;

@end

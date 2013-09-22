//
//  PSPDFAbstractTextRenderingFormElement.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFFormElement.h"
#import <CoreText/CoreText.h>

@protocol PSPDFTextOptionsProtocol <NSObject>
- (CGFloat)fontSize;
- (CGRect)boundingBox;
- (CGFloat)lineWidth;
- (UIColor *)fillColorWithAlpha;
- (NSTextAlignment)textAlignment;
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

/// Text justification. Allows PSPDFTextAlignmentLeft, PSPDFTextAlignmentCenter and PSPDFTextAlignmentRight.
/// @note Toll-free 'bridges' to both NSTextAlignment and UITextAlignment.
/// @warning It seems that Adobe Acrobat X simply ignores this 'Q' setting (Optional; PDF 1.4)
@property (nonatomic, assign) NSTextAlignment textAlignment;

/// Font calculated from the various font settings and corrected for autoresizing.
@property (nonatomic, assign) UIFont *font;

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
@property (nonatomic, assign) CGRect boundingBox;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *fillColorWithAlpha;
@property (nonatomic, strong) UIColor *colorWithAlpha;
@property (nonatomic, assign) NSUInteger rotation;
@property (nonatomic, assign) NSUInteger pageRotation;
@property (nonatomic, assign) CTFontRef fontRef;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGRect clippingBox;
@property (nonatomic, assign) BOOL isMultiline;

// Text rendering
- (void)drawText:(NSString *)contents inContext:(CGContextRef)context;
- (void)drawText:(NSString *)contents withCombLength:(NSUInteger)combLength inContext:(CGContextRef)context;

- (void)drawText:(NSString *)contents inContext:(CGContextRef)context withOptions:(id<PSPDFTextOptionsProtocol>)options;
- (void)drawText:(NSString *)contents withCombLength:(NSUInteger)combLength inContext:(CGContextRef)context withOptions:(id<PSPDFTextOptionsProtocol>)options;

@end

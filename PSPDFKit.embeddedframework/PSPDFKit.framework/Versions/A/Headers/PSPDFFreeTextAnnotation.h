//
//  PSPDFFreeTextAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotation.h"

/**
 PDF FreeText Annotation.

 A free text annotation (PDF 1.3) displays text directly on the page. Unlike an ordinary text annotation (see 12.5.6.4, “Text Annotations”), a free text annotation has no open or closed state; instead of being displayed in a pop-up window, the text shall be always visible.

 @note fillColor is not supported for free text annotations. (at least not for PDF writing)
 */
@interface PSPDFFreeTextAnnotation : PSPDFAnnotation

/// Designated initializer.
- (id)init;

/// Font name as defined in the DA appearance string.
@property (nonatomic, copy) NSString *fontName;

/// Font size as defined in the DA appearance string.
@property (nonatomic, assign) CGFloat fontSize;

/// Text justification. Allows PSPDFTextAlignmentLeft, PSPDFTextAlignmentCenter and PSPDFTextAlignmentRight.
/// @note Toll-free 'bridges' to both NSTextAlignment and UITextAlignment.
/// @warning It seems that Adobe Acrobat X simply ignores this 'Q' setting (Optional; PDF 1.4)
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
@property (nonatomic, assign) UITextAlignment textAlignment;
#else
@property (nonatomic, assign) NSTextAlignment textAlignment;
#endif

/// Return a default font size if not defined in the annotation.
- (CGFloat)defaultFontSize;

/// Return a default font name (Helvetica) if not defined in the annotation.
- (NSString *)defaultFontName;

/// Returns the currently set font (calculated from defaultFontSize)
- (UIFont *)defaultFont;

@end

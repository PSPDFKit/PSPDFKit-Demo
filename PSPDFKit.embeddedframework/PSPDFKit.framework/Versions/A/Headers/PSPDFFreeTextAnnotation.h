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

/// The line height for fontName and fontSize. Changes if you change either of these values.
@property (nonatomic, assign, readonly) CGFloat lineHeight;

/// Text justification. Allows NSTextAlignmentLeft, NSTextAlignmentCenter and NSTextAlignmentRight.
/// @note Toll-free 'bridges' to both NSTextAlignment and UITextAlignment.
/// @warning It seems that Adobe Acrobat X simply ignores this 'Q' setting (Optional; PDF 1.4)
@property (nonatomic, assign) NSTextAlignment textAlignment;

/// Return a default font size if not defined in the annotation.
- (CGFloat)defaultFontSize;

/// Return a default font name (Helvetica) if not defined in the annotation.
- (NSString *)defaultFontName;

/// Returns the currently set font (calculated from defaultFontSize)
- (UIFont *)defaultFont;

/// Resizes the annotation to fit the entire text by increasing or decreasing the height.
/// The width and origin of the annotation are maintained.
- (void)sizeToFit;

/// Returns the size of the annotation with respect to the given constraints. If you don't want to
/// constrain the height or width, use CGFLOAT_MAX for that value. The suggested size takes the
/// rotation of the annotation into account.
- (CGSize)sizeWithConstraints:(CGSize)constraints;

/// Enables automatic vertical resizing. If this property is set to YES, the annotation will
/// adjust its bounding box as the user types in more text.
/// Defaults to NO.
@property (nonatomic, assign) BOOL enableVerticalResizing;

/// Enables automatic horizontal resizing. If this property is set to YES, the annotation will
/// adjust its bounding box as the user types in more text.
/// Defaults to YES.
@property (nonatomic, assign) BOOL enableHorizontalResizing;

@end

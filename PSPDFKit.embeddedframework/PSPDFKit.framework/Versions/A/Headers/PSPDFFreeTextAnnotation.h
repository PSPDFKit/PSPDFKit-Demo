//
//  PSPDFFreeTextAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFAnnotation.h"

/**
 PDF FreeText Annotation.
 
 A free text annotation (PDF 1.3) displays text directly on the page. Unlike an ordinary text annotation (see 12.5.6.4, “Text Annotations”), a free text annotation has no open or closed state; instead of being displayed in a pop-up window, the text shall be always visible.
 */
@interface PSPDFFreeTextAnnotation : PSPDFAnnotation

/// Designated initializer.
- (id)init;

/// Font name as defined in the DA appearance string.
@property (nonatomic, copy) NSString *fontName;

/// Font size as defined in the DA appearance string.
@property (nonatomic, assign) CGFloat fontSize;

/// Return a default font size if not defined in the annotation.
- (CGFloat)defaultFontSize;

/// Return a default font name (Helvetica) if not defined in the annotation.
- (NSString *)defaultFontName;

/// Returns the currently set font (calculated from defaultFontSize)
- (UIFont *)defaultFont;

@end

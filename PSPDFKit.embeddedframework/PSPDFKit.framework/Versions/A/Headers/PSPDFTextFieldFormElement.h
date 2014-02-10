//
//  PSPDFTextFieldFormElement.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAbstractTextRenderingFormElement.h"

/// The text field flags. Most flags aren't currently supported.
/// Query `fieldFlags` from the `PSPDFFormElement` base class.
typedef NS_OPTIONS(NSUInteger, PSPDFTextFieldFlag) {
    PSPDFTextFieldFlagMultiline       = 1 << (13-1),
    PSPDFTextFieldFlagPassword        = 1 << (14-1),
    PSPDFTextFieldFlagFileSelect      = 1 << (21-1),
    PSPDFTextFieldFlagDoNotSpellCheck = 1 << (23-1),
    PSPDFTextFieldFlagDoNotScroll     = 1 << (24-1),
    PSPDFTextFieldFlagComb            = 1 << (25-1),
    PSPDFTextFieldFlagRichText        = 1 << (26-1)
};

typedef NS_ENUM(NSUInteger, PSPDFTextInputFormat) {
    PSPDFTextInputFormatNormal,
    PSPDFTextInputFormatNumber,
    PSPDFTextInputFormatDate,
    PSPDFTextInputFormatTime
};

/// Text field form element.
@interface PSPDFTextFieldFormElement : PSPDFAbstractTextRenderingFormElement

/// If set, the field may contain multiple lines of text; if clear, the field’s text shall be restricted to a single line.
/// @note Evaluates `PSPDFTextFieldFlagMultiline` in the `fieldFlags`.
- (BOOL)isMultiline;

/// If set, the field is intended for entering a secure password that should not be echoed visibly to the screen.
/// @note Evaluates `PSPDFTextFieldFlagPassword` in the `fieldFlags`.
- (BOOL)isPassword;

/// @name Formatting Options

/// Returns the content formatted in the way specified in the form element.
- (NSString *)formattedContents;

/// Validates the content according to the `formatString` set.
/// See http://www.pdfill.com/download/FormsAPIReference.pdf for details.
/// @warning This is still a work in progress.
- (BOOL)validateContents:(NSString *)contents error:(NSError **)validationError;

/// The input format. Some forms are number/date/time specific.
@property (nonatomic, assign) PSPDFTextInputFormat inputFormat;

/// The validation format string.
@property (nonatomic, copy) NSString *formatString;

@end

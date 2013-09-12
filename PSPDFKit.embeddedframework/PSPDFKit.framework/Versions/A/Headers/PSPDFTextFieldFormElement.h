//
//  PSPDFTextFieldFormElement.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAbstractTextRenderingFormElement.h"

/// The text field flags. Most flags aren't currently supported.
typedef NS_OPTIONS(NSUInteger, PSPDFTextFieldFlag) {
    PSPDFTextFieldFlagMultiline       = 1 << (13-1),
    PSPDFTextFieldFlagPassword        = 1 << (14-1),
    PSPDFTextFieldFlagFileSelect      = 1 << (21-1),
    PSPDFTextFieldFlagDoNotSpellCheck = 1 << (23-1),
    PSPDFTextFieldFlagDoNotScroll     = 1 << (24-1),
    PSPDFTextFieldFlagComb            = 1 << (25-1),
    PSPDFTextFieldFlagRichText        = 1 << (26-1)
};

/// Text field form element.
@interface PSPDFTextFieldFormElement : PSPDFAbstractTextRenderingFormElement

/// Designated initializer.
- (id)initWithAnnotationDictionary:(CGPDFDictionaryRef)annotDict documentRef:(CGPDFDocumentRef)documentRef parent:(PSPDFFormElement *)parentFormElement fieldsAddressMap:(NSMutableDictionary *)fieldsAddressMap;

/// If set, the field may contain multiple lines of text; if clear, the field’s text shall be restricted to a single line.
- (BOOL)isMultiline;

/// If set, the field is intended for entering a secure password that should not be echoed visibly to the screen.
- (BOOL)isPassword;

@end

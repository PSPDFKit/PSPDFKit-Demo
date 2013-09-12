//
//  PSPDFFormParser.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

@class PSPDFFormElement, PSPDFDocumentProvider;

/// Parses PDF Forms ("AcroForms").
@interface PSPDFFormParser : NSObject

/// Initializes the annotation parser with the associated documentProvider.
- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Attached document provider.
@property (nonatomic, weak) PSPDFDocumentProvider *documentProvider;

/// A collection of all forms in AcroForm. Lazily evaluated.
/// @warning Due to implementation details, make sure you first access the annotations before using this property.
@property (nonatomic, copy) NSArray *forms;

/// Finds a form element with its field name. nil if not found.
- (PSPDFFormElement *)findAnnotationWithFieldName:(NSString *)fieldName;

@end

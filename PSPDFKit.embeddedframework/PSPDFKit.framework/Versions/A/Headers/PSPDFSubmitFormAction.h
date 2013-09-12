//
//  PSPDFSubmitFormAction.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAbstractFormAction.h"

typedef NS_OPTIONS(NSUInteger, PSPDFSubmitFormActionFlag) {
    PSPDFSubmitFormActionFlagIncludeExclude       = 1 << (1-1),
    PSPDFSubmitFormActionFlagIncludeNoValueFields = 1 << (2-1),
    PSPDFSubmitFormActionFlagExportFormat         = 1 << (3-1),
    PSPDFSubmitFormActionFlagGetMethod            = 1 << (4-1),
    PSPDFSubmitFormActionFlagSubmitCoordinates    = 1 << (5-1),
    PSPDFSubmitFormActionFlagXFDF                 = 1 << (6-1),
    PSPDFSubmitFormActionFlagIncludeAppendSaves   = 1 << (7-1),
    PSPDFSubmitFormActionFlagIncludeAnnotations   = 1 << (8-1),
    PSPDFSubmitFormActionFlagSubmitPDF            = 1 << (9-1),
    PSPDFSubmitFormActionFlagCanonicalFormat      = 1 << (10-1),
    PSPDFSubmitFormActionFlagExclNonUserAnnots    = 1 << (11-1),
    PSPDFSubmitFormActionFlagExclFKey             = 1 << (12-1),
    PSPDFSubmitFormActionFlagEmbedForm            = 1 << (14-1),
};

/// Submit-Form-Action:  Send data to a uniform resource locator. PDF 1.2.
@interface PSPDFSubmitFormAction : PSPDFAbstractFormAction

/// Designated initializers
- (id)init;
- (id)initWithPDFDictionary:(CGPDFDictionaryRef)actionDictionary documentRef:(CGPDFDocumentRef)documentRef;

/// The target URL.
@property (nonatomic, strong) NSURL *URL;

/// The submit form action flags.
@property (nonatomic, assign) PSPDFSubmitFormActionFlag flags;

@end

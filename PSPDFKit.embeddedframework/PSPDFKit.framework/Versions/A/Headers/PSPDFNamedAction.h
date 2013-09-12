//
//  PSPDFNamedAction.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAction.h"

@class PSPDFDocument;

typedef NS_ENUM(NSUInteger, PSPDFNamedActionType) {
    PSPDFNamedActionTypeNone,
    PSPDFNamedActionTypeNextPage,
    PSPDFNamedActionTypePreviousPage,
    PSPDFNamedActionTypeFirstPage,
    PSPDFNamedActionTypeLastPage,
    PSPDFNamedActionTypeGoBack,
    PSPDFNamedActionTypeGoForward,
    PSPDFNamedActionTypeGoToPage, // not implemented
    PSPDFNamedActionTypeFind,
    PSPDFNamedActionTypePrint,    // not implemented
    PSPDFNamedActionTypeOutline,
    PSPDFNamedActionTypeSearch,
    PSPDFNamedActionTypeBrightness,
    PSPDFNamedActionTypeZoomIn,   // not implemented
    PSPDFNamedActionTypeZoomOut,  // not implemented
    PSPDFNamedActionTypeSaveAs,   // Will simply trigger [document saveChangedAnnotationsWithError:]
    PSPDFNamedActionTypeUnknown = NSUIntegerMax
};

/// Transforms named actions to enum type and back.
extern NSString * const PSPDFNamedActionTypeTransformerName;

/// PDFActionNamed defines methods used to work with actions in PDF documents, some of which are named in the Adobe PDF Specification.
@interface PSPDFNamedAction : PSPDFAction

/// Initialize with string. Will parse action, set to PSPDFNamedActionTypeUnknown if not recognized.
- (id)initWithActionNamedString:(NSString *)actionNameString;
- (id)initWithPDFDictionary:(CGPDFDictionaryRef)actionDictionary documentRef:(CGPDFDocumentRef)documentRef;

/// The type of the named action.
/// @note Will update `namedAction` if set.
@property (nonatomic, assign) PSPDFNamedActionType namedActionType;

/// The string of the named action.
/// @note Will update `namedActionType` if set.
@property (nonatomic, copy) NSString *namedAction;

/// Certain action types (PSPDFActionTypeNamed) calculate the target page dynamically from the current page.
/// @return The calculated page or NSNotFound if action doesn't specify page manipulation (like PSPDFNamedActionTypeFind)
- (NSUInteger)pageIndexWithCurrentPage:(NSUInteger)currentPage fromDocument:(PSPDFDocument *)document;

@end

//
//  PSPDFError.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

// The PSPDFKit Error Domain.
extern NSString *const PSPDFErrorDomain;

// List of documented errors within the PSPDFErrorDomain.
// @note Various PSPDFKit method can also returns errors from Apple-internal error domains.
typedef NS_ENUM(NSInteger, PSPDFErrorCode) {
    PSPDFErrorCodePageInvalid = 100,
    PSPDFErrorCodeUnableToOpenPDF = 200,
    PSPDFErrorCodeUnableToGetPageReference = 210,
    PSPDFErrorCodeUnableToGetStream = 220,
    PSPDFErrorCodePageRenderSizeIsEmpty = 220,
    PSPDFErrorCodePageRenderClipRectTooLarge = 230,
    PSPDFErrorCodePageRenderGraphicsContextNil = 240,
    PSPDFErrorCodeDocumentLocked = 300,
    PSPDFErrorCodeFailedToLoadAnnotations = 400,
    PSPDFErrorCodeFailedToWriteAnnotations = 410,
    PSPDFErrorCodeFailedToLoadBookmarks = 450,
    PSPDFErrorCodeOutlineParser = 500,
    PSPDFErrorCodeUnableToConvertToDataRepresentation = 600,
    PSPDFErrorCodeRemoveCacheError = 700,
    PSPDFErrorCodeFailedToConvertToPDF = 800,
    PSPDFErrorCodeFailedToGeneratePDFInvalidArguments = 810,
    PSPDFErrorCodeFailedToGeneratePDFDocumentInvalid = 820,
    PSPDFErrorCodeFailedToUpdatePageObject = 850,
    PSPDFErrorCodeMicPermissionNotGranted = 900,
    PSPDFErrorCodeXFDFParserLackingInputStream = 1000,
    PSPDFErrorCodeXFDFParserAlreadyCompleted = 1010,
    PSPDFErrorCodeXFDFParserAlreadyStarted = 1020,
    PSPDFErrorCodeXMLParserError = 1100,
    PSPDFErrorCodeXFDFWriterCannotWriteToStream = 1200,
    PSPDFErrorCodeFDFWriterCannotWriteToStream = 1250,
    PSPDFErrorCodeSoundEncoderInvalidInput = 1300,
    PSPDFErrorFeatureNotEnabled = 100000,
    PSPDFErrorCodeUnknown = NSIntegerMax
};

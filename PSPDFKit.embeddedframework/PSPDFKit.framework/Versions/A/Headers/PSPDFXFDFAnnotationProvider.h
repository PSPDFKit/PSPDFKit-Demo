//
//  PSPDFXFDFAnnotationProvider.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFContainerAnnotationProvider.h"

/// Concrete implementation of the `PSPDFAnnotationProvider` protocol that uses a XFDF file as a source.
/// The XFDF file needs to be local and in a writable location, not on a web server.
/// This annotation provider handles data form fields according to the XFDF spec: "An XFDF file with form data contains form field names and values. When importing XFDF into Acrobat, the target PDF file must already contain the form fields. Importing XFDF updates the form field values in the PDF file. Exporting to XFDF puts the current value of the field in the value element. Using XFDF, it is not possible to create a new form field in a PDF document, or change anything other than the value of an existing form field."
/// It compliments an existing data form fields from PDF with values from the XFDF file. If data form field value is not found in the XFDF file it will be served by this provider with the default value.
@interface PSPDFXFDFAnnotationProvider : PSPDFContainerAnnotationProvider

/// Designated initializers.
- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider;
- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider fileURL:(NSURL *)XFDFFileURL;

/// The XFDF file URL.
@property (nonatomic, copy, readonly) NSURL *fileURL;

/// The input stream. If you set `fileURL`, this is automatically set for you.
/// Customize to use a different source or a custom (crypto) input stream.
@property (nonatomic, strong) NSInputStream *inputStream;

/// The output stream. If you set `fileURL`, this is automatically set for you.
/// Customize to use a different target or a custom (crypto) output stream.
@property (nonatomic, strong) NSOutputStream *outputStream;

/// Will force-load annotations. Usually invoked lazily.
/// Use `hasLoadedAnnotationsForPage:` with any page (usually page 0) to detect if the annotations have been loaded yet.
- (void)loadAllAnnotations;

/// @name Encryption/Decryption Handlers

/// Decrypt data from the path. PSPDFKit Basic/Complete feature.
/// If set to nil, the default implementation will be used.
@property (atomic, copy) NSData *(^decryptFromPathBlock)(PSPDFXFDFAnnotationProvider *provider, NSString *path);

/// Encrypt mutable data. PSPDFKit Basic/Complete feature.
/// If set to nil, the default implementation will be used.
@property (atomic, copy) void (^encryptDataBlock)(PSPDFXFDFAnnotationProvider *provider, NSMutableData *data);

@end

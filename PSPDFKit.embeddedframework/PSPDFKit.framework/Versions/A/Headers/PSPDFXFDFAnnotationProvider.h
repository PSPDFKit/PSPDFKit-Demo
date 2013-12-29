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
#import "PSPDFFileAnnotationProvider.h"

/// Concrete implementation of the `PSPDFAnnotationProvider` protocol that uses a XFDF file as a source.
/// The XFDF file needs to be local and in a writable location, not on a webserver.
@interface PSPDFXFDFAnnotationProvider : NSObject <PSPDFAnnotationProvider>

/// Designated initializer.
- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider fileURL:(NSURL *)XFDFFileURL;

/// Associated `PSPDFDocumentProvider`.
@property (nonatomic, weak) PSPDFDocumentProvider *documentProvider;

/// The XFDF file URL.
@property (nonatomic, strong, readonly) NSURL *fileURL;

@end

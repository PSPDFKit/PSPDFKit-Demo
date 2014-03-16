//
//  PSCFileHelper.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

// Creates a temp URL.
NSURL *PSCTempFileURLWithPathExtension(NSString *prefix, NSString *pathExtension);

// Copies a file to the documents directory.
NSURL *PSCCopyFileURLToDocumentFolderAndOverride(NSURL *documentURL, BOOL override);

//
//  PSPDFDocumentParser.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocumentProvider;

/// Parses the PDF structure and supports writing annotations
@interface PSPDFDocumentParser : NSObject

- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Parses the PDF XRef table.
- (void)parseDocumentWithError:(NSError **)error;

/// Saves annotations, returns error if there was a problem
- (BOOL)saveAnnotations:(NSDictionary *)annotations withError:(NSError **)error;

/// Attached DocumentProvider
@property(nonatomic, ps_weak, readonly) PSPDFDocumentProvider *documentProvider;

/// Encryption Filter if one is found in the document.
@property(nonatomic, strong, readonly) NSString *encryptionFilter;

@property(nonatomic, strong, readonly) NSArray *pageObjectNumbers;

@end

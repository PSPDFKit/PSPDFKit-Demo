//
//  PSPDFDocumentParser.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocumentProvider;

/// Parses the PDF structure and supports writing annotations.
@interface PSPDFDocumentParser : NSObject

// Designated initializer.
- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Parses the PDF XRef table.
- (BOOL)parseDocumentWithError:(NSError **)error;

/// Saves annotations, returns error if there was a problem.
- (BOOL)saveAnnotations:(NSDictionary *)annotations withError:(NSError **)error;

/// Attached document provider.
@property (nonatomic, ps_weak, readonly) PSPDFDocumentProvider *documentProvider;

/// Encryption Filter if one is found in the document.
@property (nonatomic, copy, readonly) NSString *encryptionFilter;

/// Exposed XRef objects.
@property (nonatomic, copy, readonly) NSArray *pageObjectNumbers;

@end

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
- (void)parseDocument;

/// Saves annotations, returns error if there was a problem
- (BOOL)saveAnnotations:(NSDictionary *)annotations withError:(NSError **)error;

/// Attached DocumentProvider
@property(nonatomic, ps_weak, readonly) PSPDFDocumentProvider *documentProvider;

/// Encryption Filter if one is found in the document.
@property(nonatomic, strong, readonly) NSString *encryptionFilter;

@property(nonatomic, strong, readonly) NSArray *pageObjectNumbers;


@end

@interface PSPDFXRefEntry : NSObject

@property (nonatomic, assign) NSInteger objectNumber;
@property (nonatomic, assign) long byteOffset;
@property (nonatomic, assign) BOOL isCompressed;
@property (nonatomic, assign) NSInteger objectStreamNumber;
@property (nonatomic, assign) BOOL isDeleted;

@end

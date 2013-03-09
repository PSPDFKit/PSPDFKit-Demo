//
//  PSPDFDocumentParser.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
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
@property (nonatomic, weak, readonly) PSPDFDocumentProvider *documentProvider;

/// Encryption Filter if one is found in the document.
@property (nonatomic, copy, readonly) NSString *encryptionFilter;

/// Exposed XRef objects.
@property (nonatomic, copy, readonly) NSArray *pageObjectNumbers;

@end

@interface PSPDFDocumentParser (SubclassingHooks)

- (NSMutableData *)generateTrailerWithObjects:(NSDictionary *)updatedObjects startObjectNumber:(NSInteger)numberForNewObject;

- (NSInteger)numberForNewObject;

- (BOOL)isObjectCompressedForPageIndex:(NSUInteger)pageIndex;
- (NSInteger)objectNumberForPageIndex:(NSUInteger)pageIndex;
- (NSUInteger)objectNumberForAnnotationIndex:(NSUInteger)annotationIndex onPageIndex:(NSUInteger)pageIndex;

- (NSString *)objectDictionaryForPageIndex:(NSUInteger)pageIndex;
- (NSString *)objectDictionaryForNumber:(NSUInteger)number;

// Will create PDF data from the drawingBlock.
+ (NSData *)createAppearanceStreamDataWithRect:(CGRect)rect drawingBlock:(void(^)(CGContextRef context))drawingBlock;

// Uses a PDF to extract the AP stream from the document. (first page only)
+ (NSArray *)extractAppearanceStreamFromData:(NSData *)pdfData withRect:(CGRect)rect firstFreeObjectNumber:(NSUInteger)firstFreeObjectNumber;

// Will return the PDF appearance stream and helper objects for the drawing operations inside drawingBlock.
// Combines createAppearanceStreamDataWithRect and extractAppearanceStreamFromData.
+ (NSArray *)createAppearanceStreamWithRect:(CGRect)rect firstFreeObjectNumber:(NSUInteger)firstFreeObjectNumber drawingBlock:(void(^)(CGContextRef context))drawingBlock;

// Debugging feature. Only works when compiled with the DEBUG flag on source code.
- (void)printAllObjects;

@end

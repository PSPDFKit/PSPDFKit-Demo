//
//  PSPDFProcessor.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocument;

// Available keys for ptions. kPSPDFProcessorAnnotationDict in form of pageIndex -> annotations.
// If kPSPDFProcessorAnnotationDict is set, kPSPDFProcessorAnnotationTypes will be ignored.
// Annotations will be *flattened* when set here.
extern NSString *const kPSPDFProcessorAnnotationTypes;
extern NSString *const kPSPDFProcessorAnnotationDict;

// Settings for the string/URL -> PDF generators.
extern NSString *const kPSPDFProcessorPageRect;         // Defaults to CGRectMake(0, 0, 595, 842)
extern NSString *const kPSPDFProcessorNumberOfPages;    // Defaults to 10. Set lower to optimize, higher if you have a lot of content.
extern NSString *const kPSPDFProcessorPageBorderMargin; // Defaults to UIEdgeInsetsMake(5, 5, 5, 5).

// common options
extern NSString *const kPSPDFProcessorDocumentTitle;    // Will override any defaults if set.

typedef void (^PSPDFCompletionBlockWithError)(NSURL *fileURL, NSError *error);

/// Creates new PDF documents from current data.
@interface PSPDFProcessor : NSObject

/// Singleton
+ (instancetype)defaultProcessor;

/// Generate a PDF from a PSPDFDOcument into a file.
- (BOOL)generatePDFFromDocument:(PSPDFDocument *)document pageRange:(NSIndexSet *)pageRange outputFileURL:(NSURL *)fileURL options:(NSDictionary *)options;

/// Generate a PDF from a PSPDFDOcument into data.
- (NSData *)generatePDFFromDocument:(PSPDFDocument *)document pageRange:(NSIndexSet *)pageRange options:(NSDictionary *)options;

/// Internally uses UIMarkupTextPrintFormatter. Does not work with complex HTML pages.
/// Also works with plain strings.
/// e.g. @"This is a <b>test</b> in <span style='color:red'>color.</span>"
/// Can be used in a thread and is pretty fast. Experimental feature.
- (BOOL)generatePDFFromHTMLString:(NSString *)html outputFileURL:(NSURL *)fileURL options:(NSDictionary *)options;

/// Renders a PDF from a webURL. This will take a while and is non-blocking.
/// Upon completion, the completionBlock will be called. Check error for errors. Experimental feature.
- (void)generatePDFFromWebURL:(NSURL *)URL outputFileURL:(NSURL *)fileURL options:(NSDictionary *)options completionBlock:(PSPDFCompletionBlockWithError)completionBlock;

@end

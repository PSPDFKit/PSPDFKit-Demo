//
//  PSPDFProcessor.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocument, PSPDFConversionOperation;

// Available keys for options. kPSPDFProcessorAnnotationDict in form of pageIndex -> annotations.
// If kPSPDFProcessorAnnotationDict is set, kPSPDFProcessorAnnotationTypes will be ignored.
// Annotations will be *flattened* when set here.
extern NSString *const kPSPDFProcessorAnnotationTypes;
extern NSString *const kPSPDFProcessorAnnotationDict;

// Settings for the string/URL -> PDF generators.
extern NSString *const kPSPDFProcessorPageRect;         // Defaults to CGRectMake(0, 0, 595, 842)
extern NSString *const kPSPDFProcessorNumberOfPages;    // Defaults to 10. Set lower to optimize, higher if you have a lot of content.
extern NSString *const kPSPDFProcessorPageBorderMargin; // Defaults to UIEdgeInsetsMake(5, 5, 5, 5).
extern NSString *const kPSPDFProcessorAdditionalDelay;  // Defaults to 0.05 seconds. Set higher if you get blank pages.
// common options
extern NSString *const kPSPDFProcessorDocumentTitle;    // Will override any defaults if set.

typedef void (^PSPDFCompletionBlockWithError)(NSURL *fileURL, NSError *error);

/// Creates new PDF documents from current data.
@interface PSPDFProcessor : NSObject

/// Singleton
+ (instancetype)defaultProcessor;

/// Generate a PDF from a PSPDFDocument into a file.
- (BOOL)generatePDFFromDocument:(PSPDFDocument *)document pageRange:(NSIndexSet *)pageRange outputFileURL:(NSURL *)fileURL options:(NSDictionary *)options;

/// Generate a PDF from a PSPDFDOcument into data.
/// Beware to not use that on big files, since iOS has no virtual memory and the process will be force-closed on exhautive memory usage. 10-20MB should be the maximum for safe usage.
- (NSData *)generatePDFFromDocument:(PSPDFDocument *)document pageRange:(NSIndexSet *)pageRange options:(NSDictionary *)options;

/**
 Generates a PDF from a string. Does allow simple html tags.
 Will not work with complex HTML pages.

 e.g. @"This is a <b>test</b> in <span style='color:red'>color.</span>"
 Can be used in a thread and is pretty fast. Experimental feature.
 */
- (BOOL)generatePDFFromHTMLString:(NSString *)html outputFileURL:(NSURL *)fileURL options:(NSDictionary *)options;

/**
 Renders a PDF from a URL (web or fileURL). This will take a while and is non-blocking.
 Upon completion, the completionBlock will be called.

 Supported are web pages and certain file types like pages, keynote, word, powerpoint, excel, rtf, jpg, png, ...
 See https://developer.apple.com/library/ios/#qa/qa2008/qa1630.html for the full list.

 Certain documents might not have the correct pagination.
 (Try to manually define kPSPDFProcessorPageRect to fine-tune this)

 Experimental feature.
 Don't manually override NSOperation's completionBlock.
 If this helper is used, operation will be automatically queued in conversionOperationQueue.
 
 PSPDFKit Annotate feature.
*/
- (PSPDFConversionOperation *)generatePDFFromURL:(NSURL *)inputURL outputFileURL:(NSURL *)outputURL options:(NSDictionary *)options completionBlock:(PSPDFCompletionBlockWithError)completionBlock;

/// Default queue for conversion operations.
+ (NSOperationQueue *)conversionOperationQueue;

@end

/// Operation that converts many file formats to PDF.
/// Needs to be executed from a thread.  PSPDFKit Annotate feature.
@interface PSPDFConversionOperation : NSOperation

- (id)initWithURL:(NSURL *)inputURL outputFileURL:(NSURL *)outputFileURL options:(NSDictionary *)options completionBlock:(PSPDFCompletionBlockWithError)completionBlock;

@property (nonatomic, strong, readonly) NSURL *inputURL;
@property (nonatomic, strong, readonly) NSURL *outputFileURL;
@property (nonatomic, copy  , readonly) NSDictionary *options;
@property (nonatomic, strong, readonly) NSError *error;

@end
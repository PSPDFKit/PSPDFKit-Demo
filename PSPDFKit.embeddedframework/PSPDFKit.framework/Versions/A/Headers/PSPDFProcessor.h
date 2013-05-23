//
//  PSPDFProcessor.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocument, PSPDFConversionOperation;

// Available keys for options. kPSPDFProcessorAnnotationDict in form of pageIndex -> annotations.
// Annotations will be flattened when type is set, unless kPSPDFProcessorAnnotationAsDictionary is also set.
extern NSString *const kPSPDFProcessorAnnotationTypes;
extern NSString *const kPSPDFProcessorAnnotationDict;
extern NSString *const kPSPDFProcessorAnnotationAsDictionary; // Set to @YES to add annotations as dictionary and don't flatten them. Dictionary keys are the *original* page indexes.
//extern NSString *const kPSPDFProcessorForceRecreation; // Set to @YES to force the creation of a new PDF. (This is NO by default, and can speed up generation under certain conditions, e.g. when flattening is disabled and pageRange is the whole document)(

// Settings for the string/URL -> PDF generators.
extern NSString *const kPSPDFProcessorPageRect;         // Defaults to CGRectMake(0, 0, 595, 842)
extern NSString *const kPSPDFProcessorNumberOfPages;    // Defaults to 10. Set lower to optimize, higher if you have a lot of content.
extern NSString *const kPSPDFProcessorPageBorderMargin; // Defaults to UIEdgeInsetsMake(5, 5, 5, 5).
extern NSString *const kPSPDFProcessorAdditionalDelay;  // Defaults to 0.05 seconds. Set higher if you get blank pages.

// common options
extern NSString *const kPSPDFProcessorDocumentTitle;    // Will override any defaults if set.

typedef void (^PSPDFCompletionBlockWithError)(NSURL *fileURL, NSError *error);

typedef void (^PSPDFProgressBlock)(NSUInteger currentPage, NSUInteger numberOfProcessedPages, NSUInteger totalPages);

/// Create, merge or modify PDF documents. Also allows to flatten annotation data.
@interface PSPDFProcessor : NSObject

/// Access the processor via singleton.
+ (instancetype)defaultProcessor;

/// Generate a PDF from a PSPDFDocument into a file. 'options' can also contain CGPDFContext options.
/// For `pageRange` you can use [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)] to convert the whole document.
- (BOOL)generatePDFFromDocument:(PSPDFDocument *)document pageRange:(NSIndexSet *)pageRange outputFileURL:(NSURL *)fileURL options:(NSDictionary *)options progressBlock:(PSPDFProgressBlock)progressBlock error:(NSError **)error;

/// Generate a PDF from a PSPDFDocument into data. 'options' can also contain CGPDFContext options.
/// @warning Don't use with large files, since iOS has no virtual memory the process will be force-closed on exhaustive memory usage. 10-20MB should be the maximum for safe in-memory usage.
- (NSData *)generatePDFFromDocument:(PSPDFDocument *)document pageRange:(NSIndexSet *)pageRange options:(NSDictionary *)options progressBlock:(PSPDFProgressBlock)progressBlock error:(NSError **)error;

/**
 Generates a PDF from a string. Does allow simple html tags.
 Will not work with complex HTML pages.

 e.g. @"This is a <b>test</b> in <span style='color:red'>color.</span>"
 Can be used in a thread and is pretty fast. Experimental feature.
 */
- (BOOL)generatePDFFromHTMLString:(NSString *)HTML outputFileURL:(NSURL *)fileURL options:(NSDictionary *)options;

/**
 Renders a PDF from a URL (web or fileURL). This will take a while and is non-blocking.
 Upon completion, the completionBlock will be called.

 Supported are web pages and certain file types like pages, keynote, word, powerpoint, excel, rtf, jpg, png, ...
 See https://developer.apple.com/library/ios/#qa/qa2008/qa1630.html for the full list.

 Certain documents might not have the correct pagination.
 (Try to manually define kPSPDFProcessorPageRect to fine-tune this)

 'options' can contain both the kPSPDF constants listed above and any kCGPDFContext constants.
 For example, to password protect the pdf, you can use:
 @{(id)kCGPDFContextUserPassword  : password, (id)kCGPDFContextOwnerPassword : password,
   (id)kCGPDFContextEncryptionKeyLength : @(128)}

 Other useful properties are:
 - kCGPDFContextAllowsCopying
 - kCGPDFContextAllowsPrinting
 - kCGPDFContextKeywords
 - kCGPDFContextAuthor

 Experimental feature.
 Don't manually override NSOperation's completionBlock.
 If this helper is used, operation will be automatically queued in conversionOperationQueue.

 PSPDFKit Annotate feature.

 @warning When a password is set, only link annotations can be added as dictionary (this does not affect flattening)
*/
- (PSPDFConversionOperation *)generatePDFFromURL:(NSURL *)inputURL outputFileURL:(NSURL *)outputURL options:(NSDictionary *)options completionBlock:(PSPDFCompletionBlockWithError)completionBlock;

/// Default queue for conversion operations.
+ (NSOperationQueue *)conversionOperationQueue;

@end

/// Operation that converts many file formats to PDF.
/// Needs to be executed from a thread.  PSPDFKit Annotate feature.
@interface PSPDFConversionOperation : NSOperation

/// Designated initializer.
- (id)initWithURL:(NSURL *)inputURL outputFileURL:(NSURL *)outputFileURL options:(NSDictionary *)options completionBlock:(PSPDFCompletionBlockWithError)completionBlock;

/// Input. Needs to be a file URL.
@property (nonatomic, strong, readonly) NSURL *inputURL;

/// Output. Needs to be a file URL.
@property (nonatomic, strong, readonly) NSURL *outputFileURL;

/// Options set for conversion. See generatePDFFromURL:outputFileURL:options:completionBlock: for a list of options.
@property (nonatomic, copy, readonly) NSDictionary *options;

/// Error if something went wrong.
@property (nonatomic, strong, readonly) NSError *error;

@end

@interface PSPDFProcessor (Deprecated)

- (BOOL)generatePDFFromDocument:(PSPDFDocument *)document pageRange:(NSIndexSet *)pageRange outputFileURL:(NSURL *)fileURL options:(NSDictionary *)options error:(NSError **)error __attribute__ ((deprecated("Use the new variant with progressBlock")));

- (NSData *)generatePDFFromDocument:(PSPDFDocument *)document pageRange:(NSIndexSet *)pageRange options:(NSDictionary *)options error:(NSError **)error __attribute__ ((deprecated("Use the new variant with progressBlock")));

@end

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

// Available keys for options. PSPDFProcessorAnnotationDict in form of pageIndex -> annotations.
// Annotations will be flattened when type is set, unless PSPDFProcessorAnnotationAsDictionary is also set.
extern NSString *const PSPDFProcessorAnnotationTypes;
extern NSString *const PSPDFProcessorAnnotationDict;
extern NSString *const PSPDFProcessorAnnotationAsDictionary; // Set to @YES to add annotations as dictionary and don't flatten them. Dictionary keys are the *original* page indexes.

// Settings for the string/URL -> PDF generators.
extern NSString *const PSPDFProcessorPageRect;         // Defaults to PSPDFPaperSizeA4
extern NSString *const PSPDFProcessorNumberOfPages;    // Defaults to 10. Set lower to optimize, higher if you have a lot of content.
extern NSString *const PSPDFProcessorPageBorderMargin; // Defaults to UIEdgeInsetsMake(5, 5, 5, 5).
extern NSString *const PSPDFProcessorAdditionalDelay;  // Defaults to 0.05 seconds. Set higher if you get blank pages.
extern NSString *const PSPDFProcessorStripEmptyPages;  // Defaults to NO. Adds an additional step to strip white pages if you're getting any at the end.

// Common page sizes. Use for PSPDFProcessorPageRect.
extern CGRect const PSPDFPaperSizeA4;
extern CGRect const PSPDFPaperSizeLetter;

// common options
extern NSString *const PSPDFProcessorDocumentTitle;    // Will override any defaults if set.

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

/// Like the above, but create a temporary PDF in memory.
- (NSData *)generatePDFFromHTMLString:(NSString *)HTML options:(NSDictionary *)options;

/**
 Renders a PDF from a URL (web or fileURL). This will take a while and is non-blocking.
 Upon completion, the completionBlock will be called.

 Supported are web pages and certain file types like pages, keynote, word, powerpoint, excel, rtf, jpg, png, ...
 See https://developer.apple.com/library/ios/#qa/qa2008/qa1630.html for the full list.

 Certain documents might not have the correct pagination.
 (Try to manually define PSPDFProcessorPageRect to fine-tune this)

 'options' can contain both the PSPDF constants listed above and any kCGPDFContext constants.
 For example, to password protect the pdf, you can use:
 @{(id)kCGPDFContextUserPassword  : password,
   (id)kCGPDFContextOwnerPassword : password,
   (id)kCGPDFContextEncryptionKeyLength : @128}

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
- (PSPDFConversionOperation *)generatePDFFromURL:(NSURL *)inputURL outputFileURL:(NSURL *)outputURL options:(NSDictionary *)options completionBlock:(void (^)(NSURL *fileURL, NSError *error))completionBlock;

/// Will create a PDF in-memory.
- (PSPDFConversionOperation *)generatePDFFromURL:(NSURL *)inputURL options:(NSDictionary *)options completionBlock:(void (^)(NSData *fileData, NSError *error))completionBlock;

/// Default queue for conversion operations.
+ (NSOperationQueue *)conversionOperationQueue;

@end

/// Operation that converts many file formats to PDF.
/// Needs to be executed from a thread. PSPDFKit Annotate feature.
@interface PSPDFConversionOperation : NSOperation

/// Designated initializer.
- (id)initWithURL:(NSURL *)inputURL outputFileURL:(NSURL *)outputFileURL options:(NSDictionary *)options completionBlock:(void (^)(NSURL *fileURL, NSError *error))completionBlock;
- (id)initWithURL:(NSURL *)inputURL options:(NSDictionary *)options completionBlock:(void (^)(NSData *fileData, NSError *error))completionBlock;

/// Input. Needs to be a file URL.
@property (nonatomic, strong, readonly) NSURL *inputURL;

/// Output. Needs to be a file URL.
@property (nonatomic, strong, readonly) NSURL *outputFileURL;

/// Output data, if data constructor was used.
@property (nonatomic, strong, readonly) NSData *outputData;

/// Options set for conversion. See generatePDFFromURL:outputFileURL:options:completionBlock: for a list of options.
@property (nonatomic, copy, readonly) NSDictionary *options;

/// Error if something went wrong.
@property (nonatomic, strong, readonly) NSError *error;

@end

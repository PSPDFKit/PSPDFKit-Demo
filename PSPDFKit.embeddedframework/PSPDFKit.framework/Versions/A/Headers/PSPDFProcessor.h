//
//  PSPDFProcessor.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocument, PSPDFConversionOperation;

// Available keys for options. `PSPDFProcessorAnnotationDict` in form of pageIndex -> annotations.
// Annotations will be flattened when type is set, unless `PSPDFProcessorAnnotationAsDictionary` is also set.
// Don't forget to also define the types of annotations that should be processed:
// PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll).
extern NSString *const PSPDFProcessorAnnotationTypes;
extern NSString *const PSPDFProcessorAnnotationDict;
extern NSString *const PSPDFProcessorAnnotationAsDictionary; // Set to `@YES` to add annotations as dictionary and don't flatten them. Dictionary keys are the *original* page indexes.

// Settings for the string/URL -> PDF generators.
extern NSString *const PSPDFProcessorPageRect;         // Defaults to `PSPDFPaperSizeA4`
extern NSString *const PSPDFProcessorNumberOfPages;    // Defaults to 10. Set lower to optimize, higher if you have a lot of content.
extern NSString *const PSPDFProcessorPageBorderMargin; // Defaults to `UIEdgeInsetsMake(5, 5, 5, 5)`.
extern NSString *const PSPDFProcessorAdditionalDelay;  // Defaults to 0.05 seconds. Set higher if you get blank pages.
extern NSString *const PSPDFProcessorStripEmptyPages;  // Defaults to NO. Adds an additional step to strip white pages if you're getting any at the end.
extern NSString *const PSPDFProcessorSkipPDFCreation;  // Defaults to NO. Will assume output is already a valid PDF and just perform annotation saving.

/// Allows a drawing block of type `PSPDFRenderDrawBlock` being called for each page. This will set up a similar drawing block as you'd get with calling `UIGraphicsBeginImageContext`.
/// @note This is similar to `PSPDFRenderDrawRectBlock` but only called in the processor.
/// @warning This code will be executed on a background thread. Use thread-safe drawing.
extern NSString *const PSPDFProcessorDrawRectBlock;

// Common page sizes. Use for `PSPDFProcessorPageRect`.
extern CGRect const PSPDFPaperSizeA4;
extern CGRect const PSPDFPaperSizeLetter;

// common options
extern NSString *const PSPDFProcessorDocumentTitle;    // Will override any defaults if set.

typedef void (^PSPDFProgressBlock)(NSUInteger currentPage, NSUInteger numberOfProcessedPages, NSUInteger totalPages);

/// Create, merge or modify PDF documents. Also allows to flatten annotation data.
@interface PSPDFProcessor : NSObject

/// Access the processor via singleton.
+ (instancetype)defaultProcessor;

/// Generate a PDF from a `PSPDFDocument` into a file. `options` can also contain `CGPDFContext` options.
/// @note For `pageRanges` you can use `@[[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)]]` to convert the whole document.
- (BOOL)generatePDFFromDocument:(PSPDFDocument *)document pageRanges:(NSArray *)pageRanges outputFileURL:(NSURL *)fileURL options:(NSDictionary *)options progressBlock:(PSPDFProgressBlock)progressBlock error:(NSError **)error;

/// Generate a PDF from a `PSPDFDocument` into data. 'options' can also contain `CGPDFContext` options.
/// @note For `pageRanges` you can use `@[[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)]]` to convert the whole document.
/// @warning Don't use with large files, since iOS has no virtual memory the process will be force-closed on exhaustive memory usage. 10-20MB should be the maximum for safe in-memory usage.
- (NSData *)generatePDFFromDocument:(PSPDFDocument *)document pageRanges:(NSArray *)pageRanges options:(NSDictionary *)options progressBlock:(PSPDFProgressBlock)progressBlock error:(NSError **)error;

/// Generates a PDF from a string. Does allow simple html tags. Will not work with complex HTML pages.
/// e.g. `@"This is a <b>test</b>` in `<span style='color:red'>color.</span>`
/// @note Must be called from the main thread.
- (BOOL)generatePDFFromHTMLString:(NSString *)HTML outputFileURL:(NSURL *)fileURL options:(NSDictionary *)options error:(NSError **)error;

/// Like the above, but create a temporary PDF in memory.
/// @note Must be called from the main thread.
- (NSData *)generatePDFFromHTMLString:(NSString *)HTML options:(NSDictionary *)options error:(NSError **)error;

/**
 Renders a PDF from an `URL` (web or `fileURL`). This will take a while and is non-blocking.
 Upon completion, the `completionBlock` will be called.

 Supported are web pages and certain file types like pages, keynote, word, powerpoint, excel, rtf, jpg, png, ...
 See https://developer.apple.com/library/ios/#qa/qa2008/qa1630.html for the full list.

 @note FILE/OFFICE CONVERSION IS AN EXPERIMENTAL FEATURE AND WE CAN'T OFFER SUPPORT FOR CONVERSION ISSUES.
 If you require a 1:1 conversion, you need to convert those files on a server with a product that is specialized for this task.

 Certain documents might not have the correct pagination.
 (Try to manually define `PSPDFProcessorPageRect` to fine-tune this.)

 `options` can contain both the PSPDF constants listed above and any `kCGPDFContext` constants.
 For example, to password protect the pdf, you can use:
 `@{(id)kCGPDFContextUserPassword  : password,
   (id)kCGPDFContextOwnerPassword : password,
   (id)kCGPDFContextEncryptionKeyLength : @128}`

 Other useful properties are:
 - `kCGPDFContextAllowsCopying`
 - `kCGPDFContextAllowsPrinting`
 - `kCGPDFContextKeywords`
 - `kCGPDFContextAuthor`

 PSPDFKit Basic/Complete feature. Not available for PSPDFKit Viewer.

 @warning
 Don't manually override NSOperation's `completionBlock`.
 If this helper is used, operation will be automatically queued in `conversionOperationQueue`.
 When a password is set, only link annotations can be added as dictionary (this does not affect flattening)
*/
- (PSPDFConversionOperation *)generatePDFFromURL:(NSURL *)inputURL outputFileURL:(NSURL *)outputURL options:(NSDictionary *)options completionBlock:(void (^)(NSURL *fileURL, NSError *error))completionBlock;

/// Will create a PDF in-memory.
- (PSPDFConversionOperation *)generatePDFFromURL:(NSURL *)inputURL options:(NSDictionary *)options completionBlock:(void (^)(NSData *fileData, NSError *error))completionBlock;

/// Default queue for conversion operations.
+ (NSOperationQueue *)conversionOperationQueue;

@end

/// Operation that converts many file formats to PDF.
/// Needs to be executed from a thread. PSPDFKit Basic/Complete feature.
@interface PSPDFConversionOperation : NSOperation

/// Designated initializer.
- (id)initWithURL:(NSURL *)inputURL outputFileURL:(NSURL *)outputFileURL options:(NSDictionary *)options completionBlock:(void (^)(NSURL *fileURL, NSError *error))completionBlock;
- (id)initWithURL:(NSURL *)inputURL options:(NSDictionary *)options completionBlock:(void (^)(NSData *fileData, NSError *error))completionBlock;

/// Input. Needs to be a file URL.
@property (nonatomic, copy, readonly) NSURL *inputURL;

/// Output. Needs to be a file URL.
@property (nonatomic, copy, readonly) NSURL *outputFileURL;

/// Output data, if data constructor was used.
@property (nonatomic, strong, readonly) NSData *outputData;

/// Options set for conversion. See `generatePDFFromURL:outputFileURL:options:completionBlock:` for a list of options.
@property (nonatomic, copy, readonly) NSDictionary *options;

/// Error if something went wrong.
@property (nonatomic, strong, readonly) NSError *error;

@end

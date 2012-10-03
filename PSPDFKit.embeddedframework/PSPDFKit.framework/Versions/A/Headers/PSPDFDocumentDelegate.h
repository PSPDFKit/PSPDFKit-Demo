//
//  PSPDFDocumentDelegate.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
@class PSPDFViewController;

/// Delegate to receive events regarding PSPDFDocument (annotation saving; path resolving)
@protocol PSPDFDocumentDelegate <NSObject>

@optional

/// Allow resolving custom path tokens (Documents, Bundle are automatically resolved; you can add e.g. Book and resolve this here). Will only get called for unknown tokens.
- (NSString *)pdfDocument:(PSPDFDocument *)document resolveCustomAnnotationPathToken:(NSString *)pathToken; // return nil if unknown.

/// Called after saving was successful.
/// If there are no dirty annotations, delegates will not be called.
- (void)pdfDocument:(PSPDFDocument *)document didSaveAnnotations:(NSArray *)annotations;

/// Called after saving was failed. When a error occurs, annotations will not be the complete set in multi-file documents.
- (void)pdfDocument:(PSPDFDocument *)document failedToSaveAnnotations:(NSArray *)annotations withError:(NSError *)error;

@end

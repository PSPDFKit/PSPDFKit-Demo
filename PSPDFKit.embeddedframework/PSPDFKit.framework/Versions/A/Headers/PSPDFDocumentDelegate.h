//
//  PSPDFDocumentDelegate.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

@class PSPDFViewController, PSPDFDocumentProvider, PSPDFDocument;

/// Delegate to receive events regarding `PSPDFDocument`.
@protocol PSPDFDocumentDelegate <NSObject>

@optional

/// Callback for a render operation. Will be called on a thread (since rendering is async)
/// You can use the context to add custom drawing.
- (void)pdfDocument:(PSPDFDocument *)document didRenderPage:(NSUInteger)page inContext:(CGContextRef)context withSize:(CGSize)fullSize clippedToRect:(CGRect)clipRect annotations:(NSArray *)annotations options:(NSDictionary *)options;

/// Allow resolving custom path tokens (Documents, Bundle are automatically resolved; you can add e.g. Book and resolve this here). Will only get called for unknown tokens.
- (NSString *)pdfDocument:(PSPDFDocument *)document resolveCustomAnnotationPathToken:(NSString *)pathToken; // return nil if unknown.

/// Called before the save process is started. Will assume YES if not implemented.
/// Might be called multiple times during a save process if the document contains multiple document providers.
/// @warning Might be called from a thread.
- (BOOL)pdfDocument:(PSPDFDocument *)document provider:(PSPDFDocumentProvider *)documentProvider shouldSaveAnnotations:(NSArray *)annotations;

/// Called after saving was successful.
/// If there are no dirty annotations, delegates will not be called.
/// @note `annotations` might not include all changes, especially if annotations have been deleted or an annotation provider didn't implement dirtyAnnotations.
/// @warning Might be called from a thread.
- (void)pdfDocument:(PSPDFDocument *)document didSaveAnnotations:(NSArray *)annotations;

/// Called after saving failed. When an error occurs, annotations will not be the complete set in multi-file documents.
/// @note `annotations` might not include all changes, especially if annotations have been deleted or an annotation provider didn't implement `dirtyAnnotations`.
/// @warning Might be called from a thread.
- (void)pdfDocument:(PSPDFDocument *)document failedToSaveAnnotations:(NSArray *)annotations error:(NSError *)error;

@end

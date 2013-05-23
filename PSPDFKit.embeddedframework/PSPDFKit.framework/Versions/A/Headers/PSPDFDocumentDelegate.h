//
//  PSPDFDocumentDelegate.h
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

@class PSPDFViewController;

/// Delegate to receive events regarding PSPDFDocument (annotation saving; path resolving)
@protocol PSPDFDocumentDelegate <NSObject>

@optional

/// Callback for a render operation. Will be called on a thread (since rendering is async)
/// You can use the context to add custom drawing.
- (void)pdfDocument:(PSPDFDocument *)document didRenderPage:(NSUInteger)page inContext:(CGContextRef)context withSize:(CGSize)fullSize clippedToRect:(CGRect)clipRect withAnnotations:(NSArray *)annotations options:(NSDictionary *)options;

/// Allow resolving custom path tokens (Documents, Bundle are automatically resolved; you can add e.g. Book and resolve this here). Will only get called for unknown tokens.
- (NSString *)pdfDocument:(PSPDFDocument *)document resolveCustomAnnotationPathToken:(NSString *)pathToken; // return nil if unknown.

/// Called after saving was successful.
/// If there are no dirty annotations, delegates will not be called.
- (void)pdfDocument:(PSPDFDocument *)document didSaveAnnotations:(NSArray *)annotations;

/// Called after saving failed. When an error occurs, annotations will not be the complete set in multi-file documents.
- (void)pdfDocument:(PSPDFDocument *)document failedToSaveAnnotations:(NSArray *)annotations withError:(NSError *)error;

@end

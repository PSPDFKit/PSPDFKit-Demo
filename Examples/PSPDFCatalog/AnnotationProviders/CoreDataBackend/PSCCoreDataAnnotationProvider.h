//
//  PSCCoreDataAnnotationProvider.h
//  PSPDFCatalog
//
//  Copyright (c) 2013-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

// This is an example how you could store your annotations with CoreData in the simplest possible way.
// Note: It's not a great idea performance-wise to use `NSKeyedArchiver` for data serialization.
@interface PSCCoreDataAnnotationProvider : PSPDFContainerAnnotationProvider

// Designated initializer.
// If `databasePath` is nil, a default path will be used.
- (instancetype)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider databasePath:(NSString *)databasePath;

// Database path/filename.
@property (nonatomic, copy, readonly) NSString *databasePath;

@end

@interface PSCCoreDataAnnotationProvider (Advanced)

// Allows to insert a number of new pages; moving the backing store up for length x.
// @note: Those modification methods require a controller reload as they work directly on the backing store.
- (void)insertPagesAtRange:(NSRange)pageRange;

// Will delete a number of pages.
// @note: Those modification methods require a controller reload as they work directly on the backing store.
- (void)deletePagesInRange:(NSRange)pageRange;

@end

@interface PSCCoreDataAnnotationProvider (SubclassingHooks)

// Allow to map an annotation to a custom page.
// By default simply returns `annotation.page`.
- (NSUInteger)pageForAnnotation:(PSPDFAnnotation *)annotation;

@end

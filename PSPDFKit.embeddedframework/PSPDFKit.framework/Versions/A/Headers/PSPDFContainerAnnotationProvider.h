//
//  PSPDFContainerAnnotationProvider.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotationProvider.h"
#import "PSPDFUndoProtocol.h"

/// Default container for annotations. It's crucial that you use this class as your base class if you implement a custom annotation provider, as this class offers efficient undo/redo which otherwise is almost impossible to replicate unless you understand the PSPDFKit internals extremely well.
@interface PSPDFContainerAnnotationProvider : NSObject <PSPDFAnnotationProvider, PSPDFUndoProtocol>

/// Designated initializer.
- (instancetype)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider NS_DESIGNATED_INITIALIZER;

/// Associated `documentProvider`.
@property (nonatomic, weak, readonly) PSPDFDocumentProvider *documentProvider;

@end

@interface PSPDFContainerAnnotationProvider (SubclassingHooks)

// Allows synchronization with the internal reader/writer queue.
// You shouldn't call any of the methods below inside such synchronization blocks, or you will risk a deadlock.
- (void)performBlockForReading:(void (^)())block;
- (void)performBlockForWriting:(void (^)())block;
- (void)performBlockForWritingAndWait:(void (^)())block;

// Modify the internal store. Optionally appends annotations instead of replacing them.
// @note The page set in the `annotations` need to match the `page`.
- (void)setAnnotations:(NSArray *)annotations forPage:(NSUInteger)page append:(BOOL)append;

// Set annotations, evaluate the page value of each annotation.
- (void)setAnnotations:(NSArray *)annotations append:(BOOL)append;

// Remove all annotations (effectively clears the cache).
/// @param options Deletion options (see the `PSPDFAnnotationOption...` constants in `PSPDFAnnotationManager.h`).
- (void)removeAllAnnotationsWithOptions:(NSDictionary *)options;

// Returns all annotations of all pages in one array.
- (NSArray *)allAnnotations;

// Returns all annotations as a page->annotations per page dictionary.
- (NSDictionary *)annotations;

// Adding/Removing annotations triggers an internal flag that the provider requires saving.
// This method can clear this flag.
- (void)clearNeedsSaveFlag;

// Allows to override the annotation cache directly. Faster than using `setAnnotations:`.
- (void)setAnnotationCacheDirect:(NSDictionary *)annotationCache;
- (void)registerAnnotationsForUndo:(NSArray *)annotations;

// Allows to directly access the internally used annotation cache.
// Be extremely careful when accessing this, and use the locking methods.
@property (nonatomic, strong, readonly) NSMutableDictionary *annotationCache;

// Called before new annotations are inserted. Subclass to perform custom actions.
- (void)willInsertAnnotations:(NSArray *)annotations;

@end

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

#import "PSPDFKitGlobal.h"
#import "PSPDFAnnotationProvider.h"
#import "PSPDFUndoProtocol.h"

@interface PSPDFContainerAnnotationProvider : NSObject <PSPDFAnnotationProvider, PSPDFUndoProtocol>

/// Designated initializer.
- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Associated `documentProvider`.
@property (nonatomic, weak, readonly) PSPDFDocumentProvider *documentProvider;

@end

@interface PSPDFContainerAnnotationProvider (SubclassingHooks)

// Called before new annotations are inserted. Subclass to perform custom actions.
- (void)willInsertAnnotations:(NSArray *)annotations;

@end

@interface PSPDFContainerAnnotationProvider (Private)

// Allows synchronization with the internal queue.
- (void)performBlockForReading:(void (^)())block;
- (void)performBlockForWriting:(void (^)())block;
- (void)performBlockForWritingAndWait:(void (^)())block;

// Modify the internal store.
- (void)setAnnotations:(NSArray *)annotations forPage:(NSUInteger)page append:(BOOL)append;

// Set annotations, evaluate the page value of each annotation.
- (void)setAnnotations:(NSArray *)annotations append:(BOOL)append;

// Remove notifications and optionally sends notifications.
- (NSArray *)removeAnnotations:(NSArray *)annotations sendNotifications:(BOOL)sendNotifications;

// Remove all annotations.
- (void)removeAllAnnotationsAndSendNotification:(BOOL)sendNotification;

// Returns all annotations of all pages.
- (NSArray *)allAnnotations;
- (NSDictionary *)annotations;

- (void)clearNeedsSaveFlag;

// Allows to override the annotation cache directly. Faster than using `setAnnotations:`.
- (void)setAnnotationCacheDirect:(NSDictionary *)annotationCache;
- (void)registerObjectsForUndo:(NSArray *)annotations;

@property (nonatomic, strong, readonly) NSMutableDictionary *annotationCache;

@end

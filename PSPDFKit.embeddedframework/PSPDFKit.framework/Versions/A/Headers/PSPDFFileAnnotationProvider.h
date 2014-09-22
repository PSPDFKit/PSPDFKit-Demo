//
//  PSPDFFileAnnotationProvider.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotationProvider.h"
#import "PSPDFDocument.h"
#import "PSPDFContainerAnnotationProvider.h"

@class PSPDFLinkAnnotation, PSPDFDocument;

/// Default implementation of the `PSPDFAnnotationProvider` protocol that uses the PDF document as source/target to load/save annotations. You almost always want to use the `PSPDFFileAnnotationProvider` in your `PSPDFAnnotationManager`. You can also use the `PSPDFFileAnnotationProvider` inside a custom annotation provider, to parse PDF annotations once and then manage them in your custom database.
@interface PSPDFFileAnnotationProvider : PSPDFContainerAnnotationProvider

/// Designated initializer.
- (instancetype)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider NS_DESIGNATED_INITIALIZER;

/// Default annotation username. Defaults to nil.
/// Written as the "T" (title/user) property of newly created annotations.
@property (atomic, copy) NSString *defaultAnnotationUsername;

/// Set to enable auto-detection of various link types. Defaults to `PSPDFTextCheckingTypeNone`.
/// @warning Detecting links might be an expensive operation.
@property (nonatomic, assign) PSPDFTextCheckingType autodetectTextLinkTypes;

/**
 Performance optimized access.

 The default implementation is lazy loaded (and of course thread safe); hitting a dictionary cache first and blocks if no cache is found. After the first expensive call, this method is basically free. Ensure that you're using a similar cache if you replace this method with your own.
*/
- (NSArray *)annotationsForPage:(NSUInteger)page pageRef:(CGPDFPageRef)pageRef;

/// Will add the annotation to the current annotation array. Will accept any annotations.
/// @param annotations An array of PSPDFAnnotation objects to be added.
/// @param options Insertion options (see the `PSPDFAnnotationOption...` constants in `PSPDFAnnotationManager.h`).
- (NSArray *)addAnnotations:(NSArray *)annotations options:(NSDictionary *)options;

/// Annotations are either removed (`PSPDFAnnotationsRemovedNotification`) or soft-deleted if they are already saved in the PDF.
/// In case they are soft-deleted, a `PSPDFAnnotationChangedNotification` with isDeleted as keyPath is sent instead.
/// @param annotations An array of PSPDFAnnotation objects to be removed.
/// @param options Deletion options (see the `PSPDFAnnotationOption...` constants in `PSPDFAnnotationManager.h`).
- (NSArray *)removeAnnotations:(NSArray *)annotations options:(NSDictionary *)options;

/// Removes all annotation and re-evaluates the document on next access.
- (void)clearCache;

/// Try to load annotations from file and set them if successful.
- (BOOL)tryLoadAnnotationsFromFileWithError:(NSError **)error;

@end

@interface PSPDFFileAnnotationProvider (Advanced)

/// This defaults to `PSPDFAnnotationTypeAll&~PSPDFAnnotationTypeLink` by default.
/// Change this to PSPDFAnnotationTypeAll to also allow link annotation saving.
/// Links are not saved by default since some documents have a crazy high amount of link annotations which would make saving slow.
/// @warning Never exclude PSPDFAnnotationTypeWidget - Forms are specially handled.
@property (nonatomic, assign) PSPDFAnnotationType saveableTypes;

/// Allows to customize what annotation types should be parsed from the PDF.
/// Defaults to `PSPDFAnnotationTypeAll`.
@property (nonatomic, assign) PSPDFAnnotationType parsableTypes;

/// Path where annotations are being saved if saving to external file is enabled.
/// Default's to `self.documentProvider.document.cacheDirectory` + "annotations_%d.pspdfkit" (%d = number of the documentProvider)
/// If set to nil, will revert back to the default value.
@property (nonatomic, copy) NSString *annotationsPath;

@end


@interface PSPDFFileAnnotationProvider (SubclassingHooks)

// Parses the page annotation dictionary and returns the newly created annotations.
// Want to customize annotations right after parsing? This is the perfect place.
// Will be called from `annotationsForPage:pageRef:` in a thread safe manner and later cached.
- (NSArray *)parseAnnotationsForPage:(NSUInteger)page pageRef:(CGPDFPageRef)pageRef;

// Saving code.
- (BOOL)saveAnnotationsWithOptions:(NSDictionary *)options error:(NSError **)error;

// Load annotations (returning NO + eventually an error if it fails)
- (NSDictionary *)loadAnnotationsWithError:(NSError **)error;

@end

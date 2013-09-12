//
//  PSPDFFileAnnotationProvider.h
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
#import "PSPDFAnnotationProvider.h"
#import "PSPDFDocument.h"

@class PSPDFLinkAnnotation, PSPDFDocument;

/// Default implementation of the `PSPDFAnnotationProvider` protocol that uses the PDF document as source/target to load/save annotations. You almost always want to use the `PSPDFFileAnnotationProvider` in your `PSPDFAnnotationManager`. You can also use the `PSPDFFileAnnotationProvider` inside a custom annotation provider, to parse PDF annotations once and then manage them in your custom database.
@interface PSPDFFileAnnotationProvider : NSObject <PSPDFAnnotationProvider>

/// Designated initializer.
- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Associated documentProvider.
@property (nonatomic, weak) PSPDFDocumentProvider *documentProvider;

/// Default annotation username. Defaults to nil.
/// Written as the "T" (title/user) property of newly created annotations.
@property (atomic, copy) NSString *defaultAnnotationUsername;

/// Set to enable auto-detection of various link types. Defaults to PSPDFTextCheckingTypeNone.
/// @warning Detecting links might be an expensive operation.
@property (nonatomic, assign) PSPDFTextCheckingType autodetectTextLinkTypes;

/**
 Performance optimized access.

 The default implementation is lazy loaded (and of course thread safe); hitting a dictionary cache first and blocks if no cache is found. After the first expensive call, this method is basically free. Ensure that you're using a similar cache if you replace this method with your own.
*/
- (NSArray *)annotationsForPage:(NSUInteger)page pageRef:(CGPDFPageRef)pageRef;

/**
 You can add your own annotations (like videos, links) here.
 @note Usually it's a better idea to implement a custom AnnotationProvider, but this is kept for backwards compatibility.

 You will override any already set annotations, so if you want to mix in annotations from the PDF, use addAnnotations:page: instead.
 Setting nil as annotations will re-evaluate the pdf for annotations on the next access. Use an empty array if you want to clear annotations instead.
*/
- (void)setAnnotations:(NSArray *)annotations forPage:(NSUInteger)page;

/// Will add the annotation to the current annotation array. Will accept any annotations.
- (NSArray *)addAnnotations:(NSArray *)annotations;

/// Annotations are either removed (PSPDFAnnotationsRemovedNotification) or soft-deleted if they are already saved in the PDF.
/// In case they are soft-deleted, a PSPDFAnnotationChangedNotification with isDeleted as keyPath is sent instead.
- (NSArray *)removeAnnotations:(NSArray *)annotations;

/// Removes all annotation and re-evaluates the document on next access.
- (void)clearCache;

/// Try to load annotations from file and set them if successful.
- (BOOL)tryLoadAnnotationsFromFileWithError:(NSError **)error;

/// Path where annotations are being saved if saving to external file is enabled.
/// Default's to self.documentProvider.document.cacheDirectory + "annotations_%d.pspdfkit" (%d = number of the documentProvider)
/// If set to nil, will revert back to the default value.
@property (nonatomic, copy) NSString *annotationsPath;

@end


@interface PSPDFFileAnnotationProvider (SubclassingHooks)

/// Parses the page annotation dictionary and returns the newly created annotations.
/// Want to customize annotations right after parsing? This is the perfect place.
/// Will be called from annotationsForPage:pageRef: in a thread safe manner and later cached.
- (NSArray *)parseAnnotationsForPage:(NSUInteger)page pageRef:(CGPDFPageRef)pageRef;

/// Saving code.
- (BOOL)saveAnnotationsWithOptions:(NSDictionary *)options error:(NSError **)error;

/// Load annotations (returning NO + eventually an error if it fails)
- (NSDictionary *)loadAnnotationsWithError:(NSError **)error;

/// Parses annotation link target. Override to support custom link protocols.
- (void)parseAnnotationLinkTarget:(PSPDFLinkAnnotation *)linkAnnotation;

/// Resolves a PSPDFKit-style URL to the appropriate NSURL.
+ (NSURL *)resolvePath:(NSString *)path forDocument:(PSPDFDocument *)document page:(NSUInteger)page;

/// Removes all annotations that are marked as deleted.
- (NSUInteger)removeDeletedAnnotations;

/// Ensure document/page references are set correctly before adding annotations. Used internally.
- (void)updateAnnotationsPageAndDocumentReference:(NSArray *)annotations page:(NSUInteger)page;

@end

//
//  PSPDFAnnotationParser.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFAnnotation.h"

@protocol PSPDFAnnotationView;
@class PSPDFDocumentProvider;

/**
    Parses and saves annotations for each page in a PDF.

    Can be subclassed to connect a custom annotation database.
    Use PSPDFDocument's overrideClassNames to subclass this correctly.
*/
@interface PSPDFAnnotationParser : NSObject

/// Initializes the annotation parser with the associated documentProvider.
- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/**
    Return annotation array for specified page.

    Note: fetching annotations may take a while. You can do this in a background thread.
 
    This method will be called OFTEN. Multiple times during a page display, and basically each time you're scrolling or zooming. Ensure it is fast.
 
    The default implementation is lazy loaded (and of course thread safe); hitting a dictionary cache first and blocks if no cache is found. After the first expensive call, this method is basically free. Ensure that you're using a similar cache if you replace this method with your own.
*/
- (NSArray *)annotationsForPage:(NSUInteger)page type:(PSPDFAnnotationType)type;

/// Return annotation array for specified page, use already open pageRef.
/// IF you subclass, subclass this method instead of annotationsForPage:type:.
/// pageRef might be nil or not; this is a pure performance improvement.
- (NSArray *)annotationsForPage:(NSUInteger)page type:(PSPDFAnnotationType)type pageRef:(CGPDFPageRef)pageRef;

/// Parses annotation link target. Override to support custom link protocols.
- (void)parseAnnotationLinkTarget:(PSPDFAnnotation *)annotation;

/// YES if annotations are loaded for a specific page. This is used to determine if annotationsForPage:type: should be called directly or in a background thread.
- (BOOL)hasLoadedAnnotationsForPage:(NSUInteger)page;

/// Returns the annotation classes used to represent the PSPDFAnnotation. Might return nil for certain types.
/// The classes all are a subtype of UIView <PSPDFAnnotationView>
/// If you implement custom overlay annotations, override this class.
- (Class)annotationClassForAnnotation:(PSPDFAnnotation *)annotation;

/// The fileType translation table is used when we encounter pspdfkit:// links.
/// Maps e.g. "mpg" to PSPDFLinkAnnotationVideo.
/// The ultimate fallback is PSPDFLinkAnnotationBrowser.
@property (nonatomic, copy) NSDictionary *fileTypeTranslationTable;

/// The annotation pageCache. Fills up as the documents are accessed.

/// You can add your own annotations (like videos, links) here.
/// You will override any already set annotations, so if you want to mix in annotations from the pdf,
/// use addAnnotations:forPage: instead.
///
/// Note: Setting nil as annotations will re-evaluate the pdf for annotations on the next access.
///       Use an empty array if you want to clear annotations instead.
- (void)setAnnotations:(NSArray *)annotations forPage:(NSUInteger)page;

/// Append annotations to a specific page.
- (void)addAnnotations:(NSArray *)annotations forPage:(NSUInteger)page;

/// Removes all annotation and re-evalutes the document on next access.
- (void)clearCache;

/// Try to load annotations from file and set them if successful.
- (BOOL)tryLoadAnnotationsFromFileWithError:(NSError **)error;

/// document provider for annotation parser. weak.
@property (nonatomic, ps_weak, readonly) PSPDFDocumentProvider *documentProvider;

/// Change the protocol that's used to parse pspdfkit-additions (links, audio, video)
/// Defaults to 'pspdfkit://'.
@property (nonatomic, copy) NSString *protocolString;

@end

@interface PSPDFAnnotationParser (SubclassingHooks)

/// Path where annotations are being saved.
/// Default's to self.documentProvider.document.cacheDirectory + "annotations.pspdfkit"
/// If set to nil, will return back to the default value.
@property (nonatomic, copy) NSString *annotationsPath;

/// Save annotations (returning NO + eventually an error if it fails)
- (BOOL)saveAnnotationsWithError:(NSError **)error;

/// Load annotations (returning NO + eventually an error if it fails)
- (NSDictionary *)loadAnnotationsWithError:(NSError **)error;

/// Annotation factory for built-in types.
/// Can be overridden, but usually reacting to the various annotation-delegate methods is enough.
- (UIView <PSPDFAnnotationView>*)createAnnotationViewForAnnotation:(PSPDFAnnotation *)annotation frame:(CGRect)annotationRect;

/// Searches the annotation cache for annptations that have the dirty flag set.
/// Dictionary key are the pages, object an array of annotations.
- (NSDictionary *)dirtyAnnotations;

/// Return all annotations.
- (NSDictionary *)annotations;

/// Removes all annotations that are marked as deleted.
- (NSUInteger)removeDeletedAnnotations;

/// Resolves a PSPDFKit-style URL to the appropriate NSURL.
+ (NSURL *)resolvePath:(NSString *)path forDocument:(PSPDFDocument *)document page:(NSUInteger)page;

@end

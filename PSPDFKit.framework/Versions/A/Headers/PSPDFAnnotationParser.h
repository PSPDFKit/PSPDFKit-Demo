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

/// Parses and saves annotations for each page in a PDF.
@interface PSPDFAnnotationParser : NSObject

/// Init annotation parser.
- (id)initWithDocumentProvider:(PSPDFDocumentProvider *)documentProvider;

/// Return annotation array for specified page.
/// Note: fetching annotations may take a while. You can do this in a background thread.
- (NSArray *)annotationsForPage:(NSUInteger)page type:(PSPDFAnnotationType)type;

/// Return annotation array for specified page, use already open pageRef.
- (NSArray *)annotationsForPage:(NSUInteger)page type:(PSPDFAnnotationType)type pageRef:(CGPDFPageRef)pageRef;

/// Parses annotation link target. Override to support custom link protocols.
- (void)parseAnnotationLinkTarget:(PSPDFAnnotation *)annotation;

/// YES if annotations are loaded for a specific page. Load annotations in a background thread.
- (BOOL)hasLoadedAnnotationsForPage:(NSUInteger)page;

/// Returns the annotation classed used to represent the PSPDFAnnotation. Might return nil for certain types.
- (Class)annotationClassForAnnotation:(PSPDFAnnotation *)annotation;

/// Annotation factory for built-in types.
/// Can be overridden, but usually reacting to the various annotation-delegate methods is enough.
- (UIView <PSPDFAnnotationView>*)createAnnotationViewForAnnotation:(PSPDFAnnotation *)annotation frame:(CGRect)annotationRect;

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

/// Searches the annotation cache for annptations that have the dirty flag set.
/// Dictionary key are the pages, object an array of annotations.
- (NSDictionary *)dirtyAnnotations;

- (NSDictionary *)annotations;

/// Removes all annotations that are marked as deleted.
- (NSUInteger)removeDeletedAnnotations;

/// document for annotation parser. weak.
@property(nonatomic, ps_weak, readonly) PSPDFDocumentProvider *documentProvider;

/// Change the protocol that's used to parse pspdfkit-additions (links, audio, video)
/// Defaults to 'pspdfkit://'.
@property(nonatomic, strong) NSString *protocolString;

@end

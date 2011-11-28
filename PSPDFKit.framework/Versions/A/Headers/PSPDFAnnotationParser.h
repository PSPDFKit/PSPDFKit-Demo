//
//  PSPDFAnnotationParser.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFDocument, PSPDFAnnotation;

enum {
    PSPDFAnnotationFilterNone     = 0,       // return all annotations
    PSPDFAnnotationFilterLink     = 1 << 0,  // return link annotations (web/page)
    PSPDFAnnotationFilterOverlay  = 1 << 1   // return overlay annotations
};
typedef NSUInteger PSPDFAnnotationFilter;

@interface PSPDFAnnotationParser : NSObject

/// init annotation parser
- (id)initWithDocument:(PSPDFDocument *)document;

/// return annotation array for specified page.
- (NSArray *)annotationsForPage:(NSUInteger)page filter:(PSPDFAnnotationFilter)filter;

/// return annotation array for specified page, use already open pageRef
- (NSArray *)annotationsForPage:(NSUInteger)page filter:(PSPDFAnnotationFilter)filter pageRef:(CGPDFPageRef)pageRef;

/// parses annotation link target. Override to support custom link prototols.
- (void)parseAnnotationLinkTarget:(PSPDFAnnotation *)annotation;

/// YES if annotations are loaded for a specific page. Load annotations in a background thread.
- (BOOL)hasLoadedAnnotationsForPage:(NSUInteger)page;

/// document for annotation parser. weak.
@property(nonatomic, assign, readonly) PSPDFDocument *document;

@end

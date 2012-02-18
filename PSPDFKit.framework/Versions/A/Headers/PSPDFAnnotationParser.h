//
//  PSPDFAnnotationParser.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFKitGlobal.h"
#import "PSPDFAnnotationView.h"

@class PSPDFDocument, PSPDFAnnotation;

enum {
    PSPDFAnnotationFilterNone       = 0,        // all annotations
    PSPDFAnnotationFilterLink       = 1 << 0,   // link annotations (web/page)
    PSPDFAnnotationFilterOverlay    = 1 << 1,   // overlay annotations
    PSPDFAnnotationFilterHighlight  = 1 << 2,   // highlight annotations
};
typedef NSUInteger PSPDFAnnotationFilter;

@interface PSPDFAnnotationParser : NSObject

/// init annotation parser
- (id)initWithDocument:(PSPDFDocument *)document;

/// return annotation array for specified page.
/// Note: fetching annotations may take a while. You can do this in a background thread.
- (NSArray *)annotationsForPage:(NSUInteger)page filter:(PSPDFAnnotationFilter)filter;

/// return annotation array for specified page, use already open pageRef
- (NSArray *)annotationsForPage:(NSUInteger)page filter:(PSPDFAnnotationFilter)filter pageRef:(CGPDFPageRef)pageRef;

/// parses annotation link target. Override to support custom link prototols.
- (void)parseAnnotationLinkTarget:(PSPDFAnnotation *)annotation;

/// YES if annotations are loaded for a specific page. Load annotations in a background thread.
- (BOOL)hasLoadedAnnotationsForPage:(NSUInteger)page;

/// Annotation factory for built-in types.
/// Can be overridden, but usually reacting to the various annotation-delegate methods is enough.
- (UIView <PSPDFAnnotationView>*)createAnnotationViewForAnnotation:(PSPDFAnnotation *)annotation frame:(CGRect)annotationRect;

/// The annotation pageCache. Fills up as the documents are accessed.

/// You can add your own annotations (like videos, links) here.
/// You will override any already set annotations, so if you want to mix in annotations from the pdf,
/// be sure to first access the array via annotationsForPage*.
///
/// Note: Setting nil as annotations will re-evaluate the pdf for annotations on the next access.
///       Use an empty array if you want to clear annotations instead.
- (void)setAnnotations:(NSArray *)annotations forPage:(NSUInteger)page;

/// document for annotation parser. weak.
@property(nonatomic, ps_weak, readonly) PSPDFDocument *document;

/// Change the protocol that's used to parse pspdfkit-additions. Defaults to 'pspdfkit://'.
@property(nonatomic, strong) NSString *protocolString;

@end

//
//  PSPDFAnnotationParser.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 8/6/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PSPDFDocument;

@interface PSPDFAnnotationParser : NSObject {
    PSPDFDocument *document_; // weak
    NSMutableDictionary *pageCache_;
    NSMutableDictionary *namedDestinations_;
}

/// init annotation parser
- (id)initWithDocument:(PSPDFDocument *)document;

/// return annotation array for specified page.
- (NSArray *)annotationsForPage:(NSUInteger)page;

/// return annotation array for specified page, use already open pageRef
- (NSArray *)annotationsForPage:(NSUInteger)page pageRef:(CGPDFPageRef)pageRef;

/// document for annotation parser. weak.
@property(nonatomic, assign, readonly) PSPDFDocument *document;

@end

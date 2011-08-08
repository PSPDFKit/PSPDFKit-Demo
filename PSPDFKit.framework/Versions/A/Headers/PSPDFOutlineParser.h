//
//  PSPDFOutlineParser.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 8/2/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFOutlineElement;

#define kPSPDFOutlineParserErrorDomain @"kPSPDFOutlineParserErrorDomain"

@interface PSPDFOutlineParser : NSObject {
    PSPDFDocument *document_;
    NSMutableDictionary *namedDestinations_;
    NSArray *outline_;
}

/// init outline parser with document
- (id)initWithDocument:(PSPDFDocument *)document;

/// parse document, return outline (PSDFOutlineElements)
- (NSArray *)parseDocument;

/// returns cached outline. starts parsing if outline is not yet created.
@property(nonatomic, retain, readonly) NSArray *outline;

/// resolves named destination entries, returns dict with name -> page NSNumber
+ (NSDictionary *)resolveDestNames:(NSSet *)destNames documentRef:(CGPDFDocumentRef)documentRef;

@end

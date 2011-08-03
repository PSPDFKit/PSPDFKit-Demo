//
//  PSPDFTOCParser.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 8/2/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFOutlineElement;

#define kPSPDFOutlineParserErrorDomain @"kPSPDFOutlineParserErrorDomain"

@interface PSPDFTOCParser : NSObject {
    PSPDFDocument *document_;
    NSMutableDictionary *namedDestinations_;
}

// main init
- (id)initWithDocument:(PSPDFDocument *)document;

// parse document, return outline (SPDFOutlineElements)
- (NSArray *)parseDocument;

@end

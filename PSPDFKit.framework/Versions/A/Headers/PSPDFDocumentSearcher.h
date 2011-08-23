//
//  PSPDFDocumentSearch.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/20/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFKit.h"

#define kSearchPreviewSubStringStart 20
#define kSearchPreviewSubStringEnd 60

// Helper class to extract text from a pdf
@interface PSPDFDocumentSearcher : NSObject {
    PSPDFDocument *document_;
    CGPDFOperatorTableRef table_;
    NSMutableDictionary *pageDict_;
    NSMutableString *currentData_;
}

// main init
- (id)initWithDocument:(PSPDFDocument *)document;

// YES if we extracted all text from the document
- (BOOL)isReadyToSearch;

// starts document parsing. further calls will be ignored.
- (void)parseDocument;

- (NSArray *)searchForString:(NSString *)searchText;

@property (nonatomic, assign, readonly) PSPDFDocument *document;

@end

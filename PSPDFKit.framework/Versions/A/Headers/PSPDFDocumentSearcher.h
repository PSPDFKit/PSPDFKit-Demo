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

/// Helper class to extract text from a pdf
@interface PSPDFDocumentSearcher : NSObject {
    PSPDFDocument *document_;
    CGPDFOperatorTableRef table_;
    NSMutableDictionary *pageDict_;
    NSMutableString *currentData_;
}

/// initialize with the document
- (id)initWithDocument:(PSPDFDocument *)document;

// YES if text could be extracted
- (BOOL)isReadyToSearch;

/// parses the document. further calls will be ignored.
- (void)parseDocument;

/// searches for text occurence. If document was not yet parsed, it will be now.
- (NSArray *)searchForString:(NSString *)searchText;

/// get text for a specific page. Page starts at 0. Returns nil if no text is available or page is incorrect.
- (NSString *)textForPage:(NSUInteger)page;

/// the document that was set
@property (nonatomic, assign, readonly) PSPDFDocument *document;

@end

//
//  PSPDFSearchResult.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFKit.h"

/// Search result object.
@interface PSPDFSearchResult : NSObject

/// Referenced document.
@property (nonatomic, assign) PSPDFDocument *document;

/// referenced page.
@property (nonatomic, assign) NSUInteger pageIndex;

/// preview text snippet.
@property (nonatomic, copy) NSString *previewText;

@end

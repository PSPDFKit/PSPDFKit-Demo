//
//  PSPDFSearchResult.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFWord, PSPDFDocument;

/// Search result object.
@interface PSPDFSearchResult : NSObject

/// Referenced document.
@property (nonatomic, ps_weak) PSPDFDocument *document;

/// referenced page.
@property (nonatomic, assign) NSUInteger pageIndex;

/// preview text snippet.
@property (nonatomic, copy) NSString *previewText;

/// Text coordinates. May not be set, expensive calculation.
@property (nonatomic, strong) PSPDFWord *selection;

/// Range within full page text.
@property (nonatomic, assign) NSRange range;

/// Range of the search result in relation to the previewText.
@property (nonatomic, assign) NSRange rangeInPreviewText;

/// Cached title of the outline chapter. Will be added dynamically on first access.
@property (nonatomic, copy) NSString *cachedOutlineTitle;

@end

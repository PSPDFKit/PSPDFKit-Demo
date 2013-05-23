//
//  PSPDFSearchResult.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFModel.h"

@class PSPDFTextBlock, PSPDFDocument;

/// Search result object.
@interface PSPDFSearchResult : PSPDFModel

/// referenced page.
@property (nonatomic, assign) NSUInteger pageIndex;

/// preview text snippet.
@property (nonatomic, copy) NSString *previewText;

/// Text coordinates. Usually the text block contains only one word, unless the search is split across two lines.
@property (nonatomic, strong) PSPDFTextBlock *selection;

/// Range within full page text.
@property (nonatomic, assign) NSRange range;

/// Range of the search result in relation to the previewText.
@property (nonatomic, assign) NSRange rangeInPreviewText;

/// Cached title of the outline chapter. Will be added dynamically on first access.
@property (nonatomic, copy) NSString *cachedOutlineTitle;

/// Referenced document.
@property (nonatomic, weak) PSPDFDocument *document;

/// Compare.
- (BOOL)isEqualToSearchResult:(PSPDFSearchResult *)otherSearchResult;

@end

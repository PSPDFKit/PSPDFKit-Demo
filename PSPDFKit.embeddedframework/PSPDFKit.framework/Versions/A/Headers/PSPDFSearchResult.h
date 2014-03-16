//
//  PSPDFSearchResult.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFModel.h"
#import "PSPDFAnnotation.h"

@class PSPDFTextBlock, PSPDFDocument;

/// Search result object.
@interface PSPDFSearchResult : PSPDFModel

/// Designated initializer.
- (id)initWithDocument:(PSPDFDocument *)document page:(NSUInteger)page range:(NSRange)range previewText:(NSString *)previewText rangeInPreviewText:(NSRange)rangeInPreviewText selection:(PSPDFTextBlock *)selection annotation:(PSPDFAnnotation *)annotation;

/// Referenced page.
@property (nonatomic, assign, readonly) NSUInteger pageIndex;

/// Preview text snippet.
@property (nonatomic, copy, readonly) NSString *previewText;

/// Text coordinates. Usually the text block contains only one word, unless the search is split across two lines.
@property (nonatomic, strong, readonly) PSPDFTextBlock *selection;

/// Range within full page text.
@property (nonatomic, assign, readonly) NSRange range;

/// Range of the search result in relation to the previewText.
@property (nonatomic, assign, readonly) NSRange rangeInPreviewText;

/// Referenced document.
@property (nonatomic, weak, readonly) PSPDFDocument *document;

/// If the search result references an annotation, the object is set.
@property (nonatomic, strong, readonly) PSPDFAnnotation *annotation;

/// Compare with other search result.
- (BOOL)isEqualToSearchResult:(PSPDFSearchResult *)otherSearchResult;

/// Cached title of the outline chapter. Will be added dynamically on first access.
@property (nonatomic, copy) NSString *cachedOutlineTitle;

@end

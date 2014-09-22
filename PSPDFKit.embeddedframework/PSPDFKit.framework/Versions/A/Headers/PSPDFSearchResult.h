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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFModel.h"
#import "PSPDFAnnotation.h"

@class PSPDFTextBlock, PSPDFDocument;

/// Immutable search result object.
@interface PSPDFSearchResult : PSPDFModel

/// Designated initializer.
- (instancetype)initWithDocumentUID:(NSString *)documentUID page:(NSUInteger)page range:(NSRange)range previewText:(NSString *)previewText rangeInPreviewText:(NSRange)rangeInPreviewText selection:(PSPDFTextBlock *)selection annotation:(PSPDFAnnotation *)annotation NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithDocument:(PSPDFDocument *)document page:(NSUInteger)page range:(NSRange)range previewText:(NSString *)previewText rangeInPreviewText:(NSRange)rangeInPreviewText selection:(PSPDFTextBlock *)selection annotation:(PSPDFAnnotation *)annotation;

/// Referenced page.
@property (nonatomic, assign, readonly) NSUInteger pageIndex;

/// Preview text snippet.
@property (nonatomic, copy, readonly) NSString *previewText;

/// Range of the search result in relation to the previewText.
@property (nonatomic, assign, readonly) NSRange rangeInPreviewText;

/// Range within full page text.
@property (nonatomic, assign, readonly) NSRange range;

/// The UID of the referenced document.
@property (nonatomic, copy, readonly) NSString *documentUID;

/// Text coordinates. Usually the text block contains only one word, unless the search is split across two lines.
/// @note This property is optional.
@property (nonatomic, strong, readonly) PSPDFTextBlock *selection;

/// Referenced document.
/// @note This property is optional, but required
@property (nonatomic, weak, readonly) PSPDFDocument *document;

/// If the search result references an annotation, the object is set.
/// @note This property is optional.
@property (nonatomic, weak, readonly) PSPDFAnnotation *annotation;

/// Compare with other search result.
- (BOOL)isEqualToSearchResult:(PSPDFSearchResult *)otherSearchResult;

@end

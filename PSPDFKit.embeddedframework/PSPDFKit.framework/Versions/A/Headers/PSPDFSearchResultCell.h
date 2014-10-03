//
//  PSPDFSearchResultCell.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKit.h"
#import "PSPDFTableViewCell.h"

/// Cell that is used to display a search result.
@interface PSPDFSearchResultCell : PSPDFTableViewCell <PSPDFCacheDelegate>

/// Will configure the cell with a search result model object.
/// @note This method will perform formatting and then calls `configureWithDocument:page:text:detailText:`
- (void)configureWithSearchResult:(PSPDFSearchResult *)searchResult;

/// Will configure the cell with the given document, page, text and detail text.
- (void)configureWithDocument:(PSPDFDocument *)document page:(NSUInteger)page text:(NSString *)text detailText:(NSAttributedString *)detailText;

/// Height calculation.
+ (CGFloat)heightForSearchResult:(PSPDFSearchResult *)searchResult numberOfPreviewLines:(NSUInteger)numberOfPreviewLines;

/// The associated document.
@property (nonatomic, weak, readonly) PSPDFDocument *document;

/// The search results page.
@property (nonatomic, assign, readonly) NSUInteger page;

/// Searches the outline for the most matching entry, displays e.g. "Section 100, Page 2" instead of just "Page 2".
/// @note Set before the cell is displayed.
@property (nonatomic, assign) BOOL useOutlineForPageNames;

@end

@interface PSPDFSearchResultCell (SubclassingHooks)

/// Page preview image.
@property (nonatomic, strong) UIImage *pagePreviewImage;

/// The placeholder image displayed while we're loading the page image.
- (UIImage *)placeholderImage;

/// Fonts used for the labels.
+ (UIFont *)textLabelFont;
+ (UIFont *)detailLabelFont;

@end

//
//  PSPDFSearchResultCell.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKit.h"

/// Cell that is used to display a search result.
@interface PSPDFSearchResultCell : UITableViewCell <PSPDFCacheDelegate>

/// Will configure the cell with a search result model object.
- (void)configureWithSearchResult:(PSPDFSearchResult *)searchResult;

/// Height calculation.
+ (CGFloat)heightForSearchResult:(PSPDFSearchResult *)searchResult numberOfPreviewLines:(NSUInteger)numberOfPreviewLines;

/// The associated document.
@property (atomic, weak, readonly) PSPDFDocument *document;

/// The search results page.
@property (atomic, assign, readonly) NSUInteger page;

@end

@interface PSPDFSearchResultCell (SubclassingHooks)

/// The preview label.
@property (nonatomic, strong, readonly) PSPDFAttributedLabel *searchPreviewLabel;

/// Page preview image.
@property (nonatomic, strong) UIImage *pagePreviewImage;

/// The placeholder image displayed while we're loading the page image.
- (UIImage *)placeholderImage;

/// Fonts used for the labels.
+ (UIFont *)textLabelFont;
+ (UIFont *)detailLabelFont;

@end

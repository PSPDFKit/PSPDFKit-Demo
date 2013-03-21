//
//  PSCDocumentSelectorCell.h
//  PSPDFCatalog
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSCDocumentSelectorCell : UITableViewCell

/// Set the page rect so that the image coords can be calculated even before the image is rendered/loaded from the cache.
@property (nonatomic, assign) CGRect rotatedPageRect;

/// Page preview image.
@property (nonatomic, strong) UIImage *pagePreviewImage;
- (void)setPagePreviewImage:(UIImage *)pagePreviewImage animated:(BOOL)animated;

// Associated document. Only for reference, not used.
@property (nonatomic, weak) PSPDFDocument *document;

@end

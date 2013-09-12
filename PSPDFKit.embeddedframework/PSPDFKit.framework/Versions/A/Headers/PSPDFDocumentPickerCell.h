//
//  PSPDFDocumentPickerCell.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

@class PSPDFDocument;

@interface PSPDFDocumentPickerCell : UITableViewCell

/// Set the page rect so that the image coords can be calculated even before the image is rendered/loaded from the cache.
@property (nonatomic, assign) CGRect rotatedPageRect;

/// Page preview image.
@property (nonatomic, strong) UIImage *pagePreviewImage;
- (void)setPagePreviewImage:(UIImage *)pagePreviewImage animated:(BOOL)animated;

// Only for reference, not used.
@property (nonatomic, weak) PSPDFDocument *document;
@property (nonatomic, assign) NSUInteger page;

@end

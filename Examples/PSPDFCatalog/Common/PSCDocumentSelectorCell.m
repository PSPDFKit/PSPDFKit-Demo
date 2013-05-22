//
//  PSCDocumentSelectorCell.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCDocumentSelectorCell.h"

@implementation PSCDocumentSelectorCell

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setDefaults];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];

    const CGFloat margin = 2;
    CGRect slice, rem = CGRectInset(self.bounds, margin, margin);
    rem.size.width -= margin * 3; // more text margin

    CGFloat scale = PSPDFScaleForSizeWithinSize(self.rotatedPageRect.size, CGSizeMake(80.f, CGRectGetHeight(self.frame)));
    CGRect imageRect = PSPDFRoundRect(CGRectMake(0, 0, self.rotatedPageRect.size.width * scale, self.rotatedPageRect.size.height * scale));

    PSPDFRectDivideWithPadding(rem, &slice, &rem, CGRectGetWidth(imageRect), margin*4, CGRectMinXEdge);
    self.imageView.frame = slice;
    self.textLabel.frame = rem;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    [self setDefaults];
}

- (void)setDefaults {
    self.rotatedPageRect = CGRectMake(0, 0, 210, 297); // A4
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)setPagePreviewImage:(UIImage *)pagePreviewImage {
    [self setPagePreviewImage:pagePreviewImage animated:NO];
}

- (void)setPagePreviewImage:(UIImage *)pagePreviewImage animated:(BOOL)animated {
    if (animated) [self.imageView.layer addAnimation:PSPDFFadeTransition() forKey:nil];
    self.imageView.image = pagePreviewImage ?: self.placeholderImage;

    if (pagePreviewImage) self.rotatedPageRect = (CGRect){.size=pagePreviewImage.size};
    [self layoutSubviews];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (UIImage *)placeholderImage {
    static __strong UIImage *placeholderImage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), NO, 1.0);
        placeholderImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    return placeholderImage;
}

@end

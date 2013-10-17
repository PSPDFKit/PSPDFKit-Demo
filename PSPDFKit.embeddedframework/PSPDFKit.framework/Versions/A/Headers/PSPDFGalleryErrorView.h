//
//  PSPDFGalleryErrorView.h
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

/// The error view used in PSPDFGalleryContentView and PSPDFGalleryViewController.
@interface PSPDFGalleryErrorView : UIView

/// The label used to display the title of the error.
@property (nonatomic, strong) UILabel *titleLabel;

/// The label used to display the subtitle of the error.
@property (nonatomic, strong) UILabel *subtitleLabel;

@end

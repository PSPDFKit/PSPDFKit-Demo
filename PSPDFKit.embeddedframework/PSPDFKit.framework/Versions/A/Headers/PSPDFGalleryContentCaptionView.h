//
//  PSPDFGalleryContentCaptionView.h
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

/// The caption view used in PSPDFGalleryContentCaptionView.
@interface PSPDFGalleryContentCaptionView : UIView

/// The label used to display the caption.
@property (nonatomic, strong) UILabel *label;

/// The content inset by which the label is inset within this view.
@property (nonatomic, assign) UIEdgeInsets contentInset;

@end

//
//  PSPDFMediaPlayerPlaceholderView.h
//  PSPDFKit
//
//  Copyright 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

/// A placeholder view that is displayed instead of the video if no video track is available.
@interface PSPDFMediaPlayerPlaceholderView : UIView

/// The placeholder image. This should be considered a template and will be used as a mask.
@property (nonatomic, strong) UIImage *placeholderImageTemplate;

/// The start color of the gradient. The gradient goes from top to bottom.
@property (nonatomic, copy) UIColor *gradientStartColor;

/// The end color of the gradient. The gradient goes from top to bottom.
@property (nonatomic, copy) UIColor *gradientEndColor;

@end

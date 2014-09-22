//
//  PSPDFGalleryContentLoadingView.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import "PSPDFGalleryContentViewProtocols.h"

/// A round progress view used in `PSPDFContentView`.
@interface PSPDFGalleryContentLoadingView : UIView <PSPDFGalleryContentViewLoading>

/// The current progress. Must be between 0.0 and 1.0.
@property (nonatomic, assign) CGFloat progress;

/// The color that should be used to draw the view. Defaults to white.
@property (nonatomic, strong) UIColor *color;

@end

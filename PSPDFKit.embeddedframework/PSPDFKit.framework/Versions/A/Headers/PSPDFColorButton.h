//
//  PSPDFColorButton.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

/// Button that shows a selected color. Highlightable.
@interface PSPDFColorButton : UIButton

/// Current color.
@property (nonatomic, strong) UIColor *color;

/// Drawing mode.
@property (nonatomic, assign) BOOL displayAsEllipse;

/// Border width. Defaults to 3.0
@property (nonatomic, assign) CGFloat borderWidth;

/// Indicator size. Defaults to the bounds size
@property (nonatomic, assign) CGSize indicatorSize;

@end

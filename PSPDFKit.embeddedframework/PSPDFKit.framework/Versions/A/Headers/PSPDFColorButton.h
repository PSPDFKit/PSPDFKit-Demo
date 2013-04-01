//
//  PSPDFColorButton.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
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

@end

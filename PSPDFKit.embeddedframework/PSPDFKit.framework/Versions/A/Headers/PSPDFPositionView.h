//
//  PSPDFPositionView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFViewController;

/// Displays the current page position at the bottom of the screen.
/// This class connects to the pdfController via KVO.
@interface PSPDFPositionView : UIView

/// UILabel used internally to show the text.
@property (nonatomic, strong, readonly) UILabel *label;

/// Margin that is between the text and this view. Defaults to 5.
@property (nonatomic, assign) CGFloat labelMargin;

/// Weak reference to the pdf controller. We use KVO for updates.
@property (nonatomic, unsafe_unretained) PSPDFViewController *pdfController;

/// Update view
- (void)updateAnimated:(BOOL)animated;

@end

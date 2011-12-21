//
//  PSPDFPositionView.h
//  PSPDFKit
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"

@class PSPDFViewController;

/// Displays the current page position.
@interface PSPDFPositionView : UIView

/// UILabel used internally to show the text.
@property(nonatomic, strong, readonly) UILabel *label;

/// Margin that is between the text and this view. Defaults to 5.
@property(nonatomic, assign) CGFloat labelMargin;

/// Weak reference to the pdf controller. We use KVO for updates.
@property(nonatomic, ps_weak) PSPDFViewController *pdfController;

@end

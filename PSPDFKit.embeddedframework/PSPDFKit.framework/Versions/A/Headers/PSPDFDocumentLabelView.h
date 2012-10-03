//
//  PSPDFDocumentLabelView.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFViewController;

@interface PSPDFDocumentLabelView : UIView

/// UILabel used internally to show the text.
@property (nonatomic, strong, readonly) UILabel *label;

/// Margin that is between the text and this view. Defaults to 5.
@property (nonatomic, assign) CGFloat labelMargin;

/// Weak reference to the pdf controller. We use KVO for updates.
@property (nonatomic, unsafe_unretained) PSPDFViewController *pdfController;

@end

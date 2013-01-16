//
//  PSPDFLabelView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFGradientView.h"

@class PSPDFViewController;

typedef NS_ENUM(NSUInteger, PSPDFLabelStyle) {
    PSPDFLabelStyleFlat,
    PSPDFLabelStyleBordered
};

@interface PSPDFLabelView : PSPDFGradientView

/// UILabel used internally to show the text.
@property (nonatomic, strong, readonly) UILabel *label;

/// Margin that is between the text and this view. Defaults to 5.
@property (nonatomic, assign) CGFloat labelMargin;

/// Customize label style. Defaults to PSPDFLabelStyleFlat.
@property (nonatomic, assign) PSPDFLabelStyle labelStyle;

/// Weak reference to the pdf controller. We use KVO for updates.
@property (nonatomic, unsafe_unretained) PSPDFViewController *pdfController;

/// Update view
- (void)updateAnimated:(BOOL)animated;

@end

@interface PSPDFLabelView (SubclassingHooks)

// Override to change KVO ovservers
- (NSArray *)KVOValues;

@end

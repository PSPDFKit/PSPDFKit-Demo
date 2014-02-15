//
//  PSPDFLabelView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFGradientView.h"

@class PSPDFViewController;

typedef NS_ENUM(NSUInteger, PSPDFLabelStyle) {
    PSPDFLabelStyleFlat,     // iOS 6 default.
    PSPDFLabelStyleBordered, // Bordered variant.
    PSPDFLabelStyleModern,   // Only works with iOS 7 and newer. Uses blur.
};

/// Base class to show a semi-transparent, rounded label.
@interface PSPDFLabelView : UIView

/// `UILabel` used internally to show the text.
@property (nonatomic, strong, readonly) UILabel *label;

/// Margin that is between the text and this view. Defaults to 2 on iPhone and 3 on iPad.
@property (nonatomic, assign) CGFloat labelMargin;

/// Customize label style. Defaults to `PSPDFLabelStyleFlat` on iOS6 and `PSPDFLabelStyleModern` on iOS7+.
@property (nonatomic, assign) PSPDFLabelStyle labelStyle;

/// Weak reference to the pdf controller. We use KVO for updates.
@property (nonatomic, unsafe_unretained) PSPDFViewController *pdfController;

/// Update view.
- (void)updateAnimated:(BOOL)animated;

@end

@interface PSPDFLabelView (SubclassingHooks)

// Override to change KVO observers.
- (NSArray *)KVOValues;

@property (nonatomic, strong, readonly) PSPDFGradientView *gradientView; // iOS 6 gradient

@end

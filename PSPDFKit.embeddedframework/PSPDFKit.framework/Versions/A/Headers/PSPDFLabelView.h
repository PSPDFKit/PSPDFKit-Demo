//
//  PSPDFLabelView.h
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
#import "PSPDFGradientView.h"

@class PSPDFViewController;

typedef NS_ENUM(NSUInteger, PSPDFLabelStyle) {
    PSPDFLabelStyleFlat,     // <= iOS6 default.
    PSPDFLabelStyleBordered,
    PSPDFLabelStyleModern,   // iOS7 and newer.
};

@interface PSPDFLabelView : PSPDFGradientView

/// UILabel used internally to show the text.
@property (nonatomic, strong, readonly) UILabel *label;

/// Margin that is between the text and this view. Defaults to 5.
@property (nonatomic, assign) CGFloat labelMargin;

/// Customize label style. Defaults to PSPDFLabelStyleFlat on iOS6 and PSPDFLabelStyleModern on iOS7+.
@property (nonatomic, assign) PSPDFLabelStyle labelStyle;

/// Weak reference to the pdf controller. We use KVO for updates.
@property (nonatomic, unsafe_unretained) PSPDFViewController *pdfController;

/// Update view
- (void)updateAnimated:(BOOL)animated;

@end

@interface PSPDFLabelView (SubclassingHooks)

// Override to change KVO observers
- (NSArray *)KVOValues;

@end

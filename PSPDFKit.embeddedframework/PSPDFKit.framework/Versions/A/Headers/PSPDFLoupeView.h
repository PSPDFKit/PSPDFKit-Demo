//
//  PSPDFLoupeView.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

typedef NS_ENUM(NSInteger, PSPDFLoupeViewMode) {
	PSPDFLoupeViewModeCircular,
	PSPDFLoupeViewModeDetailTop,
	PSPDFLoupeViewModeDetailBottom
};

/// Represents a loupe, modeled like the loupe used in UIKit.
@interface PSPDFLoupeView : UIView

/// Designated initializer.
- (id)initWithReferenceView:(UIView *)referenceView;

/// Loupe detail mode.
@property (nonatomic, assign) PSPDFLoupeViewMode mode;

/// Target size for PSPDFLoupeViewModeDetailTop/PSPDFLoupeViewModeDetailBottom.
@property (nonatomic, assign) CGSize targetSize;

// Since the loupe uses a UIWindow that is added on the fly, call this before making calculations with the superview.
- (void)prepareShow;

// Show Loupe, optionally animated (mimics the UIKit loupe animation)
- (void)showLoupeAnimated:(BOOL)animated;

// Hide Loupe, optionally animated (mimics the UIKit loupe animation)
- (void)hideLoupeAnimated:(BOOL)animated;

@end

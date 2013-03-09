//
//  PSPDFLoupeView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

typedef NS_ENUM(NSInteger, PSPDFLoupeViewMode) {
	PSPDFLoupeViewModeCircular,     // Curcular loupe
	PSPDFLoupeViewModeDetail,       // Detail (text selection) mode. No arrow.
	PSPDFLoupeViewModeDetailTop,    // Arrow at the botton. High gap.
	PSPDFLoupeViewModeDetailBottom  // Arrow at the bottom. Low gap.
};

extern const CGFloat PSPDFLoupeDefaultMagnification; // Defaults to Apple default 1.2

/// Represents a loupe, modeled like the loupe used in UIKit.
@interface PSPDFLoupeView : UIView

/// Shared loupe instance.
+ (instancetype)sharedLoupe;

/// Designated initializer.
/// @note Usually you only ever want one loupe on the screen, thus using sharedLoupe is preferred.
- (id)initWithReferenceView:(UIView *)referenceView;

/// Reference view. Can be set to any subview or the window.
@property (nonatomic, strong) UIView *referenceView;

/// Loupe detail mode. Defaults to PSPDFLoupeViewModeCircular.
@property (nonatomic, assign) PSPDFLoupeViewMode mode;

/// Position of the loupe in reference to the referenceView.
@property(nonatomic, assign) CGPoint touchPoint;

/// The default mangnification is set to PSPDFLoupeDefaultMagnification.
@property(nonatomic, assign) CGFloat magnification;

// Show loupe, optionally animated.
- (void)showLoupeAnimated:(BOOL)animated;

// Hide loupe, optionally animated.
- (void)hideLoupeAnimated:(BOOL)animated;

@end

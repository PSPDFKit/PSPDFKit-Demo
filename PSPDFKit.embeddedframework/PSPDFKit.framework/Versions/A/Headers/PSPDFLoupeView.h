//
//  PSPDFLoupeView.h
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

typedef NS_ENUM(NSInteger, PSPDFLoupeViewMode) {
    PSPDFLoupeViewModeCircular,     // Circular loupe
    PSPDFLoupeViewModeDetail,       // Detail (text selection) mode. No arrow.
    PSPDFLoupeViewModeDetailTop,    // Arrow at the bottom. High gap.
    PSPDFLoupeViewModeDetailBottom  // Arrow at the bottom. Low gap.
};

extern CGFloat PSPDFLoupeDefaultMagnification; // Defaults to 1.2 on iPad and 1.6 on iPhone.

/// Represents a loupe, modeled like the loupe used in UIKit.
@interface PSPDFLoupeView : UIView

/// Shared loupe instance.
+ (instancetype)sharedLoupe;

/// Returns YES if the singleton has been loaded already.
+ (BOOL)isSharedLoupeLoaded;

/// Designated initializer.
/// @note Usually you only ever want one loupe on the screen, thus using sharedLoupe is preferred.
- (id)initWithReferenceView:(UIView *)referenceView;

/// Reference view. Can be set to any subview or the window.
@property (nonatomic, strong) UIView *referenceView;

/// Loupe detail mode. Defaults to PSPDFLoupeViewModeCircular.
@property (nonatomic, assign) PSPDFLoupeViewMode mode;

/// Position of the loupe in reference to the referenceView.
@property (nonatomic, assign) CGPoint touchPoint;

/// The default magnification is set to PSPDFLoupeDefaultMagnification.
@property (nonatomic, assign) CGFloat magnification;

// Show loupe, optionally animated.
- (void)showLoupeAnimated:(BOOL)animated;

// Hide loupe, optionally animated.
- (void)hideLoupeAnimated:(BOOL)animated;

@end

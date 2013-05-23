//
//  PSPDFBrightnessViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseViewController.h"
#import "PSPDFGradientView.h"

///
/// Controller to change the brightness.
///
@interface PSPDFBrightnessViewController : PSPDFBaseViewController

/// Enables software dimming. Defaults to YES.
@property (nonatomic, assign) BOOL wantsSoftwareDimming;

/// Enables software dimming to make the screen really dark. Defaults to YES.
@property (nonatomic, assign) BOOL wantsAdditionalSoftwareDimming;

/// Defaults to 0.3. Only relevant if wantsAdditionalSoftwareDimming is YES.
@property (nonatomic, assign) CGFloat additionalBrightnessDimmingFactor;

/// Defaults to 0.6. If you set this to 1 the screen will be *completely* dark.
/// Only relevant if wantsAdditionalSoftwareDimming is YES.
@property (nonatomic, assign) CGFloat maximumAdditionalBrightnessDimmingFactor;

@end

// Dimming view that is added to the main UIWindow.
@interface PSPDFDimmingView : UIView

// Software dimming factor.
@property (nonatomic, assign) CGFloat additionalBrightnessDimmingFactor;

@end


@interface PSPDFBrightnessViewController (SubclassingHooks)

// Slider used to regulate brightness.
@property (nonatomic, strong) UISlider *slider;

// Background gradient.
@property (nonatomic, strong) PSPDFGradientView *gradient;

// Used for additional software dimming.
- (PSPDFDimmingView *)dimmingView;

- (PSPDFDimmingView *)addDimmingView;

- (void)removeDimmingView;

@end

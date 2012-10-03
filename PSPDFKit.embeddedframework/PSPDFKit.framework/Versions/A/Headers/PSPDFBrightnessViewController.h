//
//  PSPDFBrightnessViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFBaseViewController.h"

/// Controller to change the brightness. iOS5 and later.
@interface PSPDFBrightnessViewController : PSPDFBaseViewController

/// Enables software dimming. Defaults to YES.
@property (nonatomic, assign) BOOL wantsSoftwareDimming;

/// Enables software dimming to make the screen really dark. Defaults to YES.
@property (nonatomic, assign) BOOL wantsAdditionalSoftwareDimming;

/// Defaults to 0.3. Only relevant if wantsAdditionalSoftwareDimming is YES.
@property (nonatomic, assign) CGFloat additionalBrightnessDimmingFactor;

@end

// Dimming view that is added to the main UIWindow.
@interface PSPDFDimmingView : UIView
@property (nonatomic, assign) CGFloat additionalBrightnessDimmingFactor;
@end

@interface PSPDFBrightnessViewController (SubclassingHooks)

// Slider used to regulate brightness
@property (nonatomic, strong) UISlider *slider;

// used for additional software dimming
- (PSPDFDimmingView *)dimmingView;
- (PSPDFDimmingView *)addDimmingView;
- (void)removeDimmingView;

@end
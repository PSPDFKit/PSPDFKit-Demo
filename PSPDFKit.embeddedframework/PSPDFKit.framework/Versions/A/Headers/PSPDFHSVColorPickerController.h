//
//  PSPDFHSVColorPickerController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFBaseViewController.h"
#import "PSPDFColorPickerView.h"
#import "PSPDFBrightnessSlider.h"
#import "PSPDFColorSelectionViewController.h"

/// Advanced HSV color picker with loupe feature.
@interface PSPDFHSVColorPickerController : PSPDFBaseViewController <PSPDFColorPickerViewDelegate>

/// Designated initializer.
- (id)init;

/// Will be set via delegate on viewWillAppear, but can be modified here as well.
@property (nonatomic, strong) UIColor *selectionColor;

/// Border. Defaults to 10,10,10,10.
@property (nonatomic, assign) UIEdgeInsets margin;

/// Internally used picker view. Allows certain customizations.
@property (nonatomic, strong, readonly) PSPDFColorPickerView *colorPicker;

/// Color brightness slider.
@property (nonatomic, strong, readonly) PSPDFBrightnessSlider *brightnessSlider;

/// Action delegate.
@property (nonatomic, weak) IBOutlet id<PSPDFColorSelectionViewControllerDelegate> delegate;

@end

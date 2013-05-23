//
//  PSPDFColorPickerView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//  Based on work of Ryan Sullivan. BSD licensed.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class PSPDFColorPickerView, PSPDFLoupeLayer, PSPDFBrightnessSlider;

/// Color Picker delegate.
@protocol PSPDFColorPickerViewDelegate <NSObject>

@optional

/// Color selection has been changed.
- (void)colorPickerDidChangeSelection:(PSPDFColorPickerView *)colorPicker finishedSelection:(BOOL)finished;

@end

/// Color Picker view control. (circle)
@interface PSPDFColorPickerView : UIControl

/// Current selection point.
@property (nonatomic, assign, readonly) CGPoint selection;

/// Set to YES to show a square with saturation on Y axis, No for saturation on radial axis.
@property (nonatomic, assign) BOOL cropToCircle;

/// Changes color distribution mode to orthogonal. Defaults to NO.
@property (nonatomic, assign) BOOL isOrthogonal;

/// Set to YES to show a loupe. Defaults to YES, unless old device.
@property (nonatomic, assign, getter=isLoupeEnabled) BOOL loupeEnabled;

@property (nonatomic, strong) UIColor *selectionColor;

@property (nonatomic, assign) CGFloat brightness;

/// Picker delegate
@property (nonatomic, weak) IBOutlet id<PSPDFColorPickerViewDelegate> delegate;

/// The internally used brightness slider.
@property (nonatomic, weak) IBOutlet PSPDFBrightnessSlider *brightnessSlider;

/// Conversion helper.
- (void)selectionToHue:(CGFloat *)pH saturation:(CGFloat *)pS brightness:(CGFloat *)pV;

/// Returns UIColor at a point in the PSPDFColorPickerView.
- (UIColor *)colorAtPoint:(CGPoint)point;

@end

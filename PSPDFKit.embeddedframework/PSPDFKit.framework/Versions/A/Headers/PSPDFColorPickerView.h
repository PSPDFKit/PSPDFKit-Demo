//
//  PSPDFColorPickerView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//  Based on work of Ryan Sullivan. BSD licensed.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class PSPDFColorPickerView, PSPDFLoupeLayer, PSPDFBrightnessSlider;

@protocol PSPDFColorPickerViewDelegate <NSObject>

@optional
- (void)colorPickerDidChangeSelection:(PSPDFColorPickerView *)colorPicker;

@end

@interface PSPDFColorPickerView : UIControl

@property (nonatomic, assign, readonly) CGPoint selection;

/// Set to YES to show a square with saturation on Y axis, No for saturation on radial axis.
@property (nonatomic, assign) BOOL cropToCircle;

@property (nonatomic, assign) BOOL isOrthoganal;

@property (nonatomic, strong) UIColor *selectionColor;

@property (nonatomic, assign) CGFloat brightness;

@property (nonatomic, weak) IBOutlet id<PSPDFColorPickerViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet PSPDFBrightnessSlider* brightnessSlider;

- (void)selectionToHue:(CGFloat *)pH saturation:(CGFloat *)pS brightness:(CGFloat *)pV;

- (UIColor*)colorAtPoint:(CGPoint)point; //Returns UIColor at a point in the RSColorPickerView

@end

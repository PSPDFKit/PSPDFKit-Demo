//
//  PSPDFBrightnessSlider.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//  Based on work of Ryan Sullivan. BSD licensed.
//

#import <Foundation/Foundation.h>

typedef enum {
    PSPDFThumbImageStyleDefault = 0,
    PSPDFThumbImageStyleHourGlass,
    PSPDFThumbImageStyleArrowLoop,
}PSPDFThumbImageStyle;

typedef enum {
    PSPDFSliderBackgroundStyleDefault = 0,
    PSPDFSliderBackgroundStyleGrayscale,
    PSPDFSliderBackgroundStyleColorful,
} PSPDFSliderBackgroundStyle;

@class PSPDFColorPickerView;

@interface PSPDFBrightnessSlider : UISlider

@property (nonatomic, assign) PSPDFThumbImageStyle thumbImageStyle;
@property (nonatomic, assign) PSPDFSliderBackgroundStyle backgroundStyle;
@property (nonatomic, weak) IBOutlet PSPDFColorPickerView* colorPicker;

- (void)updateBackground;

@end

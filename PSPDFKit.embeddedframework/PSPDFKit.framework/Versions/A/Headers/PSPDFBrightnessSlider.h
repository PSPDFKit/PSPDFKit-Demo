//
//  PSPDFBrightnessSlider.h
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
}PSPDFSliderBackgroundStyle;

@class PSPDFColorPickerView;

@interface PSPDFBrightnessSlider : UISlider

@property (nonatomic, assign) PSPDFThumbImageStyle thumbImageStyle;
@property (nonatomic, assign) PSPDFSliderBackgroundStyle backgroundStyle;
@property (nonatomic, weak) IBOutlet PSPDFColorPickerView *colorPicker;

- (void)updateBackground;

@end

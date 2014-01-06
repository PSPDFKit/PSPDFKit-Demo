//
//  PSPDFBrightnessSlider.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//  Based on work of Ryan Sullivan. BSD licensed.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PSPDFSliderBackgroundStyle) {
    PSPDFSliderBackgroundStyleDefault = 0,
    PSPDFSliderBackgroundStyleGrayscale,
    PSPDFSliderBackgroundStyleColorful,
};

@class PSPDFColorPickerView;

// Allows to customize the color brightness.
@interface PSPDFBrightnessSlider : UISlider

@property (nonatomic, assign) PSPDFSliderBackgroundStyle backgroundStyle;
@property (nonatomic, weak) IBOutlet PSPDFColorPickerView *colorPicker;

- (void)updateBackground;

@end

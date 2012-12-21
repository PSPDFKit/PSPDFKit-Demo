//
//  PSPDFColorSelectionViewController.m
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSPDFSimplePageViewController.h"

typedef NS_ENUM(NSUInteger, PSPDFColorPickerStyle) {
    PSPDFColorPickerStyleRainbow,
    PSPDFColorPickerStyleModern,
    PSPDFColorPickerStyleVintage,
    PSPDFColorPickerStyleMonochrome,
    PSPDFColorPickerStyleHSVPicker,
};

@protocol PSPDFColorSelectionViewControllerDelegate;

/// Beautiful color selection controller.
@interface PSPDFColorSelectionViewController : UIViewController

/// Used to show the color pickers in PSPDF. Uses defaultColorArrays.
+ (PSPDFSimplePageViewController *)defaultColorPickerWithTitle:(NSString *)title delegate:(id<PSPDFColorSelectionViewControllerDelegate>)delegate;

/// Set array of NSNumber-enums of PSPDFColorPickerStyle.
/// Defaults to @[@(PSPDFColorPickerStyleRainbow), @(PSPDFColorPickerStyleModern), @(PSPDFColorPickerStyleVintage), @(PSPDFColorPickerStyleMonochrome), @(PSPDFColorPickerStyleHSVPicker)].
+ (void)setDefaultColorPickerStyles:(NSArray *)colorPickerStyles;

/// Convenience initializers
+ (instancetype)monoChromeSelectionViewController;
+ (instancetype)modernColorsSelectionViewController;
+ (instancetype)vintageColorsSelectionViewController;
+ (instancetype)rainbowSelectionViewController;
+ (instancetype)colorSelectionViewControllerFromColors:(NSArray *)colorsArray addDarkenedVariants:(BOOL)darkenedVariants;

/// Helper that generates a color array from a saved plist. See PSPDFKit.bundle for examples.
+ (NSArray *)colorsFromPalletURL:(NSURL *)palletURL addDarkenedVariants:(BOOL)darkenedVariants;

/// Lazily evaluated. Set arrays of colors to change the default picker style.
/// Will reset to default if set to nil.
+ (void)setDefaultColorArrays:(NSArray *)defaultColorArrays;

/// Initialize with array of colors.
- (id)initWithColors:(NSArray *)colors;

/// Access the colors.
@property (nonatomic, copy, readonly) NSArray *colors;

/// Action delegate.
@property (nonatomic, weak) id <PSPDFColorSelectionViewControllerDelegate> delegate;

@end

/// Color picker delegate.
@protocol PSPDFColorSelectionViewControllerDelegate <NSObject>

@required

/// Asks for the currently selected color.
- (UIColor *)colorSelectionControllerSelectedColor:(UIViewController *)controller;

/// Sent when a color has been selected.
- (void)colorSelectionController:(UIViewController *)controller didSelectedColor:(UIColor *)color;

@end

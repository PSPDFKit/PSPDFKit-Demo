//
//  PSPDFColorSelectionViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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

@class PSPDFColorSelectionViewController;

/// Color picker delegate.
@protocol PSPDFColorSelectionViewControllerDelegate <NSObject>

@required

/// Asks for the currently selected color.
- (UIColor *)colorSelectionControllerSelectedColor:(UIViewController *)controller context:(void *)context;

/// Sent when a color has been selected.
- (void)colorSelectionController:(UIViewController *)controller didSelectColor:(UIColor *)color finishedSelection:(BOOL)finished context:(void *)context;

@end


/// The color selection controller shows pages of predefined colors, much like Apple's iWork/iOS apps.
/// The patterns are predefined in plist files located in the PSPDFKit.bundle. We pre-provide several styles, and you can also supply custom styles.
@interface PSPDFColorSelectionViewController : UIViewController

/// Used to show the color pickers in PSPDF. Uses `defaultColorArrays`.
/// `context` can be used to store additional context that gets sent to the delegates.
+ (PSPDFSimplePageViewController *)defaultColorPickerWithTitle:(NSString *)title wantTransparency:(BOOL)wantTransparency delegate:(id<PSPDFColorSelectionViewControllerDelegate>)delegate context:(void *)context;

/// Set array of `NSNumber`-enums of `PSPDFColorPickerStyle`.
/// Defaults to `@[@(PSPDFColorPickerStyleRainbow), @(PSPDFColorPickerStyleModern), @(PSPDFColorPickerStyleVintage), @(PSPDFColorPickerStyleMonochrome), @(PSPDFColorPickerStyleHSVPicker)]`.
+ (void)setDefaultColorPickerStyles:(NSArray *)colorPickerStyles;

/// Convenience initializers
+ (instancetype)monoChromeSelectionViewController;
+ (instancetype)modernColorsSelectionViewController;
+ (instancetype)vintageColorsSelectionViewController;
+ (instancetype)rainbowSelectionViewController;
+ (instancetype)colorSelectionViewControllerFromColors:(NSArray *)colorsArray addDarkenedVariants:(BOOL)darkenedVariants;

/// Helper that generates a color array from a saved plist. See PSPDFKit.bundle for examples.
+ (NSArray *)colorsFromPaletteURL:(NSURL *)paletteURL addDarkenedVariants:(BOOL)darkenedVariants;

/// Initialize with array of colors.
- (id)initWithColors:(NSArray *)colors;

/// Access the colors.
@property (nonatomic, copy, readonly) NSArray *colors;

/// Action delegate.
@property (nonatomic, weak) IBOutlet id<PSPDFColorSelectionViewControllerDelegate> delegate;

@end

@interface PSPDFColorSelectionViewController (SubclassingHooks)

+ (UIViewController *)colorPickerForType:(PSPDFColorPickerStyle)type;

@end

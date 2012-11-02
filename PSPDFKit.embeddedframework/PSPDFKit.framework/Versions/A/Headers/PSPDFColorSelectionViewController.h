//
//  PSPDFColorSelectionViewController.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@protocol PSPDFColorSelectionViewControllerDelegate;
@class PSPDFSimplePageViewController;

/// Flexible Color Picker.
@interface PSPDFColorSelectionViewController : UIViewController

/// Creates a new color picker on every access.
+ (PSPDFSimplePageViewController *)defaultColorPickerWithTitle:(NSString *)title delegate:(id<PSPDFColorSelectionViewControllerDelegate>)delegate;

/// Returns PSPDFColorSelectionViewController.
+ (id)monoChromeSelectionViewController;
+ (id)rainbowSelectionViewController;

/// Default initializer
- (id)initWithColors:(NSArray *)colors;

@property (nonatomic, weak) id<PSPDFColorSelectionViewControllerDelegate> delegate;

@end


/// Delegate for the color picker.
@protocol PSPDFColorSelectionViewControllerDelegate <NSObject>

@required
- (UIColor *)colorSelectionControllerSelectedColor:(PSPDFColorSelectionViewController *)controller;
- (void)colorSelectionController:(PSPDFColorSelectionViewController *)controller didSelectedColor:(UIColor *)color;

@end

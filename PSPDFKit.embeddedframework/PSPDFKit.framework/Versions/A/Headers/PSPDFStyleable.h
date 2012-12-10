//
//  PSPDFStyleable.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Implement on your UIViewController subclass to be able to match the style of PSPDFViewController.
 */
@protocol PSPDFStyleable <NSObject>

@optional

/// Tint color of the PSPDFViewController
@property (nonatomic, strong) UIColor *tintColor;

/// Proposed barStyle
@property (nonatomic, assign) UIBarStyle barStyle;

/// Transparency flag
@property (nonatomic, assign) BOOL isBarTranslucent;

/// Marks if this controller is displayed in a UIPopoverController
@property (nonatomic, assign) BOOL isInPopover;

/// Controls if the UIBarButtonItems should be tinted specially. Only needed for custom popover styles.
@property (nonatomic, assign) BOOL shouldTintToolbarButtons;

/// Enable to allow tinting of PSPDFAlertView.
@property (nonatomic, assign) BOOL shouldTintAlertView;

@end

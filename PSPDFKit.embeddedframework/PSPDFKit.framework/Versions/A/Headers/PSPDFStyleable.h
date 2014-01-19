//
//  PSPDFStyleable.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFStatusBarStyleHint.h"

/// Implement in your `UIViewController` subclass to be able to match the style of PSPDFViewController.
@protocol PSPDFStyleable <PSPDFStatusBarStyleHint>

@optional

/// Tint color of the `PSPDFViewController`.
@property (nonatomic, strong) UIColor *tintColor;

/// Proposed bar style.
@property (nonatomic, assign) UIBarStyle barStyle;

/// Transparency flag.
@property (nonatomic, assign) BOOL isBarTranslucent;

/// Marks if this controller is displayed in a `UIPopoverController`.
@property (nonatomic, assign) BOOL isInPopover;

/// Accesses the popover controller.
@property (nonatomic, weak) UIPopoverController *parentPopoverController;

/// Controls if the `UIBarButtonItems` should be tinted specially. Only needed for custom popover styles.
@property (nonatomic, assign) BOOL shouldTintToolbarButtons;

@end

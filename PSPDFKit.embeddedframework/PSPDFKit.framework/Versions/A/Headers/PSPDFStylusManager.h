//
//  PSPDFStylusManager.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFStylusDriverDelegate.h"
#import "PSPDFStylusTouch.h"
#import "PSPDFStylusDriver.h"
#import "PSPDFStylusViewController.h"

/// The stylus manager is the central point for pen/stylus management in PSPDFKit.
/// @note Drivers have to be linked externally, see the "Extras" folder in the PSPDFKit distribution.
/// Compatible driver classes will be automatically detected at runtime.
@interface PSPDFStylusManager : NSObject

/// Set the current pen type. Disables internal SDKs and re-enables selected one.
@property (nonatomic, assign) Class currentDriverClass;

/// The current pen connection status.
@property (nonatomic, assign, readonly) PSPDFStylusConnectionStatus connectionStatus;

/// Returns the name of the stylus, if possible. Will return "Stylus" if no name is returned by the driver.
@property (nonatomic, copy, readonly) NSString *stylusName;

/// Tries to restore last driver selection. Might load a driver and show the connection HUD.
- (BOOL)enableLastDriver;

/// Returns YES if the stylus manager could load drivers.
- (BOOL)driversAreAvailable;

/// Returns a new instance of the stylus connector/chooser controller.
/// @note Will always return a controller, even if no drivers are available.
- (PSPDFStylusViewController *)stylusController;

/// Native driver settings controller, if any.
- (UIViewController *)settingsControllerForCurrentDriver;
- (CGSize)embeddedSizeForSettingsController;
- (BOOL)hasSettingsControllerForDriverClass:(Class)driver;

/// @name View and Touch Management

/// Register views that should receive pen touches.
- (void)registerView:(UIView *)view;
- (void)unregisterView:(UIView *)view;

/// Touch classification, if supported by the driver.
- (BOOL)driverAllowsClassification;
- (id<PSPDFStylusTouch>)touchInfoForTouch:(UITouch *)touch;

/// @name Delegate Management

/// Register delegate for changes.
/// @note Delegates are weakly retained, but be a good citizen and manually deregister.
- (void)addDelegate:(id <PSPDFStylusDriverDelegate>)delegate;
- (void)removeDelegate:(id <PSPDFStylusDriverDelegate>)delegate;

@end

// Convert the `PSPDFStylusConnectionStatus` enum value to a string.
NSString *PSPDFStylusConnectionStatusToString(PSPDFStylusConnectionStatus connectionStatus);

// Notification is shtown when the `connectionStatus` changes.
extern NSString *const PSPDFStylusManagerConnectionStatusChangedNotification;


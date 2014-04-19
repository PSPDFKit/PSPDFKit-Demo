//
//  PSPDFStylusDriver.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFStylusDriverDelegate.h"
#import "PSPDFStylusTouch.h"
#import "PSPDFPlugin.h"

typedef NS_ENUM(NSUInteger, PSPDFStylusConnectionStatus) {
    PSPDFStylusConnectionStatusOff,
    PSPDFStylusConnectionStatusScanning,
    PSPDFStylusConnectionStatusPairing,
    PSPDFStylusConnectionStatusConnected,
    PSPDFStylusConnectionStatusDisconnected
};

// Abstract driver class for various styli.
@protocol PSPDFStylusDriver <PSPDFPlugin>

// Enable/Disable driver
- (BOOL)enableDriver:(NSError *__autoreleasing*)error options:(NSDictionary *)options;
- (void)disableDriver;

// Info of the connected stylus. Might also return data if the connection status is not connected.
- (NSDictionary *)connectedStylusInfo;

// Connection status of the pen managed by the driver.
@property (nonatomic, assign, readonly) PSPDFStylusConnectionStatus connectionStatus;

// Driver event delegate.
@property (nonatomic, weak, readonly) id<PSPDFStylusDriverDelegate> delegate;

@optional

// Optional touch classification.
- (id<PSPDFStylusTouch>)touchInfoForTouch:(UITouch *)touch;

// Returns a settings/pairing controller, if the driver supports this.
- (UIViewController *)settingsController;
- (NSDictionary *)settingsControllerInfo;

// View registration (optional, not all drivers need this)
- (void)registerView:(UIView *)view;
- (void)unregisterView:(UIView *)view;

@end

// Defines in the `options` key from the initializer
extern NSString * const PSPDFStylusDriverDelegateKey;

// Defines the `driverInfo` dictionary keys.
extern NSString * const PSPDFStylusDriverNameKey;
extern NSString * const PSPDFStylusDriverSDKNameKey;
extern NSString * const PSPDFStylusDriverSDKVersionKey;
extern NSString * const PSPDFStylusDriverProtocolVersionKey;
extern NSString * const PSPDFStylusDriverPriorityKey;

// Defines the `connectedStylusInfo` dictionary keys.
extern NSString * const PSPDFStylusNameKey;

// Defiles the `connectedStylusInfo` dictionary keys
extern NSString * const PSPDFStylusSettingsEmbeddedSizeKey;

// Protocol versions.
extern NSUInteger PSPDFStylusDriverProtocolVersion_1;
